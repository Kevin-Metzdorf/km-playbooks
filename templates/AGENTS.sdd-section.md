## Arbeitsweise: Spec-Driven Development

<!-- Diesen Abschnitt in die AGENTS.md des Projekts übernehmen und anpassen. -->

- Specs liegen unter `docs/specs/`. Eine freigegebene Spec ist die Quelle der Wahrheit für das Verhalten eines Features.
- Ohne Issue mit Akzeptanzkriterien wird nichts umgesetzt. Ausnahme: offensichtliche Tippfehler.
- Vor der Umsetzung: Plan erstellen, jeder Schritt einem Akzeptanzkriterium zugeordnet.
- Weicht die Umsetzung von der Spec ab oder fehlt etwas: anhalten, offene Frage formulieren, nicht raten.
- Ein Branch und ein PR pro Issue. PR verwendet die PR-Vorlage und hakt jedes Kriterium einzeln ab.
- Arbeit im Shopify Admin (Metaobjects, Navigation, Redirects, Markets, Checkout, Apps) ist kein Code und läuft über `admin-task`-Issues.

### Projektspezifisch

- Basis-Theme / App-Template:
- Shopify-API-Version(en):
- Dev-Store / unveröffentlichtes Theme für Previews:
- Pflicht-Breakpoints / Browser:
- Performance-Ziele:
- Prüf-Befehle (Theme Check, Lint, Tests):
