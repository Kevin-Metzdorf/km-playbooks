# Spec: Theme-CI im Playbook (Theme Check + Lighthouse CI)

| | |
|---|---|
| **Epic** | Kevin-Metzdorf/km-playbooks#2 |
| **Status** | Freigegeben (am 2026-10-03 von Kevin Metzdorf) |
| **Version** | 1.0 |
| **Bereich** | Theme (Werkzeug/Prozess) |
| **API-Version** | n/a: `shopify/theme-check-action@v2`, `shopify/lighthouse-ci-action@v1` |

## 1. Ziel

Alle Theme-Repos bekommen eine einheitliche, zentral gepflegte Qualitätsprüfung. Fehler in Liquid, Schema und Übersetzungen sowie Performance-Rückschritte sollen im PR auffallen, nicht erst im Store oder beim Kunden. Die Logik liegt einmal in `km-playbooks`, und jedes Projekt bindet sie mit wenigen Zeilen ein.

## 2. Erfolg

- Jedes aktive Theme-Repo hat Theme Check als Pflicht-Check vor dem Merge nach `main`.
- Ein neues Projekt bekommt die CI in unter 5 Minuten (Vorlage kopieren, Branch-Regel setzen).
- Lighthouse läuft in Projekten, deren Spec Performance-Ziele enthält, und schreibt die Scores in den PR.
- Eine Änderung am zentralen Workflow wirkt in allen Repos ohne Änderung dort, solange sie `@v1` referenzieren.

## 3. Umfang

**Enthalten**
- Wiederverwendbarer Workflow `theme-check.yml` (`workflow_call`) in `km-playbooks`
- Wiederverwendbarer Workflow `theme-lighthouse.yml` (`workflow_call`) in `km-playbooks`
- Aufrufer-Vorlagen unter `templates/.github/workflows/` für Theme-Repos
- Standard-`.theme-check.yml` als Vorlage
- Erweiterung von `apply-templates.sh` um eine Option für Theme-Repos (ohne Überschreiben)
- Doku `docs/ci.md`: Einbindung, Secrets, Branch-Regel, Grenzen; Verweis aus `docs/prozess.md` und der README
- Ergänzung der Spec-Vorlage: Lighthouse-Ziele (Seiten, Mindestwerte) als feste Felder
- Versions-Tag `v1` für stabile Referenzen
- Eigene kleine CI für `km-playbooks` (#8) (`actionlint` für Workflows, `shellcheck` für `scripts/*.sh`)
- Pilot in `km-cookstack`: Theme Check für die Theme-App-Extension `extensions/cookstack-recipe`. Gleichzeitig der erste vollständige SDD-Durchlauf (Epic → Spec → Freigabe → Plan → Umsetzung → Prüfung)

**Nicht enthalten (Nicht-Ziele)**
- Kein automatisches Deployment und kein `theme publish`; nie auf ein Live-Theme pushen
- Keine CI für Apps (`km-cookstack` und `km-shopify-app-template` haben eigene CI)
- Kein Rollout in die sieben Theme-Repos in diesem Epic; das folgt nach dem Pilot als eigene Issues
- Lighthouse wird gebaut und dokumentiert, aber nicht pilotiert (der Ziel-Store ist offen, siehe Frage 2; die App-Extension hat keine eigene Storefront)
- Kein Anlegen von Secrets, Dev-Dashboard-Apps oder Stores (Admin- bzw. GitHub-Einstellungen, `admin-task`)
- Kein Ändern von `config/settings_data.json`

## 4. Ist-Zustand

- `km-playbooks` hat keine Workflows. Die Vorlagen umfassen Issue- und PR-Vorlagen sowie den AGENTS-Abschnitt.
- Theme-Repos (alle privat, Standard-Branch `main`, ohne `.theme-check.yml`, ohne Workflows):

| Repo | Theme-Root | Hinweis |
|------|-----------|---------|
| Theme-Repo 1 | `.` | |
| Theme-Repo 2 | `.` | |
| Theme-Repo 3 | `.` | |
| Theme-Repo 4 | `.` | |
| Theme-Repo 5 | `.` | |
| Theme-Repo 6 | `.` | |
| Theme-Repo 7 | – | noch kein Theme-Code |

- `km-cookstack` (App, privat, `main`): hat bereits `.github/workflows/ci.yml` (Lint, Typecheck, Prisma, Test, Build). Enthält die Theme-App-Extension `extensions/cookstack-recipe` (`blocks/`, `assets/`, `locales/`) ohne `.theme-check.yml`.

- GitHub-Plan: Pro. Branch-Regeln für private Repos sind möglich; Actions-Minuten sind begrenzt (Kontingent des Pro-Plans).

## 5. Anforderungen & Akzeptanzkriterien

### 5.1 Wiederverwendbarer Workflow „Theme Check“

Issue: #3

- [ ] Datei `.github/workflows/theme-check.yml` mit `on: workflow_call`
- [ ] Eingaben: `theme_root` (Standard `.`), `flags` (Standard leer), `base` (Standard `main`)
- [ ] Funktioniert für Themes **und** Theme-App-Extensions (Konfiguration über `.theme-check.yml` im `theme_root`)
- [ ] Nutzt `shopify/theme-check-action@v2` mit `token: ${{ github.token }}`, damit Befunde als Annotationen an den geänderten Zeilen im PR erscheinen
- [ ] **Gegeben** ein PR mit Liquid-Fehler (Severity `error`), **wenn** die CI läuft, **dann** schlägt der Job fehl und der Fehler ist an der Zeile annotiert
- [ ] **Gegeben** ein PR nur mit Warnungen, **wenn** die CI läuft, **dann** ist der Job grün (Standard-Fail-Level `error`)
- [ ] Benötigt keine Secrets
- [ ] Job-Name ist stabil (`Theme Check`), damit er als Pflicht-Check auswählbar ist
- [ ] `permissions` minimal (`contents: read`, `checks: write`)

**Randfälle:** Theme in Unterordner (`theme_root: ./dist`), PR aus einem Fork (keine Schreibrechte für Annotationen → Job darf nicht deswegen fehlschlagen), leeres Repo ohne Theme-Dateien.

### 5.2 Wiederverwendbarer Workflow „Lighthouse“

Issue: #4

- [ ] Datei `.github/workflows/theme-lighthouse.yml` mit `on: workflow_call`
- [ ] Eingaben: `theme_root`, `min_performance` (Standard `0.6`), `min_accessibility` (Standard `0.9`), `product_handle`, `collection_handle`, `pull_theme` (alle optional)
- [ ] Secrets per `workflow_call.secrets`: `SHOP_STORE`, `SHOP_CLIENT_ID`, `SHOP_CLIENT_SECRET` (Pflicht), `SHOP_PASSWORD`, `LHCI_GITHUB_APP_TOKEN` (optional)
- [ ] Nutzt `shopify/lighthouse-ci-action@v1` mit Dev-Dashboard-App-Authentifizierung (`client_id` und `client_secret`)
- [ ] **Gegeben** fehlende Pflicht-Secrets, **wenn** der Workflow startet, **dann** bricht er mit einer verständlichen Meldung ab statt mit einem kryptischen Fehler
- [ ] **Gegeben** Scores unter den Mindestwerten, **wenn** die CI läuft, **dann** schlägt der Job fehl
- [ ] Läuft nur, wenn der Aufrufer es auslöst. Vorlage: bei PR mit Label `lighthouse` und manuell (`workflow_dispatch`), nicht bei jedem Push
- [ ] Die Doku erklärt die Messschwankung (5–10 Punkte) und empfiehlt Ziele mit Puffer

**Randfälle:** passwortgeschützter Store, Store ohne Produkte oder Kollektionen, gleichzeitige Läufe (`concurrency` pro PR), Läufe aus Forks (keine Secrets, Job überspringen statt fehlschlagen).

### 5.3 Vorlagen für Theme-Repos

Issue: #5

- [ ] `templates/theme/.github/workflows/ci.yml` ruft Theme Check auf: `uses: Kevin-Metzdorf/km-playbooks/.github/workflows/theme-check.yml@v1`, Trigger `pull_request` und `push` auf `main`
- [ ] `templates/theme/.github/workflows/lighthouse.yml` ruft Lighthouse auf (Label und manuell), mit Platzhaltern für die Werte aus der Spec
- [ ] `templates/theme/.theme-check.yml` mit `extends: theme-check:recommended` und Ignore für `node_modules/**`
- [ ] `templates/theme-app-extension/.theme-check.yml` mit `extends: theme-check:theme-app-extension`
- [ ] `apply-templates.sh <repo-pfad> --theme` kopiert zusätzlich die Theme-Vorlagen und überschreibt nie bestehende Dateien
- [ ] Bestehender Aufruf ohne `--theme` verhält sich unverändert

### 5.4 Dokumentation

Issue: #6

- [ ] `docs/ci.md` enthält:
  - Zweck beider Prüfungen
  - Wann Lighthouse sinnvoll ist
  - Einbindung in drei Schritten
  - Branch-Regel `Theme Check` als Pflicht-Check
  - Benötigte Secrets (nur Namen, keine Werte) und wo sie angelegt werden
  - Benötigte App-Berechtigungen (`read_products`, `write_themes`)
  - Empfehlung Dev- oder Staging-Store statt Kunden-Live-Store
  - Hinweis auf `pull_theme`
  - Versionierung `@v1`
- [ ] README und `docs/prozess.md` verweisen auf `docs/ci.md` (Schritt 6 „Prüfung“)
- [ ] `docs/spec-vorlage.md` Abschnitt 5.2: Lighthouse-Zeile mit Feldern für Seiten und Mindestwerte (Performance/Accessibility)
- [ ] Skill `km-pr-review` prüft, ob die CI grün ist, bevor Kriterien abgehakt werden

### 5.5 Versionierung

Issue: #7

- [ ] Nach dem Merge wird der Tag `v1` gesetzt; die Doku beschreibt, wann `v1` verschoben wird und wann `v2` entsteht (Breaking Change bei Eingaben)

### 5.6 Pilot in km-cookstack

Issue: Kevin-Metzdorf/km-cookstack#47 (abhängig von #3 und #7); Branch-Regel: Kevin-Metzdorf/km-cookstack#48

- [ ] `extensions/cookstack-recipe/.theme-check.yml` mit `extends: theme-check:theme-app-extension`
- [ ] Bestehende `ci.yml` bekommt einen zusätzlichen Job, der `theme-check.yml@v1` mit `theme_root: extensions/cookstack-recipe` aufruft; bestehende Jobs bleiben unverändert
- [ ] **Gegeben** ein Test-PR mit absichtlichem Liquid-Fehler im Block, **wenn** die CI läuft, **dann** ist `Theme Check` rot und der Fehler annotiert; nach Korrektur grün (Test-PR wird danach geschlossen, nicht gemergt)
- [ ] Bestehende Befunde in der Extension sind behoben oder begründet in `.theme-check.yml` deaktiviert
- [ ] `AGENTS.md` (Abschnitt Prüfbefehle) nennt `shopify theme check --path extensions/cookstack-recipe`
- [ ] PR-Vorlage enthält den Punkt „Theme Check grün“
- [ ] Branch-Regel für `main` mit Pflicht-Check `Theme Check` aktiv (`admin-task`, GitHub-Einstellungen)

### 5.7 Querschnitt

- [ ] Keine Zugangsdaten, Store-Domains von Kunden oder Tokens im Repo; nur Secret-**Namen**
- [ ] Alle Actions mit fester Hauptversion (`@v2`, `@v1`, `actions/checkout@v4`)
- [ ] Workflows bestehen `actionlint` (lokal oder in der Playbook-CI)

## 6. Code vs. Shopify Admin

| Im Repo | Außerhalb des Repos (`admin-task`) |
|---------|------------------------------------|
| Wiederverwendbare Workflows, Vorlagen, Doku, Skript | Dev-Dashboard-App mit `read_products` und `write_themes` anlegen und im Store installieren |
| `.theme-check.yml` pro Projekt | GitHub-Secrets pro Repo setzen (`SHOP_*`, `LHCI_GITHUB_APP_TOKEN`) |
| | Branch-Regel / Ruleset „Theme Check erforderlich“ pro Repo |
| | Lighthouse-GitHub-App installieren (optional, für Status-Checks) |

## 7. Abhängigkeiten & Risiken

- **Öffentlicher Workflow, private Aufrufer:** Wiederverwendbare Workflows aus öffentlichen Repos sind aus privaten Repos aufrufbar. Änderungen an `@v1` wirken sofort überall, deshalb sind Tags Pflicht.
- **Lighthouse lädt Themes in den Store:** Die Action legt unveröffentlichte Themes an. Gegen einen Kunden-Store nur mit Einverständnis und nie mit Veröffentlichung. Empfehlung: Dev-Store.
- **Theme-Limit pro Store:** Ein Store hat ein begrenztes Kontingent an Themes; Läufe könnten daran scheitern.
- **Actions-Minuten:** Private Repos verbrauchen Minuten aus dem Kontingent. Theme Check ist kurz, Lighthouse deutlich länger.
- **Bestandsbefunde:** Beim ersten Lauf in alten Repos sind viele Fehler möglich; der Pilot zeigt den Aufwand.
- **Messschwankung:** Lighthouse-Ergebnisse schwanken; zu harte Schwellen erzeugen rote Builds ohne echte Ursache.

## 8. Offene Fragen

| # | Frage | Antwort | Wer / Datum |
|---|-------|---------|-------------|
| 1 | Welches Repo ist Pilot? | `km-cookstack` (Theme-App-Extension), zugleich erster vollständiger SDD-Durchlauf | Kevin / 2026-10-03 |
| 2 | Lighthouse gegen welchen Store: eigener Dev-Store pro Kunde oder einer für alles? | Bewusst offen; blockiert nur einen späteren Lighthouse-Pilot | Kevin / 2026-10-03 |
| 3 | Theme Check zusätzlich bei Push auf Feature-Branches oder nur bei PR/`main`? Vorschlag: nur PR und `main` | Annahme: nur PR und Push auf `main` (Vorschlag übernommen) | Kevin / 2026-10-03 |
| 4 | Fail-Level: nur `error` (Vorschlag) oder auch `warning`? | Annahme: nur `error` (Vorschlag übernommen) | Kevin / 2026-10-03 |
| 5 | Soll `km-playbooks` selbst eine CI bekommen (`actionlint`, `shellcheck`)? Vorschlag: ja, klein | Annahme: ja, kleine CI mit `actionlint` und `shellcheck` (Vorschlag übernommen) | Kevin / 2026-10-03 |

## 9. Annahmen

- Referenz für Aufrufer ist der Tag `@v1`, nicht `@main`.
- Lighthouse nutzt die Dev-Dashboard-App-Authentifizierung; Legacy-Custom-App-Tokens werden nicht unterstützt.
- Standard-Schwellen: Performance 0.6, Accessibility 0.9. Projekte überschreiben sie aus ihrer Spec.
- Die Umsetzung läuft als Copilot-Projekt-Sitzung in `km-playbooks`; der Pilot als separate Sitzung im Pilot-Repo.

## 10. Änderungshistorie

| Version | Datum | Änderung |
|---------|-------|----------|
| 0.1 | | Entwurf |
| 0.2 | 2026-10-03 | Pilot = km-cookstack (Theme-App-Extension), Lighthouse-Store offen, Fragen 3–5 als Annahmen |
