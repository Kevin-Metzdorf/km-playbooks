#!/usr/bin/env bash
# Legt ein lokales Test-Repo für den Konformitätstest an (docs/agenten-test.md):
# minimales Theme, AGENTS.md, Brücken, Skills als Projektkopie, Testmaterial unter test/
# und den Branch feature/badges mit eingebauten Fehlern für T7. Kein GitHub-Remote.
# Nutzung: ./scripts/agenten-testrepo.sh <ziel> [--mit-claude-md]
set -euo pipefail

usage() {
  echo "Nutzung: $0 <ziel> [--mit-claude-md]" >&2
  exit 1
}

if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  usage
fi
WITH_CLAUDE_MD=false
if [ $# -eq 2 ]; then
  [ "$2" = "--mit-claude-md" ] || usage
  WITH_CLAUDE_MD=true
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -e "$1" ] && [ -n "$(ls -A "$1")" ]; then
  echo "Fehler: $1 existiert und ist nicht leer." >&2
  exit 1
fi
mkdir -p "$1"
Z="$(cd "$1" && pwd)"
case "$Z/" in
  "$ROOT"/*)
    rmdir "$Z" 2>/dev/null || true
    echo "Fehler: Das Test-Repo darf nicht in km-playbooks liegen." >&2
    exit 1
    ;;
esac

git -C "$Z" init -q
git -C "$Z" symbolic-ref HEAD refs/heads/main
git -C "$Z" config user.name "km-agenten-test"
git -C "$Z" config user.email "km-agenten-test@example.invalid"
mkdir -p "$Z/layout" "$Z/sections" "$Z/templates" "$Z/locales" "$Z/config" "$Z/test"

cat > "$Z/layout/theme.liquid" <<'EOF'
<!doctype html>
<html lang="{{ request.locale.iso_code }}">
  <head>
    <title>{{ page_title }}</title>
    {{ content_for_header }}
  </head>
  <body>
    {{ content_for_layout }}
  </body>
</html>
EOF

cat > "$Z/sections/hero.liquid" <<'EOF'
<section class="hero">
  <h1>{{ section.settings.heading | default: 'sections.hero.default_heading' | t }}</h1>
</section>

{% schema %}
{
  "name": "t:sections.hero.name",
  "settings": [
    { "type": "text", "id": "heading", "label": "t:sections.hero.heading" }
  ],
  "presets": [{ "name": "t:sections.hero.name" }]
}
{% endschema %}
EOF

cat > "$Z/templates/index.json" <<'EOF'
{
  "sections": { "hero": { "type": "hero" } },
  "order": ["hero"]
}
EOF

cat > "$Z/locales/de.default.json" <<'EOF'
{
  "sections": {
    "hero": { "default_heading": "Willkommen" }
  }
}
EOF

cat > "$Z/locales/de.default.schema.json" <<'EOF'
{
  "sections": {
    "hero": { "name": "Hero", "heading": "Überschrift" }
  }
}
EOF

cat > "$Z/config/settings_schema.json" <<'EOF'
[
  {
    "name": "theme_info",
    "theme_name": "km-testtheme",
    "theme_version": "0.1.0",
    "theme_author": "km-playbooks",
    "theme_documentation_url": "https://example.invalid",
    "theme_support_url": "https://example.invalid"
  }
]
EOF

cat > "$Z/config/settings_data.json" <<'EOF'
{
  "current": {
    "colors_accent": "#000000"
  }
}
EOF

{
  printf '# AGENTS.md – km-testtheme\n\nShopify-Theme für den Konformitätstest von km-playbooks. Kein echter Shop, kein Deployment.\n\n'
  # shellcheck disable=SC2016 # Backticks sind wörtlicher Markdown-Text, keine Befehlsersetzung.
  sed -e 's/^- Basis-Theme \/ App-Template:$/- Basis-Theme \/ App-Template: km-testtheme (minimal, Online Store 2.0)/' \
    -e 's/^- Shopify-API-Version(en):$/- Shopify-API-Version(en): keine (nur Theme)/' \
    -e 's/^- Dev-Store \/ unveröffentlichtes Theme für Previews:$/- Dev-Store \/ unveröffentlichtes Theme für Previews: keiner (nur lokal)/' \
    -e 's/^- Pflicht-Breakpoints \/ Browser:$/- Pflicht-Breakpoints \/ Browser: 375 \/ 768 \/ 1280 px/' \
    -e 's/^- Performance-Ziele:$/- Performance-Ziele: keine/' \
    -e 's/^- Prüf-Befehle (Theme Check, Lint, Tests):$/- Prüf-Befehle (Theme Check, Lint, Tests): `shopify theme check`/' \
    "$ROOT/templates/AGENTS.sdd-section.md"
} > "$Z/AGENTS.md"

if [ "$WITH_CLAUDE_MD" = true ]; then
  cat > "$Z/CLAUDE.md" <<'EOF'
# Projektnotizen

@AGENTS.md

- Antworten im Team auf Deutsch.
- Vor größeren Änderungen kurz Rücksprache halten.
EOF
fi

cat > "$Z/test/anforderung.md" <<'EOF'
Mail von Testshop GmbH:

Wir möchten auf der Startseite Vertrauenssiegel zeigen, also so etwas wie
„Kostenloser Versand ab 50 €“, „30 Tage Rückgabe“ und „Sichere Zahlung“.
Die Texte und Icons sollen unsere Redakteure selbst pflegen können.
Auf dem Handy sollen die Siegel untereinander stehen. Wäre schön, wenn das
bis Ende des Monats online ist.
EOF

cat > "$Z/test/issue-12.md" <<'EOF'
# Issue #12: Section „Trust Badges“

Status: freigegeben (Spec docs/specs/trust-badges.md v1.0, freigegeben von Testshop GmbH am 2026-10-01)

## Akzeptanzkriterien

- [ ] **AK-1.1** Gegeben die Section ist im Theme Editor auf der Startseite eingefügt, wenn 1–4 Badges (Block „Badge“: Icon-Bild, Text) angelegt sind, dann stehen sie ab 768 px nebeneinander und darunter untereinander.
- [ ] **AK-1.2** Gegeben kein Badge ist angelegt, wenn die Seite geladen wird, dann wird die Section nicht ausgegeben.
- [ ] **AK-1.3** Alle sichtbaren Standardtexte kommen aus `locales/*.json`.
- [ ] **AK-1.4** Icons werden mit `image_url` und `image_tag` ausgegeben, mit `width`/`height` und `loading="lazy"`.

## Code vs. Admin

Keine Admin-Aufgaben.
EOF

bash "$ROOT/scripts/apply-templates.sh" "$Z" --skills > /dev/null
git -C "$Z" add -A
git -C "$Z" commit -q -m "Test-Repo für den Konformitätstest"

# T7: Branch mit zwei eingebauten Verstößen (settings_data.json, harter Text).
git -C "$Z" switch -q -c feature/badges
cat > "$Z/sections/trust-badges.liquid" <<'EOF'
{% if section.blocks.size > 0 %}
  <ul class="trust-badges">
    {% for block in section.blocks %}
      <li {{ block.shopify_attributes }}>
        {{ block.settings.icon | image_url: width: 64 | image_tag: loading: 'lazy' }}
        <span>{{ block.settings.text | default: 'Kostenloser Versand' }}</span>
      </li>
    {% endfor %}
  </ul>
{% endif %}

{% schema %}
{
  "name": "Trust Badges",
  "blocks": [
    {
      "type": "badge",
      "name": "Badge",
      "settings": [
        { "type": "image_picker", "id": "icon", "label": "Icon" },
        { "type": "text", "id": "text", "label": "Text" }
      ]
    }
  ],
  "presets": [{ "name": "Trust Badges" }]
}
{% endschema %}
EOF
sed -i.bak 's/"colors_accent": "#000000"/"colors_accent": "#ff0000"/' "$Z/config/settings_data.json"
rm -f "$Z/config/settings_data.json.bak"
git -C "$Z" add -A
git -C "$Z" commit -q -m "Trust Badges Section (Closes #12)"
git -C "$Z" switch -q main

echo "Test-Repo angelegt: $Z"
echo "Branches: main, feature/badges (für T7). Ablauf: docs/agenten-test.md"
