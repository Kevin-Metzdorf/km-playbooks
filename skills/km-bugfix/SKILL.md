---
name: km-bugfix
description: Schlanker SDD-Ablauf für Bugs in Shopify-Themes und -Apps – reproduzieren, Ursache finden, minimal fixen, gegen Kriterien prüfen. Verwenden, wenn ein Bug-Issue bearbeitet wird.
license: MIT
compatibility: "git, Shopify CLI. Optional: gh CLI oder GitHub-MCP."
---

# km-bugfix – Bug reproduzieren und beheben

## Werkzeuge

- **GitHub (Issues, PRs, Project):** über `gh` CLI oder ein GitHub-MCP. Ist keins verfügbar: benötigte Inhalte beim Nutzer erfragen, Texte zum Anlegen als Markdown ausgeben und die manuellen Schritte nennen.

## 1. Verstehen

- `AGENTS.md` lesen.
- Ist, Soll und Schritte aus dem Issue übernehmen. Fehlt das Soll: in Spec/Kriterien nachsehen, sonst Frage stellen.
- Akzeptanzkriterium für den Fix festhalten (Gegeben/Wenn/Dann), falls im Issue nicht vorhanden.

## 2. Reproduzieren

- Im Preview-Theme bzw. Dev-Store nachstellen. Nicht reproduzierbar → Befund dokumentieren und nachfragen, nicht blind fixen.
- Prüfen, ob die Ursache im Code oder im Admin liegt (Einstellung, Inhalt, App). Admin-Ursache → `admin-task`, kein Code.

## 3. Ursache und Fix

- Ursache benennen (Datei, Zeile, Grund), nicht nur das Symptom.
- Minimaler Fix; keine Refactorings nebenbei.
- Prüfen, ob dieselbe Ursache an anderer Stelle wirkt.

## 4. Prüfung und PR

- Kriterium und angrenzende Funktion prüfen (Regression).
- Theme Check / Lint / Tests grün.
- PR-Vorlage mit Ursache, Fix und Prüfergebnis.

## Feste Regeln

- `config/settings_data.json` nie anfassen. Nie auf ein Live-Theme pushen.
- Keine personenbezogenen Daten aus Bestellungen oder Kundenkonten in Issues, Logs oder Commits.
