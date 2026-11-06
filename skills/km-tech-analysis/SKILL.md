---
name: km-tech-analysis
description: Vor der Bearbeitung einer technischen Aufgabe (Shopify, Softwareentwicklung) wird analysiert, welche Methoden ein Spitzenfachmann des Gebiets anwenden würde, und die Aufgabenstellung wird so umgeschrieben, dass genau diese Methoden, Rohmaterialien, Werkzeuge und Prüfinstanzen eingefordert werden. Automatisch laden bei Machbarkeitsanalysen, Spezifikationen und ähnlichen Aufgaben, damit keine Expertenmethode fehlt, nur weil der Auftraggeber sie nicht kennt. Auch manuell per /km-tech-analysis aufrufbar.
license: MIT
compatibility: "Keine Pflicht-Werkzeuge. Je nach Aufgabe: git, gh CLI oder GitHub-MCP, Shopify Dev MCP, Atlassian MCP."
---

# km-tech-analysis – Aufgabe per Expertenblick schärfen

Ziel: Eine technische Aufgabe wird nicht sofort umgesetzt, sondern zuerst so analysiert, dass **alle Methoden und Vorgehensweisen eines Spitzenfachmanns sichtbar und in der Aufgabenstellung verankert** werden. Begründung: Eine Methode, die der Auftraggeber nicht kennt (z. B. eine Abhängigkeitsprüfung), kann er nicht einfordern — sie fehlt dann in der Aufgabe und im Ergebnis.

## Ablauf

### Phase 1 – Expertenblick (vier Fragen beantworten)

1. **Was würde ein Spitzenfachmann hier tun, was in der Aufgabe nicht steht?** (z. B. Kollisions- und Schema-Prüfungen, Regression bestehender Lösungen)
2. **Von welchem Rohmaterial geht er aus** — statt von der aufbereiteten Anfrage? Quellcode, Config-Dateien, vorhandene Specs und Issues, Doku; konkret benennen.
3. **Welche konkreten Methoden und Werkzeuge wendet er an?** Zu jeder Methode Name, Werkzeug und Kommando notieren, z. B. Abhängigkeitsprüfung über Lockfiles (`package.json`, `Gemfile`), API-Versionen, Theme-/App-Kompatibilität, verfügbare MCP-Tools und CLIs.
4. **Wer oder was kann außer Auftraggeber und Agent nachweisen, dass das Ergebnis richtig ist?** (CI, Schema-/Loader-Validierung, frische Session, kalter Prüfer, Regression)

### Phase 2 – Aufgabe umschreiben

- Die Aufgabenstellung so umformulieren, dass genau die gefundenen Punkte eingefordert werden — tiefer, nicht umfangreicher.
- Die umgeschriebene Fassung dem Nutzer vorlegen und auf Freigabe warten.

### Phase 3 – Ausführen

- Erst nach Freigabe die Aufgabe gemäß der geschärften Fassung bearbeiten.

## Feste Regeln

- Rückfragen **eine nach der anderen** stellen, nie mehrere auf einmal.
- Methoden immer konkret benennen (Name + Werkzeug + Kommando), nicht nur das Prinzip.
- Nie Ungeprüftes als geprüft kennzeichnen; Prüfungen über die benannten Werkzeuge, nie aus dem Gedächtnis.
- Minimaler Eingriff: Die Struktur der Aufgabe bleibt erhalten, nur Methoden- und Prüfpunkte werden ergänzt.

## Ausgabe

1. Die vier Antworten des Expertenblicks, kompakt
2. Die umgeschriebene Aufgabenstellung
3. Nach Freigabe: das Ergebnis gemäß der freigegebenen Fassung
