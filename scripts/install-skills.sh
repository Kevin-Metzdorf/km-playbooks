#!/usr/bin/env bash
# Verlinkt alle Skills aus skills/ in die persönlichen Skill-Ordner der Agenten.
# Standard: ~/.agents/skills (Copilot, Codex, Cursor, Gemini CLI) und ~/.claude/skills (Claude Code).
# Andere Ziele: KM_SKILLS_DIRS="<ordner>:<ordner>" ./scripts/install-skills.sh
# Entfernt Links auf diese Skills aus ~/.copilot/skills (frühere Installation nur für Copilot).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LEGACY="$HOME/.copilot/skills"
IFS=':' read -r -a TARGETS <<< "${KM_SKILLS_DIRS:-$HOME/.agents/skills:$HOME/.claude/skills}"

legacy_is_target=false
for target in "${TARGETS[@]}"; do
  target="${target%/}"
  [ -n "$target" ] || continue
  [ "$target" = "$LEGACY" ] && legacy_is_target=true
  mkdir -p "$target"

  for dir in "$ROOT"/skills/*/; do
    src="${dir%/}"
    link="$target/$(basename "$src")"
    if [ -e "$link" ] && [ ! -L "$link" ]; then
      echo "übersprungen: $link existiert und ist kein Symlink"
    elif [ -L "$link" ] && [ "$(readlink "$link")" = "$src" ]; then
      echo "unverändert: $link"
    else
      ln -sfn "$src" "$link"
      echo "verlinkt: $link -> $src"
    fi
  done
done

# Nur eigene Links entfernen; andere Skills in ~/.copilot/skills bleiben.
if [ "$legacy_is_target" = false ] && [ -d "$LEGACY" ]; then
  for link in "$LEGACY"/*; do
    [ -L "$link" ] || continue
    case "$(readlink "$link")" in
      "$ROOT"/skills/*)
        rm "$link"
        echo "entfernt (alte Installation): $link"
        ;;
    esac
  done
fi
