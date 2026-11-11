# Spec: SDD sichtbar in GitHub Issues (Jira und Copilot-Review raus)

| | |
|---|---|
| **Epic** | Kevin-Metzdorf/km-playbooks#36 |
| **Status** | Freigegeben (am 2026-11-11 von Kevin Metzdorf) |
| **Version** | 1.1 |
| **Bereich** | Werkzeug/Prozess |
| **API-Version** | n/a |

## 1. Ziel

Der SDD-Ablauf ist vollständig in GitHub Issues nachvollziehbar: Anforderung, Spec, Akzeptanzkriterien, Freigabe, Umsetzung und Review stehen an einer Stelle. Jira und ein festes Copilot-Review entfallen. Die Kundenfassung geht als secret Gist raus; Mail ist Rückkanal und Freigabeweg, Confluence optional. Kevin sieht den Prozess in GitHub, ohne zwischen Jira, Confluence und Repo zu springen.

## 2. Erfolg

- In jedem Projekt-Repo trägt das Epic-Issue die freigegebene Spec vollständig; die Kriterien sind im Issue lesbar, nicht nur in einer Datei.
- Prozessdoku und Vorlagen nennen Jira nicht mehr; Confluence ist als optional gekennzeichnet.
- Kundenfassungen gehen als secret Gist zum Kunden (Titel mit Kunde/Projekt, Stand, Version); Mail bleibt Rückkanal und Freigabeweg.
- Ein Review durch Kevin oder einen beliebigen Agenten erfüllt das Review-Gate; kein Bot und kein bestimmter Agent wird vorausgesetzt.
- Die Kundenfreigabe ist ohne Confluence dokumentierbar (Mail, Kommentar, Link), der Nachweis steht im Epic.
- `./scripts/check-skills.sh` und die Playbook-CI (actionlint, shellcheck, skills) sind grün.

## 3. Umfang

**Enthalten**

- Neue Spec `docs/specs/sdd-github-issues.md`
- `docs/prozess.md`: Phase 3 und 6, Abschnitt „Kunde und Freigabe“, Abschnitt „Wo steht was“
- `docs/kunde.md`: Kundenfassung als secret Gist (Standard), Mail als Rückkanal/Freigabe, Confluence (optional), GitHub-Kommentar (optional); Jira entfernt
- `docs/prompts.md`: Kundenfassung als Gist, Kunden-Update als Gist, Freigabe ohne Confluence-Pflicht, Spec-Text ins Epic
- Gist als Standard-Kanal: Titelkonvention, EXTERN-Regeln, `gh gist create --secret`, Beleg im Epic, Lebenszyklus (nicht löschen)
- `README.md`: Inhaltstabelle und Ablauf auf GitHub Issues
- `docs/beispiel-relaunch-headless-zu-native.md`: Freigabe und Nachweis ohne Confluence-Pflicht
- `docs/agenten.md`: Klarstellung, dass kein Agent Pflicht ist und keiner eine feste Review-Rolle hat
- `skills/km-sdd-spec/SKILL.md`: Phase 3 ohne Confluence-Pflicht, Phase nach der Freigabe schreibt die Spec ins Epic
- `skills/km-pr-review/SKILL.md`: Review durch Mensch oder Agent, Ergebnis im PR
- `skills/km-change-request/SKILL.md`: CR-Freigabe ohne Confluence-Pflicht
- `skills/km-sdd-spec/assets/confluence-spec-seite.md`: als Kundenfassungsvorlage für Gist/Mail/Confluence kennzeichnen
- `templates/AGENTS.sdd-section.md`: Regeln für Spec im Epic, Freigabe-Nachweis, neutrales Review
- `templates/.github/ISSUE_TEMPLATE/01-epic.yml`: Felder `Spec-Datei` und `Spec (vollständig)`, Freigabe-Feld ohne Confluence-Pflicht
- `templates/.github/ISSUE_TEMPLATE/05-change-request.yml`: Kundenfassung statt Confluence-Seite
- `templates/.github/pull_request_template.md`: Abschnitt „Review“

**Nicht enthalten (Nicht-Ziele)**

- Keine Änderung an `docs/specs/agentenneutral.md` und `docs/agenten-test.md` (abgeschlossene Artefakte; die Klarstellung steht in `docs/agenten.md`)
- Keine Änderung an CI-Workflows, `scripts/` oder `labels.yml` (dort steckt kein Jira- oder Review-Bezug)
- Keine GitHub-Project-Automatisierung (Spalten bleiben manuell)
- Kein Umbau laufender Kundenprojekte; dort gilt der vereinbarte Kanal weiter, bis die nächste Spec startet

## 4. Ist-Zustand

- Die Spec liegt in `docs/specs/<thema>.md`; das Epic-Issue verlinkt sie nur (`templates/.github/ISSUE_TEMPLATE/01-epic.yml`, Feld `spec`). In GitHub ist die Spec damit nicht lesbar.
- Die Freigabe setzt Confluence oder Mail voraus; `skills/km-sdd-spec/SKILL.md` und `docs/prozess.md` behandeln die Confluence-Seite als Pflichtschritt, `docs/kunde.md` als festen Kundenweg.
- `docs/kunde.md` enthält eine Jira-Zeile („Jira kommt nur dazu, wenn der Kunde selbst darin arbeitet“). Das ist der einzige Jira-Bezug im Repo, wird aber als Teil des Ablaufs gelesen.
- Kundenfassungen teilt Kevin heute faktisch als secret Gist (Stand 2026-11-11: 9 secret Gists, u. a. Barrierefreiheits-Audit, offene Punkte/Roadmap, Umsetzungsplan EXTERN); das Playbook nennt Gist nicht, sondern Mail und Confluence.
- Das Review ist inhaltlich neutral (`km-pr-review` nennt keinen Agenten), aber nirgends steht ausdrücklich, dass kein bestimmter Reviewer oder Bot nötig ist; die PR-Vorlage hat kein Review-Feld. `docs/agenten.md` führt Copilot als Pflicht-Agent, was als „Copilot reviewt“ missverstanden werden kann.
- Kein Dokument verlangt eine Review-Anfrage an einen Bot; die Gewohnheit stammt aus den Projekt-Repos (`gh pr edit <nr> --add-reviewer @copilot`), nicht aus dem Playbook.

## 5. Anforderungen & Akzeptanzkriterien

### 5.1 Spec vollständig im Epic-Issue

- [ ] **AK-1.1** **Gegeben** eine freigegebene Spec `docs/specs/<thema>.md`, **wenn** `km-sdd-spec` die Phase „Freigabe“ abschließt, **dann** enthält das Epic-Issue den vollständigen Spec-Text (Abschnitte 1–10) samt Version und Link zum Dateipfad.
- [ ] **AK-1.2** **Gegeben** das Epic-Issue wird mit dem Formular „Epic“ angelegt, **wenn** die Spec freigegeben wird, **dann** bietet das Formular die Felder `Spec-Datei` und `Spec (vollständig)`; der Spec-Text wird dort eingefügt.
- [ ] **AK-1.3** **Gegeben** die Spec-Datei wird geändert, **wenn** die Version hochgezählt wird, **dann** wird der Spec-Text im Epic-Issue mit derselben Version aktualisiert. Die Datei bleibt Quelle, das Epic ist die sichtbare Kopie.
- [ ] **AK-1.4** **Gegeben** ein Epic-Issue mit Spec-Text, **wenn** ein Agent `km-sdd-spec` liest, **dann** findet er den Hinweis, dass die Datei die Quelle bleibt und das Epic die Kopie ist (keine zwei Quellen).

### 5.2 Jira raus, Freigabe ohne Confluence-Pflicht

- [ ] **AK-2.1** `docs/kunde.md` nennt keinen Jira-Einsatz mehr. Kundenfassung als secret Gist (Standard), Mail als Rückkanal und Freigabeweg, Confluence (optional), GitHub-Kommentar (optional, wenn der Kunde Zugriff hat).
- [ ] **AK-2.2** Der Freigabe-Nachweis steht im Epic-Issue: wer, wann, Version und Beleg (Gist-URL + Stand/Revision, Mail-Datum oder Confluence-Link). Ohne diesen Eintrag ist Gate 3 nicht erfüllt.
- [ ] **AK-2.3** `docs/prozess.md` beschreibt Phase 3 mit diesem Artefakt und Gate; der Abschnitt „Kunde und Confluence“ heißt „Kunde und Freigabe“ und beschreibt Confluence als optional.
- [ ] **AK-2.4** `docs/prompts.md` enthält die Prompts „Kundenfassung als Gist veröffentlichen (Standard)“, „Kunden-Update als Gist“, „Freigabe eintragen“ ohne Confluence-Pflicht und „Spec in Epic eintragen“.
- [ ] **AK-2.5** `skills/km-change-request/SKILL.md` und `templates/.github/ISSUE_TEMPLATE/05-change-request.yml` verlangen keine Confluence-Seite; sie nennen „Kundenfassung (Gist-Link, Mail-Datum oder Confluence)“.
- [ ] **AK-2.6** `skills/km-sdd-spec/assets/confluence-spec-seite.md` ist im Kopf als optionales Asset gekennzeichnet.

### 5.3 Review neutral

- [ ] **AK-3.1** `skills/km-pr-review/SKILL.md` legt fest: Reviewer ist Kevin oder ein beliebiger Agent; das Ergebnis wird als PR-Review oder PR-Kommentar mit Datum dokumentiert. Kein Bot und kein bestimmter Agent wird vorausgesetzt.
- [ ] **AK-3.2** `templates/.github/pull_request_template.md` hat einen Abschnitt „Review“ (Reviewer, Ergebnis, Datum) und verweist auf `km-pr-review`.
- [ ] **AK-3.3** `templates/AGENTS.sdd-section.md` enthält die Regel: Review durch Mensch oder Agent, kein bestimmter Reviewer vorgeschrieben; der Review-Nachweis steht im PR.
- [ ] **AK-3.4** `docs/agenten.md` stellt klar: Kein Agent ist für den Prozess Pflicht; die Tabelle sagt, welche Agenten getestet sind, nicht wer reviewt.
- [ ] **AK-3.5** Kein Dokument verlangt eine Review-Anfrage an einen bestimmten Bot. Gegenprobe: `grep -riE 'add-reviewer|@copilot' docs/ templates/ skills/` trifft nur diese Spec (Ist-Zustand und dieses Kriterium), nicht Prozessdoku oder Vorlagen.

### 5.4 Doku konsistent

- [ ] **AK-4.1** `README.md` beschreibt GitHub Issues als sichtbaren SDD-Ablauf und Confluence als optional; die Inhaltstabelle nennt keine Confluence- oder Jira-Pflicht.
- [ ] **AK-4.2** `docs/beispiel-relaunch-headless-zu-native.md` beschreibt Freigabe und Nachweis ohne Confluence-Pflicht.
- [ ] **AK-4.3** `./scripts/check-skills.sh` läuft grün (Frontmatter, Sperrliste, Verweise).
- [ ] **AK-4.4** Keine Änderung an CI-Workflows und `scripts/`; die geänderten Vorlagen bleiben mit `apply-templates.sh` kompatibel (keine neuen Pflichtdateien).

### 5.5 Kundenfassung als Gist (Standard)

- [ ] **AK-5.1** **Gegeben** eine Kundenfassung soll zum Kunden, **wenn** sie veröffentlicht wird, **dann** geschieht das als secret Gist mit dem Titel `<Kunde/Projekt> – <Thema> · Stand <JJJJ-MM-TT> · v<Version>`; ein public Gist wird nie angelegt.
- [ ] **AK-5.2** **Gegeben** eine Spec, **wenn** die Kundenfassung erzeugt wird, **dann** sind enthalten: Akzeptanzkriterien als Wenn/Dann, offene Fragen, Freigabehinweis; nicht enthalten: API-Versionen, Repo-Pfade, Abschnitt „Code vs. Admin“, interne Aufwände, Tokens, personenbezogene Daten anderer Kunden.
- [ ] **AK-5.3** **Gegeben** ein veröffentlichter Gist, **wenn** die Freigabe eintrifft, **dann** stehen Gist-URL, Stand/Revision und wer/wann/Version im Epic-Issue; Freigabe erfolgt per Mail (Standard) oder als Gist-Kommentar (GitHub-Konto nötig).
- [ ] **AK-5.4** **Gegeben** eine neue Spec-Version, **wenn** sie freigegeben wird, **dann** wird die Kundenfassung als neue Gist-Revision bzw. neuer Gist veröffentlicht und der Link im Epic aktualisiert. Gist ist Kopie, nie Quelle; Datei und Epic bleiben maßgeblich.
- [ ] **AK-5.5** **Gegeben** vertrauliche Inhalte (Preise, Verträge, personenbezogene Daten), **wenn** eine Kundenfassung nötig ist, **dann** wird kein Gist genutzt, sondern PDF/Mail oder der Confluence-Bereich des Kunden. Die Doku benennt, dass ein secret Gist nur linkgeschützt, nicht zugriffsgeschützt ist.
- [ ] **AK-5.6** **Gegeben** ein Gist, der als Freigabe-Nachweis dient, **wenn** das Projekt abgeschlossen wird, **dann** wird er nicht gelöscht, solange der Nachweis gebraucht wird; die finale Freigabe wird zusätzlich als PDF/Mail archiviert.

## 6. Code vs. Shopify Admin

n/a – reine Prozess- und Dokuänderung, keine Shopify-Oberfläche betroffen.

## 7. Abhängigkeiten & Risiken

- **Doppelte Pflege:** Spec-Datei und Epic-Text können auseinanderlaufen. Mitigation: Der Epic-Text wird nur beim Freigeben und bei Versionsänderungen neu eingefügt; Datei bleibt Quelle, Version und Link stehen im Epic.
- **Review-Qualität:** Ohne festen Reviewer hängt die Tiefe am Menschen bzw. Agenten. Mitigation: Die `km-pr-review`-Checkliste bleibt verbindlich; CI und Theme Check bleiben Pflicht.
- **Kunde ohne GitHub:** Der Kunde bekommt die Kundenfassung als secret Gist-Link oder als Markdown/PDF per Mail; Confluence bleibt optional.
- **Gist = Link-Geheimnis:** Ein secret Gist ist nicht zugriffsgeschützt; wer den Link hat, liest mit. Mitigation: keine vertraulichen Inhalte (Preise, Verträge, personenbezogene Daten) in Gists; dafür PDF/Mail oder Kunden-Confluence.
- **Gist außerhalb des Repos:** Löschung oder Kontowechsel bricht den Nachweis-Link. Mitigation: Gist nicht löschen, finale Freigabe archivieren, Gist-URL mit Stand im Epic.
- **Laufende Projekte:** Bestehende Projekte mit Jira oder Confluence laufen weiter. Mitigation: Übergangsregel in `docs/kunde.md` — der vereinbarte Kanal gilt, bis die nächste Spec startet.

## 8. Offene Fragen

| # | Frage | Antwort | Wer / Datum |
|---|-------|---------|-------------|
| 1 | Wird der Spec-Text automatisch mit der Datei synchronisiert? | Nein, bewusst manuell mit Version, damit keine zwei Quellen entstehen. | Kevin / 2026-11-11 |
| 2 | Braucht es ein zusätzliches Label für den Review-Status? | Nein; PR-Review und Project-Status „Review“ reichen. | Kevin / 2026-11-11 |
| 3 | Wird Jira in laufenden Kundenprojekten sofort abgeschaltet? | Nein; bestehende Projekte behalten ihren vereinbarten Kanal, neue Specs starten auf GitHub. | Kevin / 2026-11-11 |
| 4 | Wird Gist auch für interne Dokumente genutzt? | Nein; Gist nur für kundengerichtete Fassungen (Spec, Audits, offene Punkte, Status). | Kevin / 2026-11-11 |
| 5 | Ersetzt Gist Confluence vollständig? | Nein; Confluence bleibt optional für Kunden, die es nutzen (Seiten mit Zugriffsrechten, Freigaben). | Kevin / 2026-11-11 |

## 9. Annahmen

- GitHub Issues sind für Kevin überall erreichbar; der Kunde braucht keinen GitHub-Zugriff.
- Die Kundenfassung darf als Markdown/PDF per Mail gehen, wenn kein Confluence genutzt wird.
- `gh` CLI oder ein GitHub-MCP ist verfügbar; sonst gibt der Agent Texte zum manuellen Anlegen aus (bestehender Skill-Standard).

## 10. Änderungshistorie

| Version | Datum | Änderung |
|---------|-------|----------|
| 1.0 | 2026-11-11 | Freigegeben: Spec vollständig im Epic, Jira raus, Review neutral, Confluence optional |
| 1.1 | 2026-11-11 | Gist als Standard-Kundenkanal ergänzt (secret, Titelkonvention, EXTERN-Regeln, Lebenszyklus); Mail als Rückkanal, Confluence optional (Entscheidung Kevin, Chat) |
