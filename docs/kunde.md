# Kundensicht: Was der Kunde sieht und tut

GitHub ist die Werkstatt, Confluence das Schaufenster. Der Kunde muss nie GitHub öffnen.

| Ort | Wer arbeitet dort | Was liegt dort |
|-----|-------------------|----------------|
| GitHub-Repo | Kevin, Agenten | Spec-Quelle (`docs/specs/`), Issues, PRs, CI |
| Confluence-Bereich des Kunden | Kevin schreibt, Kunde liest und gibt frei | Veröffentlichte Spec-Seite, offene Fragen, Freigaben, Change Requests |
| Mail | beide | Freigabe, wenn der Kunde nicht in Confluence kommentieren will |

Jira kommt nur dazu, wenn der Kunde selbst darin arbeitet. Sonst reicht Confluence-Seite plus Mail.

## Ablauf aus Kundensicht

| Schritt | Kunde bekommt | Kunde tut | Dauer-Richtwert |
|---------|---------------|-----------|-----------------|
| 1 Gespräch | Gesprächsnotiz in Confluence | Ziel, Wünsche, Termin, Budget nennen | 60 min |
| 2 Spec-Entwurf | Spec-Seite v0.x mit Tabelle „Offene Fragen“ | Fragen beantworten (Kommentar auf der Seite oder Mail) | 2–5 Werktage |
| 3 Freigabe | Spec-Seite v1.0, Aufwandsschätzung, Issue-Liste | Freigabe-Kommentar oder Mail: „Freigegeben, v1.0“ | – |
| 4 Umsetzung | Status-Update per Mail oder Kommentar auf der Seite | Nichts, außer bei Rückfragen | je Spec |
| 5 Abnahme | Abnahme-Checkliste (die Akzeptanzkriterien) | Jedes Kriterium prüfen und abhaken | – |

## Regeln

- **Die Quelle ist das Repo.** Die Confluence-Seite ist eine veröffentlichte Kopie mit Versionsnummer. Wird die Spec im Repo geändert, wird die Seite neu veröffentlicht und die Version hochgezählt.
- **Freigabe ist dokumentiert:** wer, wann, welche Version. Der Link zum Freigabe-Kommentar bzw. die Mail wird im GitHub-Epic eingetragen. Ohne diesen Eintrag ist Gate 3 nicht erfüllt.
- **Alles außerhalb der freigegebenen Version ist ein Change Request.** Der Kunde formuliert den Wunsch auf der Seite oder per Mail, Kevin bewertet Aufwand und Termin, Kunde gibt frei, Spec bekommt neue Version. Kein Streit, ein Verwaltungsakt.
- **Technik bleibt im Repo.** Die Confluence-Seite enthält keine API-Versionen, keinen Abschnitt „Code vs. Admin“, keine Repo-Pfade. Akzeptanzkriterien bleiben drin, weil der Kunde genau diese freigibt.
- **Der Vertrag verweist auf die Spec:** Im Einzelauftrag steht „Umfang: Spec <Thema> v1.0 vom <Datum>“.

## Produkt: Spec Sprint

Die Schritte 1–3 sind als **Spec Sprint** buchbar (Festpreis). Ergebnis: freigegebene Spec v1.0, Aufwandsschätzung, Issue-Liste. Damit kann jeder umsetzen: Kevin, ein anderer Entwickler oder eine KI. Bei Beauftragung der Umsetzung wird der Spec Sprint angerechnet.

Reihenfolge der Leistungen: Erstberatung → Spec Sprint → Umsetzung auf Stunden- oder Retainer-Basis.
