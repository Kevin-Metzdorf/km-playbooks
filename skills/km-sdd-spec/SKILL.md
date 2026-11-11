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

- Nach dem Spec-Entwurf eine kundenlesbare Kundenfassung erzeugen, wenn eine gebraucht wird: Inhalt aus `docs/specs/<thema>.md` mit derselben Versionsnummer, ohne API-Versionen, Repo-Pfade und Abschnitt „Code vs. Admin“. Akzeptanzkriterien als **Wenn / Dann** formulieren; die Voraussetzungen aus „Gegeben“ dabei erhalten.
- Die Kundenfassung ist optional: Nutzt der Kunde Confluence, die Seite nach [assets/confluence-spec-seite.md](assets/confluence-spec-seite.md) erzeugen (mit Atlassian MCP direkt anlegen, sonst Markdown zum Veröffentlichen ausgeben); nutzt er es nicht, dieselbe Kundenfassung als Markdown oder PDF per Mail senden.
- Offene Fragen als Liste für den Kunden ausgeben, kundentauglich formuliert, ohne Fachjargon.
- Freigabe per Mail, als Kommentar auf der Kundenfassung oder in Confluence – nie im GitHub-Epic selbst. Im Epic nur den Nachweis eintragen: wer, wann, welche Version und Beleg (Mail-Datum, Link bzw. Confluence-Link). Confluence ist dafür nicht nötig.
- **Stopp.** Ohne dokumentierte Freigabe (wer, wann, Version, Beleg im Epic) keine Issues für die Umsetzung anlegen.

## Nach der Freigabe – Issues

- **Zuerst** das Epic (Vorlage `Epic`) anlegen oder aktualisieren: vollständiger Spec-Text (Abschnitte 1–10) aus `docs/specs/<thema>.md`, dazu Version und Link zum Dateipfad.
- Die Spec-Datei bleibt die Quelle, das Epic ist die sichtbare Kopie – keine zwei Quellen. Bei einer Versionsänderung den Spec-Text im Epic mit derselben Version aktualisieren.
- Danach pro abgrenzbarem Arbeitspaket ein `feature`-Issue mit den zugehörigen Kriterien-IDs, so geschnitten, dass ein PR reicht.
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
4. Nach Freigabe: Epic mit vollständigem Spec-Text und Liste der angelegten Issues mit Links
