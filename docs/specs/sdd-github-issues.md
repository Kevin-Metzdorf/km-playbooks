# Spec: SDD sichtbar in GitHub Issues (Jira und Copilot-Review raus)

| | |
|---|---|
| **Epic** | Kevin-Metzdorf/km-playbooks#36 |
| **Status** | Freigegeben (am 2026-11-11 von Kevin Metzdorf) |
| **Version** | 1.0 |
| **Bereich** | Werkzeug/Prozess |
| **API-Version** | n/a |

## 1. Ziel

Der SDD-Ablauf ist vollständig in GitHub Issues nachvollziehbar: Anforderung, Spec, Akzeptanzkriterien, Freigabe, Umsetzung und Review stehen an einer Stelle. Jira und ein festes Copilot-Review entfallen; Confluence wird vom Pflichtweg zum optionalen Kundenkanal. Kevin sieht den Prozess in GitHub, ohne zwischen Jira, Confluence und Repo zu springen.

## 2. Erfolg

- In jedem Projekt-Repo trägt das Epic-Issue die freigegebene Spec vollständig; die Kriterien sind im Issue lesbar, nicht nur in einer Datei.
- Prozessdoku und Vorlagen nennen Jira nicht mehr; Confluence ist als optional gekennzeichnet.
- Ein Review durch Kevin oder einen beliebigen Agenten erfüllt das Review-Gate; kein Bot und kein bestimmter Agent wird vorausgesetzt.
- Die Kundenfreigabe ist ohne Confluence dokumentierbar (Mail, Kommentar, Link), der Nachweis steht im Epic.
- `./scripts/check-skills.sh` und die Playbook-CI (actionlint, shellcheck, skills) sind grün.

## 3. Umfang

**Enthalten**

- Neue Spec `docs/specs/sdd-github-issues.md`
- `docs/prozess.md`: Phase 3 und 6, Abschnitt „Kunde und Freigabe“, Abschnitt „Wo steht was“
- `docs/kunde.md`: Kundenwege Mail (Standard), Confluence (optional), GitHub-Kommentar (optional); Jira entfernt
- `docs/prompts.md`: Kundenfassung ohne Confluence-Pflicht, Spec-Text ins Epic
- `README.md`: Inhaltstabelle und Ablauf auf GitHub Issues
- `docs/beispiel-relaunch-headless-zu-native.md`: Freigabe und Nachweis ohne Confluence-Pflicht
- `docs/agenten.md`: Klarstellung, dass kein Agent Pflicht ist und keiner eine feste Review-Rolle hat
- `skills/km-sdd-spec/SKILL.md`: Phase 3 ohne Confluence-Pflicht, Phase nach der Freigabe schreibt die Spec ins Epic
- `skills/km-pr-review/SKILL.md`: Review durch Mensch oder Agent, Ergebnis im PR
- `skills/km-change-request/SKILL.md`: CR-Freigabe ohne Confluence-Pflicht
- `skills/km-sdd-spec/assets/confluence-spec-seite.md`: als optionales Asset kennzeichnen
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
- Das Review ist inhaltlich neutral (`km-pr-review` nennt keinen Agenten), aber nirgends steht ausdrücklich, dass kein bestimmter Reviewer oder Bot nötig ist; die PR-Vorlage hat kein Review-Feld. `docs/agenten.md` führt Copilot als Pflicht-Agent, was als „Copilot reviewt“ missverstanden werden kann.
- Kein Dokument verlangt eine Review-Anfrage an einen Bot; die Gewohnheit stammt aus den Projekt-Repos (`gh pr edit <nr> --add-reviewer @copilot`), nicht aus dem Playbook.

## 5. Anforderungen & Akzeptanzkriterien

### 5.1 Spec vollständig im Epic-Issue

- [ ] **AK-1.1** **Gegeben** eine freigegebene Spec `docs/specs/<thema>.md`, **wenn** `km-sdd-spec` die Phase „Freigabe“ abschließt, **dann** enthält das Epic-Issue den vollständigen Spec-Text (Abschnitte 1–10) samt Version und Link zum Dateipfad.
- [ ] **AK-1.2** **Gegeben** das Epic-Issue wird mit dem Formular „Epic“ angelegt, **wenn** die Spec freigegeben wird, **dann** bietet das Formular die Felder `Spec-Datei` und `Spec (vollständig)`; der Spec-Text wird dort eingefügt.
- [ ] **AK-1.3** **Gegeben** die Spec-Datei wird geändert, **wenn** die Version hochgezählt wird, **dann** wird der Spec-Text im Epic-Issue mit derselben Version aktualisiert. Die Datei bleibt Quelle, das Epic ist die sichtbare Kopie.
- [ ] **AK-1.4** **Gegeben** ein Epic-Issue mit Spec-Text, **wenn** ein Agent `km-sdd-spec` liest, **dann** findet er den Hinweis, dass die Datei die Quelle bleibt und das Epic die Kopie ist (keine zwei Quellen).

### 5.2 Jira raus, Freigabe ohne Confluence-Pflicht

- [ ] **AK-2.1** `docs/kunde.md` nennt keinen Jira-Einsatz mehr. Kundenwege sind Mail (Standard), Confluence (optional) und GitHub-Kommentar (optional, wenn der Kunde Zugriff hat).
- [ ] **AK-2.2** Der Freigabe-Nachweis steht im Epic-Issue: wer, wann, Version und Nachweis (Mail-Datum, Link oder Confluence-Link). Ohne diesen Eintrag ist Gate 3 nicht erfüllt.
- [ ] **AK-2.3** `docs/prozess.md` beschreibt Phase 3 mit diesem Artefakt und Gate; der Abschnitt „Kunde und Confluence“ heißt „Kunde und Freigabe“ und beschreibt Confluence als optional.
- [ ] **AK-2.4** `docs/prompts.md` enthält einen Prompt „Kundenfassung erzeugen (Confluence optional)“, einen Prompt „Freigabe eintragen“ ohne Confluence-Pflicht und einen Prompt, der den Spec-Text ins Epic setzt.
- [ ] **AK-2.5** `skills/km-change-request/SKILL.md` und `templates/.github/ISSUE_TEMPLATE/05-change-request.yml` verlangen keine Confluence-Seite; sie nennen „Kundenfassung (Mail, Link oder Confluence)“.
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

## 6. Code vs. Shopify Admin

n/a – reine Prozess- und Dokuänderung, keine Shopify-Oberfläche betroffen.

## 7. Abhängigkeiten & Risiken

- **Doppelte Pflege:** Spec-Datei und Epic-Text können auseinanderlaufen. Mitigation: Der Epic-Text wird nur beim Freigeben und bei Versionsänderungen neu eingefügt; Datei bleibt Quelle, Version und Link stehen im Epic.
- **Review-Qualität:** Ohne festen Reviewer hängt die Tiefe am Menschen bzw. Agenten. Mitigation: Die `km-pr-review`-Checkliste bleibt verbindlich; CI und Theme Check bleiben Pflicht.
- **Kunde ohne GitHub:** Der Kunde bekommt die Kundenfassung als Markdown/PDF per Mail; Confluence bleibt optional.
- **Laufende Projekte:** Bestehende Projekte mit Jira oder Confluence laufen weiter. Mitigation: Übergangsregel in `docs/kunde.md` — der vereinbarte Kanal gilt, bis die nächste Spec startet.

## 8. Offene Fragen

| # | Frage | Antwort | Wer / Datum |
|---|-------|---------|-------------|
| 1 | Wird der Spec-Text automatisch mit der Datei synchronisiert? | Nein, bewusst manuell mit Version, damit keine zwei Quellen entstehen. | Kevin / 2026-11-11 |
| 2 | Braucht es ein zusätzliches Label für den Review-Status? | Nein; PR-Review und Project-Status „Review“ reichen. | Kevin / 2026-11-11 |
| 3 | Wird Jira in laufenden Kundenprojekten sofort abgeschaltet? | Nein; bestehende Projekte behalten ihren vereinbarten Kanal, neue Specs starten auf GitHub. | Kevin / 2026-11-11 |

## 9. Annahmen

- GitHub Issues sind für Kevin überall erreichbar; der Kunde braucht keinen GitHub-Zugriff.
- Die Kundenfassung darf als Markdown/PDF per Mail gehen, wenn kein Confluence genutzt wird.
- `gh` CLI oder ein GitHub-MCP ist verfügbar; sonst gibt der Agent Texte zum manuellen Anlegen aus (bestehender Skill-Standard).

## 10. Änderungshistorie

| Version | Datum | Änderung |
|---------|-------|----------|
| 1.0 | 2026-11-11 | Freigegeben: Spec vollständig im Epic, Jira raus, Review neutral, Confluence optional |
