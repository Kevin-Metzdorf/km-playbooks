# Kundensicht: Was der Kunde sieht und tut

GitHub Issues sind der sichtbare Ablauf, die Kundenfassung geht als secret Gist raus, Mail ist Rückkanal und Freigabeweg, Confluence optional. Der Kunde braucht dafür kein GitHub-Konto.

| Ort | Wer arbeitet dort | Was liegt dort |
|-----|-------------------|----------------|
| GitHub-Repo | Kevin, Agenten | Spec-Quelle (`docs/specs/`), Epic-Issue mit vollständigem Spec-Text und Freigabe-Nachweis, Feature-Issues, PRs, CI |
| GitHub Gist (Standard, secret) | Kevin schreibt, Kunde liest | Kundenfassung der Spec, Audits, offene Punkte, Status – Titel mit Kunde/Projekt, Stand und Version |
| Mail (Rückkanal) | beide | Freigaben, Rückfragen, Versand des Gist-Links |
| Confluence-Bereich des Kunden (optional) | Kevin schreibt, Kunde liest und gibt frei | Kundenfassung der Spec, offene Fragen, Freigaben, Change Requests |
| GitHub-Kommentar (optional) | Kunde mit GitHub-Zugriff | Fragen, Freigaben, Change Requests |

Der Standardweg zum Kunden ist ein secret Gist-Link, per Mail verschickt. Mail ist der Rückkanal für Freigaben und Fragen; Confluence und GitHub-Kommentare sind optional. Der Nachweis der Freigabe steht im Epic-Issue.

## Ablauf aus Kundensicht

| Schritt | Kunde bekommt | Kunde tut | Dauer-Richtwert |
|---------|---------------|-----------|-----------------|
| 1 Gespräch | Gesprächsnotiz (Mail, optional Gist/Confluence) | Ziel, Wünsche, Termin, Budget nennen | 60 min |
| 2 Spec-Entwurf | Kundenfassung v0.x als secret Gist (Link per Mail) mit Tabelle „Offene Fragen“ | Fragen beantworten (Mail oder Gist-Kommentar, optional Confluence) | 2–5 Werktage |
| 3 Freigabe | Spec v1.0 als Kundenfassung (Gist v1.0), Aufwandsschätzung, Issue-Liste | Freigabe per Mail oder Gist-Kommentar: „Freigegeben, v1.0“ | – |
| 4 Umsetzung | Status-Update als Gist (Link per Mail) oder GitHub-Kommentar | Nichts, außer bei Rückfragen | je Spec |
| 5 Abnahme | Abnahme-Checkliste (die Akzeptanzkriterien) | Jedes Kriterium prüfen und abhaken | – |

## Regeln

- **Die Quelle ist das Repo.** Die Spec-Datei `docs/specs/<thema>.md` ist die Quelle. Das Epic-Issue trägt die freigegebene Spec vollständig als sichtbare Kopie mit derselben Versionsnummer, die Kundenfassung (secret Gist; alternativ Mail/Confluence, wenn der Kunde es so will) ebenso. Wird die Spec im Repo geändert, wird die Version hochgezählt und Epic samt Kundenfassung aktualisiert.
- **Freigabe ist dokumentiert:** wer, wann, welche Version, welcher Nachweis (Gist-URL + Stand/Revision, Mail-Datum mit Link oder Confluence-Link, falls genutzt). Der Nachweis steht im Epic-Issue; ohne diesen Eintrag ist Gate 3 nicht erfüllt.
- **Alles außerhalb der freigegebenen Version ist ein Change Request.** Der Kunde formuliert den Wunsch per Mail oder als Kommentar (optional auch in Confluence), Kevin bewertet Aufwand und Termin, Kunde gibt frei, Spec bekommt neue Version. Kein Streit, ein Verwaltungsakt.
- **Technik bleibt im Repo.** Die Kundenfassung enthält keine API-Versionen, keinen Abschnitt „Code vs. Admin“, keine Repo-Pfade, keine internen Aufwände. Akzeptanzkriterien bleiben drin, weil der Kunde genau diese freigibt.
- **Kundenfassung ist ein secret Gist.** Titel `<Kunde/Projekt> – <Thema> · Stand <JJJJ-MM-TT> · v<Version>`, nie public; Link und Stand kommen ins Epic-Issue.
- **Vertraulichkeit:** Ein secret Gist ist nur linkgeschützt, nicht zugriffsgeschützt. Preise, Verträge und personenbezogene Daten gehören nicht hinein; dafür PDF/Mail oder der Confluence-Bereich des Kunden.
- **Lebenszyklus:** Gist nicht löschen, solange er als Freigabe-Nachweis dient; die finale Freigabe zusätzlich als PDF/Mail archivieren.
- **Der Vertrag verweist auf die Spec:** Im Einzelauftrag steht „Umfang: Spec <Thema> v1.0 vom <Datum>“.
- **Laufende Projekte:** Bestehende Projekte behalten den vereinbarten Kanal (Gist, Mail, optional Confluence oder GitHub), bis die nächste Spec startet. Für neue Specs gilt der Weg über das Epic-Issue.

## Produkt: Spec Sprint

Die Schritte 1–3 sind als **Spec Sprint** buchbar (Festpreis). Ergebnis: freigegebene Spec v1.0, Aufwandsschätzung, Issue-Liste. Damit kann jeder umsetzen: Kevin, ein anderer Entwickler oder eine KI. Bei Beauftragung der Umsetzung wird der Spec Sprint angerechnet.

Reihenfolge der Leistungen: Erstberatung → Spec Sprint → Umsetzung auf Stunden- oder Retainer-Basis.
