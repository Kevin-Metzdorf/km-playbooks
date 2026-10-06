#!/usr/bin/env bash
# Kopiert Issue-/PR-Vorlagen, die Spec-Vorlage und die Brücken CLAUDE.md/GEMINI.md in ein Projekt-Repo.
# Überschreibt nie vorhandene Dateien. Nutzung: ./scripts/apply-templates.sh <repo-pfad> [--theme]
set -euo pipefail

if [ $# -lt 1 ] || [ $# -gt 2 ] || [ ! -d "$1" ]; then
  echo "Nutzung: $0 <pfad-zum-projekt-repo> [--theme]" >&2
  exit 1
fi

THEME_MODE=false
if [ $# -eq 2 ]; then
  if [ "$2" != "--theme" ]; then
    echo "Nutzung: $0 <pfad-zum-projekt-repo> [--theme]" >&2
    exit 1
  fi
  THEME_MODE=true
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEST="$(cd "$1" && pwd)"

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

echo
echo "Nicht automatisch übernommen: skills/km-sdd-spec/assets/confluence-spec-seite.md (Kundenseiten werden separat veröffentlicht)"
echo "Nicht automatisch übernommen: templates/AGENTS.sdd-section.md"
echo "→ Abschnitt manuell in $DEST/AGENTS.md einfügen und anpassen."
if [ ! -e "$DEST/AGENTS.md" ]; then
  echo "Hinweis: $DEST/AGENTS.md fehlt noch; CLAUDE.md und GEMINI.md binden sie ein."
fi
