#!/usr/bin/env bash
# Verlinkt alle Skills aus skills/ nach ~/.copilot/skills (persönliche Copilot-Skills).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${COPILOT_SKILLS_DIR:-$HOME/.copilot/skills}"
mkdir -p "$TARGET"

for dir in "$ROOT"/skills/*/; do
  name="$(basename "$dir")"
  link="$TARGET/$name"
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    echo "übersprungen: $link existiert und ist kein Symlink"
    continue
  fi
  ln -sfn "${dir%/}" "$link"
  echo "verlinkt: $name -> $link"
done
