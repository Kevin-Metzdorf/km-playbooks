#!/usr/bin/env bash
# Kundenfassung als secret Gist veröffentlichen (SDD-Ablauf, km-playbooks).
# Prüft die Markdown-Fassung auf interne Marker und legt sie als secret Gist an.
# Ein public Gist ist bewusst nicht möglich: Es gibt keinen Schalter dafür.
#
# Nutzung:
#   ./scripts/publish-kundenfassung.sh \
#     --kunde "De Berkel" --thema "Barrierefreiheits-Audit" \
#     --version 1.0 --datei pfad/zur/kundenfassung.md [--stand JJJJ-MM-TT] [--dry-run] [--force]
#
# Danach Gist-URL, Stand/Revision und Freigabe-Nachweis im Epic-Issue eintragen.
set -euo pipefail

usage() {
  cat >&2 <<'HILFE'
Nutzung: publish-kundenfassung.sh --kunde <Name> --thema <Thema> --version <x.y> --datei <pfad.md> [--stand JJJJ-MM-TT] [--dry-run] [--force]

  --kunde    Kunde/Projekt für den Gist-Titel
  --thema    Thema der Kundenfassung
  --version  Version der Fassung, z. B. 1.0
  --datei    Markdown-Datei der Kundenfassung
  --stand    Stand im Titel, Standard: heute
  --dry-run  Titel und Befehl zeigen, nichts anlegen, kein Netzwerk
  --force    EXTERN-Prüfung überspringen (nur bewusst; es wird gewarnt)
HILFE
}

KUNDE=""
THEMA=""
VERSION=""
DATEI=""
STAND="$(date +%F)"
DRY_RUN=false
FORCE=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --kunde)
      [ "$#" -ge 2 ] || { echo "Wert für --kunde fehlt." >&2; usage; exit 1; }
      KUNDE="$2"; shift 2 ;;
    --thema)
      [ "$#" -ge 2 ] || { echo "Wert für --thema fehlt." >&2; usage; exit 1; }
      THEMA="$2"; shift 2 ;;
    --version)
      [ "$#" -ge 2 ] || { echo "Wert für --version fehlt." >&2; usage; exit 1; }
      VERSION="$2"; shift 2 ;;
    --datei)
      [ "$#" -ge 2 ] || { echo "Wert für --datei fehlt." >&2; usage; exit 1; }
      DATEI="$2"; shift 2 ;;
    --stand)
      [ "$#" -ge 2 ] || { echo "Wert für --stand fehlt." >&2; usage; exit 1; }
      STAND="$2"; shift 2 ;;
    --dry-run) DRY_RUN=true; shift ;;
    --force) FORCE=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unbekannte Option: $1" >&2; usage; exit 1 ;;
  esac
done

if [ -z "$KUNDE" ] || [ -z "$THEMA" ] || [ -z "$VERSION" ] || [ -z "$DATEI" ]; then
  echo "Fehlende Pflichtangaben." >&2
  usage
  exit 1
fi

if [ ! -f "$DATEI" ]; then
  echo "Datei nicht gefunden: $DATEI" >&2
  exit 1
fi
case "$DATEI" in
  *.md) ;;
  *) echo "Nur Markdown-Dateien (.md) sind erlaubt: $DATEI" >&2; exit 1 ;;
esac
case "$STAND" in
  [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]) ;;
  *) echo "Stand muss JJJJ-MM-TT sein: $STAND" >&2; exit 1 ;;
esac
case "$VERSION" in
  [0-9]*.[0-9]*) ;;
  *) echo "Version muss wie 1.0 aussehen: $VERSION" >&2; exit 1 ;;
esac

# Interne Marker, die nicht in die Kundenfassung gehören (EXTERN-Regel AK-5.2).
MUSTER='api[-_ ]?version|docs/specs/|code vs\.? admin|ak-[0-9]|intern(er|e)? aufwand|bearer |token|passwort|password'
TREFFER="$(grep -nEi "$MUSTER" "$DATEI" || true)"

if [ -n "$TREFFER" ] && [ "$FORCE" != true ]; then
  {
    echo "EXTERN-Prüfung fehlgeschlagen: interne Marker in $DATEI:"
    echo "$TREFFER"
    echo
    echo 'Entferne API-Versionen, Repo-Pfade, "Code vs. Admin", AK-IDs, interne Aufwaende'
    echo "und Zugangsdaten. Nur wenn das bewusst gewollt ist: --force (wird gewarnt)."
  } >&2
  exit 2
fi
if [ -n "$TREFFER" ] && [ "$FORCE" = true ]; then
  echo "WARNUNG: EXTERN-Prüfung mit --force übersprungen; interne Marker bleiben in der Kundenfassung:" >&2
  echo "$TREFFER" >&2
fi

TITEL="$KUNDE – $THEMA · Stand $STAND · v$VERSION"
echo "Titel: $TITEL"
echo "Hinweis: secret Gist = linkgeschützt, nicht zugriffsgeschützt. Keine Preise, Verträge oder personenbezogenen Daten." >&2

if [ "$DRY_RUN" = true ]; then
  echo "Dry-Run: gh gist create --secret --desc \"$TITEL\" \"$DATEI\""
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI fehlt: https://cli.github.com" >&2
  exit 1
fi
if ! gh auth status >/dev/null 2>&1; then
  echo "gh ist nicht eingeloggt: gh auth login" >&2
  exit 1
fi

URL="$(gh gist create --secret --desc "$TITEL" "$DATEI")"
echo "Gist: $URL"
echo "Titel: $TITEL"
echo "Nächster Schritt: Gist-URL, Stand/Revision und Freigabe-Nachweis im Epic-Issue eintragen."
