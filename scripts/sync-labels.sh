#!/usr/bin/env bash
# Legt die Labels aus labels.yml in einem GitHub-Repo an bzw. aktualisiert sie.
# Löscht keine bestehenden Labels. Nutzung: ./scripts/sync-labels.sh owner/repo
# Voraussetzungen: gh (angemeldet), python3
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Nutzung: $0 owner/repo" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO="$1"

python3 - "$ROOT/labels.yml" <<'PY' |
import sys, re
labels, cur = [], None
for line in open(sys.argv[1], encoding="utf-8"):
    m = re.match(r'\s*(-\s+)?(name|color|description):\s*"?(.*?)"?\s*$', line)
    if not m:
        continue
    if m.group(1):
        cur = {}
        labels.append(cur)
    cur[m.group(2)] = m.group(3)
for l in labels:
    print("\t".join([l["name"], l["color"], l.get("description", "")]))
PY
while IFS=$'\t' read -r name color desc; do
  gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" --force
done
