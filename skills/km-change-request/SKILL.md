---
name: km-change-request
description: Change Request gegen eine freigegebene Spec bearbeiten — prüfen, ob der Kundenwunsch außerhalb der Spec liegt, Auswirkung auf Aufwand und Termin bewerten, Change-Request-Issue (Formular „Change Request“, Label change-request) entwerfen, Kundenfreigabe einholen und danach die Spec-Version aktualisieren. Verwenden, wenn der Kunde eine Änderung wünscht, die nicht in der freigegebenen Spec docs/specs/<thema>.md steht.
license: MIT
compatibility: "git. Optional: gh CLI oder GitHub-MCP, Atlassian MCP."
---

# km-change-request – Kundenwunsch gegen freigegebene Spec

Ziel: Alles, was nicht in der freigegebenen Spec steht, ist ein Change Request. Dieser Skill stellt sicher, dass CRs einheitlich erkannt, bewertet, freigegeben und in die Spec zurückgeführt werden — nicht als lose Absprache im Chat.

## Wann einsetzen

- Der Kunde meldet einen Wunsch oder eine Änderung, die nicht in der freigegebenen Spec steht.
- Auch bei „kleinen" Änderungen zuerst prüfen — dann erst entscheiden, ob ein CR nötig ist.

## Ablauf

1. **Prüfen:** Anliegen gegen die freigegebene Spec halten und die Spec-Version notieren. Steht es sinngemäß in der Spec → kein CR, normaler Umsetzungs-Issue. Steht es nicht darin → CR.
2. **Bewerten:** Auswirkung auf Aufwand, Termin, betroffene Akzeptanzkriterien, Admin-Aufgaben und Risiken einschätzen; Annahmen notieren.
3. **CR-Issue entwerfen:** Issue-Formular „Change Request“ (Label `change-request`), verknüpft mit Epic und Spec-Version. Felder: gewünschte Änderung, Begründung, Auswirkung, neue/geänderte Akzeptanzkriterien im Format Gegeben/Wenn/Dann. Vor dem Anlegen die Issue-Liste zeigen und bestätigen lassen.
4. **Freigabe einholen:** Der Kunde gibt den CR frei — per Mail, als Kommentar oder in Confluence (optional, nur wenn der Kunde es nutzt), nie im Epic. Nachweis ins CR-Issue eintragen: wer, wann und Beleg (Mail-Datum oder Link). Eine Confluence-Seite ist dafür nicht nötig; ohne Kundenkanal genügt die Kundenfassung als Markdown/PDF per Mail.
5. **Spec aktualisieren:** Nach Freigabe die Spec-Version hochzählen und die Änderung einpflegen; den Spec-Text im Epic-Issue mit derselben Version aktualisieren (Datei bleibt Quelle) und die Kundenfassung neu erzeugen, wenn eine genutzt wird; danach die Umsetzungs-Issues anlegen.

## Feste Regeln

- Ohne dokumentierte Freigabe keine Umsetzung.
- Freigabe nie im Epic selbst geben, dort nur den Nachweis verlinken.
- Rückfragen eine nach der anderen stellen, nie mehrere auf einmal.
- Keine Zugangsdaten, Tokens oder personenbezogenen Daten erfragen, loggen oder committen.

## Ausgabe

1. Prüfergebnis: CR ja/nein, gegen Spec-Version x
2. Bewertung (Aufwand, Termin, betroffene Kriterien, Risiken)
3. CR-Issue mit Link
4. Freigabenachweis und aktualisierte Spec-Version
