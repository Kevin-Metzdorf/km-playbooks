#!/usr/bin/env bash
# Kopiert Issue-/PR-Vorlagen und die Spec-Vorlage in ein Projekt-Repo.
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
  if [ -e "$dst" ]; then
    echo "existiert, übersprungen: ${dst#"$DEST"/}"
  else
    cp "$src" "$dst"
    echo "angelegt: ${dst#"$DEST"/}"
  fi
}

for f in "$ROOT"/templates/.github/ISSUE_TEMPLATE/*.yml; do
  copy "$f" "$DEST/.github/ISSUE_TEMPLATE/$(basename "$f")"
done
copy "$ROOT/templates/.github/pull_request_template.md" "$DEST/.github/pull_request_template.md"
copy "$ROOT/docs/spec-vorlage.md" "$DEST/docs/specs/_vorlage.md"

if [ "$THEME_MODE" = true ]; then
  for f in "$ROOT"/templates/theme/.github/workflows/*.yml; do
    copy "$f" "$DEST/.github/workflows/$(basename "$f")"
  done
  copy "$ROOT/templates/theme/.theme-check.yml" "$DEST/.theme-check.yml"
fi

echo
echo "Nicht automatisch übernommen: templates/AGENTS.sdd-section.md"
echo "→ Abschnitt manuell in $DEST/AGENTS.md einfügen und anpassen."
