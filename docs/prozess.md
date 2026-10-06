# SDD-Prozess

```
Anforderung → Spezifikation → Klärung & Freigabe → Plan → Implementierung → Prüfung
     ▲                                                                       │
     └──────────── neue Erkenntnis = Spec anpassen, nicht Code raten ────────┘
```

Jede Phase endet mit einem **Artefakt** und einem **Gate**. Erst wenn das Gate erfüllt ist, geht es weiter.

## Phasen

| # | Phase | Frage | Artefakt | Gate | Skill |
|---|-------|-------|----------|------|-------|
| 1 | Anforderung | Warum, was grob? | Epic-Issue | Ziel, Nicht-Ziele, Erfolgsmessung schriftlich | `km-sdd-spec` |
| 2 | Spezifikation | Was genau? | `docs/specs/<thema>.md` + Feature-Issues | Jedes Kriterium mit Ja/Nein prüfbar | `km-sdd-spec` |
| 3 | Klärung & Freigabe | Eindeutig und abgenommen? | Spec als Confluence-Seite veröffentlicht, offene Fragen beantwortet | Kunde hat auf der Confluence-Seite oder per Mail freigegeben (wer, wann, Version); Link im Epic eingetragen | `km-sdd-spec` |
| 4 | Plan | Wie, in welcher Reihenfolge? | Umsetzungsplan (Plan Mode) | Jeder Schritt ↔ ein Kriterium | Situations-Skill |
| 5 | Implementierung | Bauen | Branch + PR je Issue | CI/Theme Check grün, PR verlinkt Issue | Situations-Skill |
| 6 | Prüfung | Erfüllt es die Spec? | Review, Abnahme | Alle Kriterien ✅ | `km-pr-review` |

Für Theme-Repos gehören der grüne Theme-Check-Pflicht-Check und – wenn in der
Spec Performance-Ziele stehen – der Lighthouse-Lauf zur Prüfung. Einrichtung,
Secrets und Branch-Regel: [`docs/ci.md`](ci.md).

## Wann voll, wann schlank?

| Aufgabe | Vorgehen | Skill |
|---------|----------|-------|
| Relaunch, neue App, Checkout-/Admin-Extension | Voller Prozess, Spec-Dokument, alle Gates | `km-relaunch`, `km-app-feature` |
| Neue Section / neues Feature | Feature-Issue mit Kriterien + kurzer Plan | `km-theme-feature`, `km-app-feature` |
| Bug / kleine Änderung | Bug-Issue mit 1–3 Kriterien, direkt umsetzen | `km-bugfix` |

## GitHub Project

**Status-Spalten:** `Anforderung` → `Spec` → `Wartet auf Freigabe` → `Bereit` → `In Arbeit` → `Review` → `Abnahme` → `Done`

Empfohlene Zusatzfelder: `Typ` (Epic/Feature/Bug/Admin/CR), `Bereich` (Theme/App/Admin), `Aufwand` (S/M/L).

## Labels

Siehe `labels.yml`. Kern: `epic`, `feature`, `bug`, `admin-task`, `change-request`, `question`, `needs-spec`, `needs-approval`.

## Code vs. Shopify Admin

Alles, was im Shopify Admin passiert, ist **kein Code** und bekommt ein eigenes Issue mit Label `admin-task`:
Metafield-/Metaobject-Definitionen und Inhalte, Navigation, Redirects, Markets, Domains, Checkout-Einstellungen, App-Installation und -Konfiguration, Theme veröffentlichen.

## Feste Regeln

- `AGENTS.md` im Projekt-Repo ist die Quelle der Wahrheit für Stack, Konventionen und Definition of Done.
- `config/settings_data.json` wird nie angefasst.
- Nie auf ein Live-Theme pushen; immer unveröffentlichtes Theme oder Dev-Store.
- Shopify-API- und Liquid-Verhalten über das Shopify Dev MCP prüfen; API-Version nennen.
- Keine Zugangsdaten, Tokens oder personenbezogenen Daten in Issues, Logs oder Commits.

## Kunde und Confluence

GitHub ist die Werkstatt, Confluence das Schaufenster. Die Spec entsteht im Repo; die kundenlesbare Kopie (Vorlage `templates/confluence/spec-seite.md`) wird im Confluence-Bereich des Kunden veröffentlicht, dort werden Fragen beantwortet und Freigaben gegeben. Details: [`docs/kunde.md`](kunde.md).

## Change Requests

Alles, was nicht in der freigegebenen Spec steht, ist ein Change Request (Issue-Formular „Change Request“): Auswirkung auf Aufwand und Termin bewerten, Kunde gibt frei, dann Spec aktualisieren.
