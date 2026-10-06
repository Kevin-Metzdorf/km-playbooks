---
name: km-pr-review
description: Review eines Pull Requests in Shopify-Theme- oder -App-Repos gegen AGENTS.md, das verknüpfte Issue und dessen Akzeptanzkriterien. Verwenden, wenn ein PR geprüft werden soll.
license: MIT
compatibility: "git. Optional: gh CLI oder GitHub-MCP, Shopify Dev MCP."
---

# km-pr-review – PR gegen Spec und AGENTS.md prüfen

## Werkzeuge

- **Shopify-Prüfung:** über das Shopify Dev MCP. Ist es nicht verfügbar: installierte Shopify-Skills (z. B. `shopify-liquid`, `shopify-admin`) oder shopify.dev. Nicht Geprüftes als „ungeprüft“ kennzeichnen, nie aus dem Gedächtnis.
- **GitHub (PR, Diff, Checks):** über `gh` CLI oder ein GitHub-MCP. Ist keins verfügbar: den lokalen Branch mit `git diff <basis>...HEAD` prüfen, den CI-Status als „nicht prüfbar“ melden statt abzuhaken und das Review als Markdown ausgeben.

## Vorgehen

1. `AGENTS.md` lesen (Konventionen, Definition of Done).
2. Verknüpftes Issue (`Closes #`) und ggf. Spec-Abschnitt lesen.
3. Diff vollständig lesen.
4. Prüfen, ob die relevanten CI-Checks grün sind; Theme-Kriterien erst danach abhaken. Fehlende oder rote Checks als nicht erfüllt/blockierend benennen.
5. Für **jedes Akzeptanzkriterium** feststellen: erfüllt / nicht erfüllt / nicht prüfbar aus dem Code – mit Beleg (Datei:Zeile).
6. Shopify-spezifisch prüfen (Liquid bzw. GraphQL verifizieren, siehe Werkzeuge; API-Version nennen).

## Prüfpunkte

- **Harte Regeln:** `config/settings_data.json` unverändert; kein Push auf Live-Theme vorgesehen; keine Secrets, Tokens oder personenbezogenen Daten.
- **Umfang:** Nur, was das Issue verlangt. Zusätzliches → eigener PR oder Change Request.
- **Theme:** Locales statt harter Texte, Schema-Defaults, Bild-Handling, Barrierefreiheit, unnötiges JS/CSS.
- **App:** `userErrors` ausgewertet, Scopes, Paginierung, Fehler-/Lade-/Leerzustände, keine Secrets im Code.
- **Admin-Abhängigkeiten** im PR benannt.
- **Prüfnachweis:** Preview-Link, Screenshots, Checks grün.

Keine Stil-Kleinigkeiten melden, die ein Linter abdeckt.

## Ausgabe

1. Ergebnis in einem Satz: mergebar / mit Änderungen / blockiert
2. Tabelle Akzeptanzkriterien: ID · Status · Beleg
3. Befunde nach Schweregrad (🔴 blockiert · 🟠 sollte · 🟡 kann), jeweils Datei:Zeile, Problem, Vorschlag
4. Offene Fragen an Autor oder Kunde
