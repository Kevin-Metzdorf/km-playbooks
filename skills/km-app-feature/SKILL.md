---
name: km-app-feature
description: Umsetzung eines Shopify-App-Features (React-Router-Template, Admin GraphQL, Extensions) aus einem Issue mit Akzeptanzkriterien. Verwenden, wenn ein freigegebenes App-Issue geplant und implementiert werden soll.
license: MIT
compatibility: "git, Shopify CLI, Projekt-Tooling laut AGENTS.md. Optional: gh CLI oder GitHub-MCP, Shopify Dev MCP."
---

# km-app-feature – App-Feature vom Issue zum PR

## Voraussetzungen (sonst stoppen)

- Freigegebenes Issue mit Akzeptanzkriterien.
- `AGENTS.md` gelesen (Stack, API-Version, Prüf-Befehle).

## Werkzeuge

- **Shopify-Prüfung:** über das Shopify Dev MCP. Ist es nicht verfügbar: installierte Shopify-Skills (z. B. `shopify-liquid`, `shopify-admin`) oder shopify.dev. Nicht Geprüftes als „ungeprüft“ kennzeichnen, nie aus dem Gedächtnis.
- **GitHub (Issues, PRs, Project):** über `gh` CLI oder ein GitHub-MCP. Ist keins verfügbar: benötigte Inhalte beim Nutzer erfragen, Texte zum Anlegen als Markdown ausgeben und die manuellen Schritte nennen.

## 1. Plan (vor jeder Änderung)

- Plan vorlegen und noch keine Datei ändern. Hat der Agent einen Plan-Modus, diesen nutzen.
- Betroffene Teile: Routes/Loader/Actions, GraphQL-Operationen, Datenbank (Prisma o. Ä.), Webhooks, Extensions, `shopify.app.toml`.
- Pro Planschritt die Kriterien-ID angeben; Lücken → Frage, nicht raten.
- **API-Version** aus `shopify.app.toml`/Code ermitteln und nennen.
- Benötigte **Access Scopes** prüfen; neue Scopes explizit als Änderung ausweisen (Merchant muss neu zustimmen).
- Webhooks und Datenschutz: Welche Daten werden gespeichert? Nur das Nötige; Pflicht-Webhooks (GDPR) berücksichtigen.
- Plan zur Bestätigung vorlegen. Erst nach ausdrücklicher Bestätigung umsetzen.

## 2. Umsetzung

- GraphQL-Operationen nachschlagen und **validieren** (siehe Werkzeuge), bevor sie verwendet werden.
- `userErrors` von Mutationen immer auswerten.
- Paginierung und Rate Limits (Kosten) berücksichtigen; Bulk Operations bei großen Datenmengen.
- UI: Polaris-Komponenten laut Projektstandard (App Home bzw. Admin-Extensions); Lade-, Fehler- und Leerzustände für jede Ansicht.
- Keine Tokens, Secrets oder personenbezogenen Daten loggen; Secrets nur über Umgebungsvariablen.

## 3. Prüfung

- Lint, Typecheck und Tests laut `AGENTS.md`.
- Manuell im Dev-Store gegen jedes Kriterium; Ergebnis notieren.
- `shopify app deploy` nur nach ausdrücklicher Freigabe.

## 4. PR

- PR-Vorlage, `Closes #<issue>`, Kriterien abhaken, API-Version und Scope-Änderungen nennen.
- Admin-Schritte (App-Konfiguration, Freigaben) als `admin-task`.

## Feste Regeln

- Keine Zugangsdaten, Tokens oder personenbezogenen Daten erfragen, loggen oder committen.
- Nie gegen einen Live-Shop testen ohne ausdrückliche Freigabe.
