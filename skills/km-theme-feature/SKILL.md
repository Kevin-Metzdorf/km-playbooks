---
name: km-theme-feature
description: Umsetzung eines Shopify-Theme-Features (Section, Block, Snippet, Template) aus einem Issue mit Akzeptanzkriterien. Verwenden, wenn ein freigegebenes Theme-Issue geplant und implementiert werden soll.
---

# km-theme-feature – Theme-Feature vom Issue zum PR

## Voraussetzungen (sonst stoppen)

- Issue mit Akzeptanzkriterien existiert und ist freigegeben (nicht `needs-spec`/`needs-approval`).
- `AGENTS.md` gelesen (Basis-Theme, Konventionen, Prüf-Befehle).

## 1. Plan (Plan Mode)

- Betroffene Dateien: `sections/`, `blocks/`, `snippets/`, `templates/*.json`, `locales/`, `assets/`
- Für jeden Planschritt die Kriterien-ID angeben. Kriterien ohne Planschritt = Lücke → Frage stellen, nicht raten.
- Liquid-Objekte, Filter, Schema-Settings und Theme-Blocks über das Shopify Dev MCP prüfen.
- Admin-Abhängigkeiten (Metafield-/Metaobject-Definitionen, Menüs) benennen und als `admin-task` verlinken.
- Plan zur Bestätigung vorlegen.

## 2. Umsetzung

- Bestehende Patterns des Themes wiederverwenden (Snippets, CSS-Variablen, JS-Komponenten).
- Schema: sinnvolle Defaults, `info`-Texte für Redakteure, Presets, wo sinnvoll.
- Alle sichtbaren Texte über `locales/*.json`; Schema-Texte über `*.schema.json`, falls das Theme das nutzt.
- Bilder mit `image_url` + `image_tag`, `loading="lazy"` außerhalb des sichtbaren Bereichs, `width`/`height` gesetzt.
- Barrierefreiheit: semantisches HTML, Tastaturbedienung, Fokus sichtbar, ARIA nur wo nötig.
- Kein Inline-JS ohne Grund; JS nur laden, wenn die Section es braucht.

## 3. Prüfung

- `shopify theme check` (bzw. Befehl aus `AGENTS.md`) ohne neue Fehler.
- Shopify-Dev-MCP-Validierung für geänderte Liquid-Dateien.
- Preview nur in einem **unveröffentlichten** Theme (`shopify theme push --unpublished` bzw. Dev-Theme). Nie `--live`, nie das veröffentlichte Theme überschreiben.
- Jedes Kriterium einzeln prüfen und Ergebnis notieren.

## 4. PR

- PR-Vorlage nutzen, `Closes #<issue>`, jedes Kriterium abhaken oder begründen.
- Preview-Link und Screenshots (375 / 768 / 1280 px, sofern im Projekt nicht anders festgelegt).

## Feste Regeln

- `config/settings_data.json` nie ändern oder committen.
- Nie auf ein Live-Theme pushen.
- Keine Zugangsdaten oder personenbezogenen Daten.
