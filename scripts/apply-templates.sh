#!/usr/bin/env bash
# Kopiert Issue-/PR-Vorlagen, die Spec-Vorlage und die Brücken CLAUDE.md/GEMINI.md in ein Projekt-Repo,
# mit --theme die Theme-CI-Vorlagen, mit --skills die Skills.
# Überschreibt nie vorhandene Dateien. Nutzung: ./scripts/apply-templates.sh <repo-pfad> [--theme] [--skills]
set -euo pipefail

usage() {
  echo "Nutzung: $0 <pfad-zum-projekt-repo> [--theme] [--skills]" >&2
  exit 1
}

if [ $# -lt 1 ] || [ ! -d "$1" ]; then
  usage
fi
REPO="$1"
shift

THEME_MODE=false
SKILLS_MODE=false
for opt in "$@"; do
  case "$opt" in
    --theme) THEME_MODE=true ;;
    --skills) SKILLS_MODE=true ;;
    *) usage ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$(cd "$REPO" && pwd)"

# Voraussetzung für --skills vor dem ersten Kopieren prüfen.
if [ "$SKILLS_MODE" = true ] && ! SKILLS_SHA="$(git -C "$ROOT" rev-parse HEAD 2>/dev/null)"; then
  echo "Fehler: --skills braucht einen git-Checkout von km-playbooks." >&2
  exit 1
fi

copy() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    echo "existiert, übersprungen: ${dst#"$DEST"/}"
  else
    cp "$src" "$dst"
    echo "angelegt: ${dst#"$DEST"/}"
  fi
}

# Vorlagen gezielt kopieren; die Confluence-Vorlage bleibt im Skill km-sdd-spec.
for f in "$ROOT"/templates/.github/ISSUE_TEMPLATE/*.yml; do
  copy "$f" "$DEST/.github/ISSUE_TEMPLATE/$(basename "$f")"
done
copy "$ROOT/templates/.github/pull_request_template.md" "$DEST/.github/pull_request_template.md"
copy "$ROOT/skills/km-sdd-spec/assets/spec-vorlage.md" "$DEST/docs/specs/_vorlage.md"

# Brücken für Agenten, die AGENTS.md nicht (immer) selbst lesen.
bridge() {
  local name="$1" line="$2" file="$DEST/$1"
  copy "$ROOT/templates/$name" "$file"
  if [ -L "$file" ]; then
    case "$(readlink "$file")" in
      AGENTS.md | ./AGENTS.md) return ;;
    esac
  fi
  if ! grep -Eqs '^@(\./)?AGENTS\.md[[:space:]]*$' "$file"; then
    echo "Warnung: $name bindet AGENTS.md nicht ein. Als erste Zeile einfügen: $line"
  fi
}
bridge CLAUDE.md "@AGENTS.md"
bridge GEMINI.md "@./AGENTS.md"

if [ "$THEME_MODE" = true ]; then
  for f in "$ROOT"/templates/theme/.github/workflows/*.yml; do
    copy "$f" "$DEST/.github/workflows/$(basename "$f")"
  done
  copy "$ROOT/templates/theme/.theme-check.yml" "$DEST/.theme-check.yml"
fi

# Skills aus dem letzten Commit: eine Kopie je Skill in .agents/skills,
# für Claude Code (liest .agents/ nicht) ein relativer Symlink in .claude/skills.
copy_skills() {
  local sha="$SKILLS_SHA" date src name dst link ver
  date="$(git -C "$ROOT" log -1 --format=%cs HEAD)"
  if [ -n "$(git -C "$ROOT" status --porcelain -- skills)" ]; then
    echo "Hinweis: Nicht committete Änderungen in skills/ werden nicht übernommen (Stand: Commit ${sha:0:7})."
  fi
  SKILLS_TMP="$(mktemp -d)"
  trap 'rm -rf "${SKILLS_TMP:-}"' EXIT
  git -C "$ROOT" archive HEAD skills | tar -x -C "$SKILLS_TMP"
  mkdir -p "$DEST/.agents/skills" "$DEST/.claude/skills"

  for src in "$SKILLS_TMP"/skills/*/; do
    src="${src%/}"
    name="$(basename "$src")"
    dst="$DEST/.agents/skills/$name"
    if [ -e "$dst" ] || [ -L "$dst" ]; then
      if diff -r -q -x .km-playbooks-version "$src" "$dst" >/dev/null 2>&1; then
        echo "aktuell: .agents/skills/$name"
      else
        ver="$(awk 'NR == 1 { print substr($2, 1, 7) }' "$dst/.km-playbooks-version" 2>/dev/null || true)"
        echo "abweichend: .agents/skills/$name (Kopie: ${ver:-unbekannt}, aktuell: ${sha:0:7}) – nicht überschrieben; zum Aktualisieren Ordner löschen und erneut ausführen"
      fi
    else
      cp -R "$src" "$dst"
      printf 'km-playbooks %s (%s)\nNicht hier bearbeiten: in km-playbooks ändern und mit apply-templates.sh --skills neu übernehmen.\n' \
        "$sha" "$date" > "$dst/.km-playbooks-version"
      echo "angelegt: .agents/skills/$name (Commit ${sha:0:7})"
    fi

    link="$DEST/.claude/skills/$name"
    if [ -L "$link" ] && [ "$(readlink "$link")" = "../../.agents/skills/$name" ]; then
      echo "unverändert: .claude/skills/$name"
    elif [ -e "$link" ] || [ -L "$link" ]; then
      echo "existiert, übersprungen: .claude/skills/$name"
    else
      ln -s "../../.agents/skills/$name" "$link"
      echo "verlinkt: .claude/skills/$name -> ../../.agents/skills/$name"
    fi
  done
}

if [ "$SKILLS_MODE" = true ]; then
  copy_skills
fi

echo
echo "Nicht automatisch übernommen: skills/km-sdd-spec/assets/confluence-spec-seite.md (Kundenseiten werden separat veröffentlicht)"
echo "Nicht automatisch übernommen: templates/AGENTS.sdd-section.md"
echo "→ Abschnitt manuell in $DEST/AGENTS.md einfügen und anpassen."
if [ ! -e "$DEST/AGENTS.md" ]; then
  echo "Hinweis: $DEST/AGENTS.md fehlt noch; CLAUDE.md und GEMINI.md binden sie ein."
fi
