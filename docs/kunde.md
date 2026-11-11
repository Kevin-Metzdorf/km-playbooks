# Kundensicht: Was der Kunde sieht und tut

GitHub Issues sind der sichtbare Ablauf, Confluence ist optional. Der Kunde muss nie GitHub öffnen.

| Ort | Wer arbeitet dort | Was liegt dort |
|-----|-------------------|----------------|
| GitHub-Repo | Kevin, Agenten | Spec-Quelle (`docs/specs/`), Epic-Issue mit vollständigem Spec-Text und Freigabe-Nachweis, Feature-Issues, PRs, CI |
| Mail (Standard) | beide | Kundenfassung der Spec als Markdown/PDF, offene Fragen, Freigaben |
| Confluence-Bereich des Kunden (optional) | Kevin schreibt, Kunde liest und gibt frei | Kundenfassung der Spec, offene Fragen, Freigaben, Change Requests |
| GitHub-Kommentar (optional) | Kunde mit GitHub-Zugriff | Fragen, Freigaben, Change Requests |

Der Standardweg zum Kunden ist Mail. Confluence und GitHub-Kommentare sind optional; der Nachweis der Freigabe steht im Epic-Issue.

## Ablauf aus Kundensicht

| Schritt | Kunde bekommt | Kunde tut | Dauer-Richtwert |
|---------|---------------|-----------|-----------------|
| 1 Gespräch | Gesprächsnotiz (Mail, optional Confluence) | Ziel, Wünsche, Termin, Budget nennen | 60 min |
| 2 Spec-Entwurf | Kundenfassung v0.x (Mail, optional Confluence) mit Tabelle „Offene Fragen“ | Fragen beantworten (Mail, optional Confluence- oder GitHub-Kommentar) | 2–5 Werktage |
| 3 Freigabe | Spec v1.0 als Kundenfassung, Aufwandsschätzung, Issue-Liste | Freigabe per Mail oder Kommentar: „Freigegeben, v1.0“ | – |
| 4 Umsetzung | Status-Update per Mail oder GitHub-Kommentar | Nichts, außer bei Rückfragen | je Spec |
| 5 Abnahme | Abnahme-Checkliste (die Akzeptanzkriterien) | Jedes Kriterium prüfen und abhaken | – |

## Regeln

- **Die Quelle ist das Repo.** Die Spec-Datei `docs/specs/<thema>.md` ist die Quelle. Das Epic-Issue trägt die freigegebene Spec vollständig als sichtbare Kopie mit derselben Versionsnummer, die Kundenfassung (Mail, optional Confluence) ebenso. Wird die Spec im Repo geändert, wird die Version hochgezählt und Epic samt Kundenfassung aktualisiert.
- **Freigabe ist dokumentiert:** wer, wann, welche Version, welcher Nachweis (Mail-Datum mit Link, Link zum Kommentar oder Confluence-Link, falls genutzt). Der Nachweis steht im Epic-Issue; ohne diesen Eintrag ist Gate 3 nicht erfüllt.
- **Alles außerhalb der freigegebenen Version ist ein Change Request.** Der Kunde formuliert den Wunsch per Mail oder als Kommentar (optional auch in Confluence), Kevin bewertet Aufwand und Termin, Kunde gibt frei, Spec bekommt neue Version. Kein Streit, ein Verwaltungsakt.
- **Technik bleibt im Repo.** Die Kundenfassung enthält keine API-Versionen, keinen Abschnitt „Code vs. Admin“, keine Repo-Pfade. Akzeptanzkriterien bleiben drin, weil der Kunde genau diese freigibt.
- **Der Vertrag verweist auf die Spec:** Im Einzelauftrag steht „Umfang: Spec <Thema> v1.0 vom <Datum>“.
- **Laufende Projekte:** Bestehende Projekte behalten den vereinbarten Kanal (Mail, optional Confluence oder GitHub), bis die nächste Spec startet. Für neue Specs gilt der Weg über das Epic-Issue.

## Produkt: Spec Sprint

Die Schritte 1–3 sind als **Spec Sprint** buchbar (Festpreis). Ergebnis: freigegebene Spec v1.0, Aufwandsschätzung, Issue-Liste. Damit kann jeder umsetzen: Kevin, ein anderer Entwickler oder eine KI. Bei Beauftragung der Umsetzung wird der Spec Sprint angerechnet.

Reihenfolge der Leistungen: Erstberatung → Spec Sprint → Umsetzung auf Stunden- oder Retainer-Basis.
