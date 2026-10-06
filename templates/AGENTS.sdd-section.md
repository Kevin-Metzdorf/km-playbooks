## Arbeitsweise: Spec-Driven Development

<!-- Diesen Abschnitt in die AGENTS.md des Projekts übernehmen und anpassen.
     CLAUDE.md und GEMINI.md binden AGENTS.md ein; Regeln nur hier pflegen. -->

- Specs liegen unter `docs/specs/`. Eine freigegebene Spec ist die Quelle der Wahrheit für das Verhalten eines Features.
- Vor der Umsetzung: Plan erstellen, jeder Schritt einem Akzeptanzkriterium zugeordnet.
- Weicht die Umsetzung von der Spec ab oder fehlt etwas: anhalten, offene Frage formulieren, nicht raten.
- Ein Branch und ein PR pro Issue. PR verwendet die PR-Vorlage und hakt jedes Kriterium einzeln ab.
- Arbeit im Shopify Admin (Metaobjects, Navigation, Redirects, Markets, Checkout, Apps) ist kein Code und läuft über `admin-task`-Issues.

### Feste Regeln (gelten immer, auch ohne Skill)

- `config/settings_data.json` nie ändern oder committen; die Datei gehört dem Theme Editor.
- Nie auf ein Live-Theme pushen und kein Theme veröffentlichen (`shopify theme push --live`, `shopify theme publish`). Nur unveröffentlichte Themes oder Dev-Store.
- `shopify app deploy` nur nach ausdrücklicher Freigabe. Nie ohne ausdrückliche Freigabe gegen einen Live-Shop testen.
- Keine Zugangsdaten, Tokens oder personenbezogenen Daten erfragen, loggen oder committen.
- Ohne freigegebene Spec bzw. Issue mit Akzeptanzkriterien wird nichts umgesetzt. Ausnahme: offensichtliche Tippfehler.
- Shopify-Verhalten (Liquid, Admin GraphQL, Extensions) nicht aus dem Gedächtnis: über das Shopify Dev MCP oder shopify.dev prüfen und die API-Version nennen. Nicht Geprüftes als „ungeprüft“ kennzeichnen.

### Projektspezifisch

- Basis-Theme / App-Template:
- Shopify-API-Version(en):
- Dev-Store / unveröffentlichtes Theme für Previews:
- Pflicht-Breakpoints / Browser:
- Performance-Ziele:
- Prüf-Befehle (Theme Check, Lint, Tests):
