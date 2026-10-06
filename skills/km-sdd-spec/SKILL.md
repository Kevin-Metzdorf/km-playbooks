---
name: km-sdd-spec
description: Spec-Driven Development für Shopify-Projekte (Theme und App). Verwenden, wenn eine neue Kundenanforderung in eine Spezifikation mit testbaren Akzeptanzkriterien, offene Fragen und GitHub-Issues überführt werden soll – vor jeder Umsetzung.
license: MIT
compatibility: "git. Optional: gh CLI oder GitHub-MCP, Shopify Dev MCP, Atlassian MCP."
---

# km-sdd-spec – Anforderung → Spec → Freigabe → Issues

Ziel: Aus einer losen Anforderung eine freigabefähige Spec machen. In diesem Skill wird **kein Code** geschrieben.

## Werkzeuge

- **Shopify-Prüfung:** über das Shopify Dev MCP. Ist es nicht verfügbar: installierte Shopify-Skills (z. B. `shopify-liquid`, `shopify-admin`) oder shopify.dev. Nicht Geprüftes als „ungeprüft“ kennzeichnen, nie aus dem Gedächtnis.
- **GitHub (Issues, PRs, Project):** über `gh` CLI oder ein GitHub-MCP. Ist keins verfügbar: benötigte Inhalte beim Nutzer erfragen, Texte zum Anlegen als Markdown ausgeben und die manuellen Schritte nennen.

## Vorab

1. `AGENTS.md` des Repos lesen. Sie hat Vorrang vor diesem Skill.
2. Vorhandene Specs unter `docs/specs/` und offene Issues prüfen, um Doppelungen zu vermeiden.
3. Shopify-Verhalten (Liquid, Admin GraphQL, Extensions) prüfen (siehe Werkzeuge) und die API-Version nennen.

## Phase 1 – Anforderung verstehen

- Ziel, Nutzer, Erfolgsmessung, Termin und Budget erfassen.
- Annahmen kurz notieren, statt jede Kleinigkeit zu fragen.
- Nur bei Unklarheiten zu Architektur, Umfang, Sicherheit oder Datenintegrität **eine Frage nach der anderen** stellen, möglichst mit Auswahl; ein Rückfrage-Werkzeug des Agenten nutzen, falls vorhanden.

## Phase 2 – Spec schreiben

Datei `docs/specs/<thema>.md` nach der Vorlage `docs/specs/_vorlage.md` im Projekt-Repo; fehlt sie, nach [assets/spec-vorlage.md](assets/spec-vorlage.md):

- Ziel, Erfolg, Umfang **und Nicht-Ziele**
- Ist-Zustand (bei Relaunch/Umbau)
- Akzeptanzkriterien im Format **Gegeben / Wenn / Dann**, jedes mit Ja/Nein prüfbar, mit ID (`AK-1.1`)
- Querschnittskriterien: Responsive, Barrierefreiheit, Performance, Locales, Pflegbarkeit im Theme Editor
- Abschnitt **Code vs. Admin**: Alles, was im Shopify Admin passiert (Metaobjects, Navigation, Redirects, Markets, Checkout, Apps, Veröffentlichung), als `admin-task` kennzeichnen.
- Risiken, offene Fragen, Annahmen, Versionshistorie

Qualitätsprüfung vor Abgabe:
- Kein Kriterium mit „schön“, „schnell“ oder „intuitiv“ ohne Messwert
- Randfälle bedacht: leer, ausverkauft, lange Texte, fehlende Bilder, Fehler, keine Berechtigung
- Jedes Ziel durch mindestens ein Kriterium abgedeckt

## Phase 3 – Klärung und Freigabe (Gate)

- Nach dem Spec-Entwurf eine kundenlesbare Confluence-Seite nach [assets/confluence-spec-seite.md](assets/confluence-spec-seite.md) erzeugen: Inhalt aus `docs/specs/<thema>.md` mit derselben Versionsnummer, ohne API-Versionen, Repo-Pfade und Abschnitt „Code vs. Admin“. Akzeptanzkriterien als **Wenn / Dann** formulieren; die Voraussetzungen aus „Gegeben“ dabei erhalten.
- Ist das Atlassian MCP verfügbar, die Seite direkt im Confluence-Bereich des Kunden anlegen; sonst Markdown zum Veröffentlichen ausgeben. Die Spec im Repo bleibt die Quelle, Confluence erhält eine veröffentlichte Kopie. Wird die Spec geändert, die Seite neu veröffentlichen und die Version hochzählen.
- Offene Fragen als Liste für den Kunden ausgeben, kundentauglich formuliert, ohne Fachjargon.
- Der Kunde gibt auf der Confluence-Seite oder per Mail frei, nie im GitHub-Epic. Dort nur den Nachweis eintragen: wer, wann, welche Version und Link zur Freigabe (bei Mail zusätzlich das Mail-Datum).
- **Stopp.** Ohne dokumentierte Freigabe (wer, wann, Version, Link im Epic) keine Issues für die Umsetzung anlegen.

## Nach der Freigabe – Issues

- Ein Epic (Vorlage `Epic`) mit Verweis auf die Spec.
- Pro abgrenzbarem Arbeitspaket ein `feature`-Issue mit den zugehörigen Kriterien-IDs, so geschnitten, dass ein PR reicht.
- Pro Admin-Arbeit ein `admin-task`-Issue mit Abhängigkeit zum Feature.
- Offene Restpunkte als `question`.
- Vor dem Anlegen die Liste der Issues zeigen und bestätigen lassen.

## Feste Regeln

- `config/settings_data.json` nie anfassen.
- Nie auf ein Live-Theme pushen.
- Keine Zugangsdaten, Tokens oder personenbezogenen Daten erfragen, loggen oder committen.

## Ausgabe

1. Pfad der Spec und Kurzfassung (max. 5 Zeilen)
2. Offene Fragen für den Kunden
3. Annahmen
4. Nach Freigabe: Liste der angelegten Issues mit Links
