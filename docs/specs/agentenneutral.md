# Spec: Agentenneutrale Playbooks (Claude Code, Copilot, Codex, Cursor, Gemini CLI)

| | |
|---|---|
| **Epic** | Kevin-Metzdorf/km-playbooks#13 |
| **Status** | Freigegeben (am 2026-10-06 von Kevin Metzdorf) |
| **Version** | 1.3 |
| **Bereich** | Werkzeug/Prozess |
| **API-Version** | n/a: Agent-Skills-Standard ([agentskills.io](https://agentskills.io/specification)), `AGENTS.md` |

## 1. Ziel

Die Playbooks (Skills, feste Regeln, Vorlagen, Start-Prompts) funktionieren mit jedem Coding-Agenten, der den offenen Agent-Skills-Standard und `AGENTS.md` unterstützt, nicht nur mit GitHub Copilot. Der SDD-Prozess mit seinen Gates hängt nicht am Werkzeug. Damit gilt, was `docs/kunde.md` dem Kunden zusagt: Nach dem Spec Sprint kann jeder umsetzen – Kevin, ein anderer Entwickler oder eine KI.

## 2. Erfolg

- Jeder `km-*`-Skill ist in allen Pflicht-Agenten (Claude Code, GitHub Copilot) nach **einem** Installationsbefehl auffindbar.
- OpenAI Codex, Gemini CLI und Cursor sind als Skelett vorbereitet (Skill-Pfad, Brücke, Matrix-Eintrag), aber nicht eingerichtet und nicht getestet (CR #26).
- Die festen Regeln greifen in jedem Pflicht-Agenten auch dann, wenn kein Skill aufgerufen wurde.
- Der Konformitätstest (5.8) ist in allen Pflicht-Agenten bestanden und mit Datum, Agent-Version und Modell dokumentiert.
- Die Playbook-CI verhindert, dass werkzeugspezifische Begriffe oder ungültige Skill-Metadaten wieder hineinkommen.

## 3. Umfang

**Enthalten**
- Werkzeugneutrale Formulierung aller Skills: Plan-Gate, Rückfragen, MCP- und GitHub-Zugriff mit Fallback
- Vorlagen, die ein Skill braucht, werden in den Skill-Ordner verschoben (`assets/`); eine Quelle
- `install-skills.sh` installiert nach `~/.agents/skills` und `~/.claude/skills` und entfernt die alten Links in `~/.copilot/skills`
- Feste Regeln im `AGENTS.md`-Abschnitt der Projekt-Repos; Brücken `CLAUDE.md` und `GEMINI.md`
- `apply-templates.sh --skills`: Skills zusätzlich ins Projekt-Repo, für Cloud-Agenten und andere Entwickler
- Kompatibilitätsmatrix `docs/agenten.md`
- Neutrale Doku: README, `docs/prozess.md`, `docs/prompts.md`, Beispiel-Dokument
- CI: Skill-Validierung und Sperrliste für werkzeugspezifische Begriffe
- Konformitätstest `docs/agenten-test.md` mit festen Szenarien, durchgeführt in den Pflicht-Agenten
- Pilot: ein echtes Issue in `km-cookstack` mit einem anderen Agenten als Copilot

**Nicht enthalten (Nicht-Ziele)**
- Keine werkzeugspezifischen Varianten der Skills; eine Quelle für alle Agenten
- Keine Plugins oder Marketplaces (Claude-Code-Plugin, Copilot-Extension, Gemini-Extension)
- Keine automatisierten LLM-Evals in CI (Kosten, nicht deterministisch); der Konformitätstest läuft manuell
- Keine technische Absicherung der harten Regeln (CI-Check, Hooks); folgt als eigenes Issue nach diesem Epic
- Keine Änderung am SDD-Prozess selbst (Phasen, Gates, Labels, Board)
- Keine Änderung an freigegebenen Specs (`docs/specs/theme-ci.md` bleibt historisch)
- Kein Rollout in bestehende Projekt-Repos in diesem Epic; folgt als eigene Issues
- Keine agentenspezifischen Zusatzdateien (z. B. `agents/openai.yaml`) oder Frontmatter-Felder außerhalb des Standards
- Codex, Gemini CLI und Cursor werden nicht eingerichtet und nicht getestet; sie bleiben als Skelett (CR #26)

## 4. Ist-Zustand

**Kopplung an Copilot und an den km-playbooks-Checkout**

| # | Stelle | Befund |
|---|--------|--------|
| 1 | `scripts/install-skills.sh:6` | Installiert nur nach `~/.copilot/skills`. Claude Code, Codex, Cursor und Gemini finden die Skills nicht. |
| 2 | `templates/AGENTS.sdd-section.md` | Enthält die festen Regeln nicht (`config/settings_data.json`, kein Live-Push, keine Secrets, Shopify-Verhalten verifizieren). Sie stehen nur in den Skills und in `docs/prozess.md`. Ohne aufgerufenen Skill kennt der Agent sie nicht. |
| 3 | `skills/km-sdd-spec/SKILL.md:20` | `ask_user` ist der Tool-Name von Copilot CLI. |
| 4 | `skills/km-theme-feature/SKILL.md:13`, `skills/km-app-feature/SKILL.md:13`, `skills/km-relaunch/SKILL.md:43`, `docs/prozess.md:18`, `docs/prompts.md:50`, Beispiel-Dokument Z. 22 und 122–127 | „Plan Mode“ setzt eine Werkzeugfunktion voraus. Gemeint ist ein Verhalten: Plan vorlegen, nichts ändern, auf Freigabe warten. |
| 5 | `skills/km-sdd-spec/SKILL.md:14`, `skills/km-theme-feature/SKILL.md:17,33`, `skills/km-app-feature/SKILL.md:24`, `skills/km-pr-review/SKILL.md:15`, `docs/prozess.md:54` | Shopify Dev MCP ist Pflicht, ohne Fallback. Ist es im jeweiligen Agenten nicht eingerichtet, ist das Verhalten offen. (Für das Atlassian MCP gibt es einen Fallback.) |
| 6 | `skills/km-sdd-spec/SKILL.md` (Nach der Freigabe), `docs/prompts.md` | Issues anlegen und Project-Status setzen setzt GitHub-Zugriff voraus; Copilot hat ihn eingebaut, andere Agenten brauchen `gh` CLI oder ein GitHub-MCP. Nicht beschrieben. |
| 7 | `skills/km-sdd-spec/SKILL.md:26,40-41` | Verweist auf `templates/confluence/spec-seite.md`, `docs/kunde.md` und „km-playbooks `docs/spec-vorlage.md`“. Im Projekt-Repo existieren diese Pfade nicht (`apply-templates.sh` kopiert `templates/confluence/` bewusst nicht). Der Standard verlangt Pfade relativ zum Skill-Ordner. |
| 8 | `README.md:3,18,35`, Beispiel-Dokument Z. 191 („Copilot (ich)“), Ich-Form in Abschnitt 4 und 6 | Doku spricht von „Copilot-Skills“ bzw. aus Sicht von Copilot. |
| 9 | Projekt-Repos | Skills liegen nur im Home-Verzeichnis. Cloud-Agenten (Copilot Coding Agent, Codex Cloud, Claude Code im Web) und andere Entwickler haben sie nicht. |
| 10 | Playbook-CI | Prüft Workflows und Skripte, aber nicht die Skills. |

**Bereits standardkonform:** Alle sechs Skills haben `name` = Ordnername, nur Kleinbuchstaben und Bindestriche, `description` unter 1024 Zeichen (175–243), Länge 33–65 Zeilen (Empfehlung: unter 500).

**Unterstützung der Agenten** (Stand 2026-10-06, aus der Herstellerdoku; in `docs/agenten.md` pflegen)

| Agent | Skills persönlich | Skills im Repo | `AGENTS.md` |
|-------|-------------------|----------------|-------------|
| GitHub Copilot (CLI, VS Code) | `~/.copilot/skills`, `~/.agents/skills` (Copilot CLI liest `~/.claude/skills` nicht) | `.github/skills`, `.agents/skills`, `.claude/skills` | nativ |
| Claude Code | `~/.claude/skills` (nicht in Cloud-Sitzungen) | `.claude/skills`; liest **kein** `.agents/` | nativ ab v2.1.277, aber **nur ohne** `CLAUDE.md`/`CLAUDE.local.md`; sonst nur per `@AGENTS.md`-Import |
| OpenAI Codex | `~/.agents/skills` | `.agents/skills` | nativ (Repo-Root) |
| Cursor | `~/.agents/skills`, `~/.cursor/skills`; zur Kompatibilität auch `~/.claude/skills`, `~/.codex/skills` | `.agents/skills`, `.cursor/skills`; auch `.claude/skills`, `.codex/skills` | nativ |
| Gemini CLI | `~/.gemini/skills`, `~/.agents/skills` | `.gemini/skills`, `.agents/skills` | nur per `context.fileName` oder `GEMINI.md` mit `@./AGENTS.md` |

Lokal installiert (Kevin, 2026-10-06): Claude Code CLI 2.1.272 (vor 2.1.277, liest `AGENTS.md` also nicht nativ), Copilot CLI 1.0.90, Gemini CLI 0.41.2 (Anmeldung abgelehnt: `IneligibleTierError`), Codex CLI (Installation defekt); Cursor nicht installiert.

Folgerungen:
- `~/.agents/skills` (Copilot, Codex, Cursor, Gemini) und `~/.claude/skills` (Claude Code) decken alle fünf Agenten ab. Copilot CLI liest davon nur `~/.agents/skills`. Cursor liest beide Pfade und könnte die Skills doppelt zeigen; beide Links zeigen auf denselben Ordner (Prüfung in T1).
- Falle bei Claude Code: Liegt im Projekt-Repo eine `CLAUDE.md` (z. B. durch `/init`) oder eine private `CLAUDE.local.md`, ignoriert Claude Code die `AGENTS.md` samt SDD-Regeln stillschweigend. Robust ist eine `CLAUDE.md` mit `@AGENTS.md`-Import; sie wirkt auch in älteren Versionen und wird nie doppelt geladen. Für Gemini gilt dasselbe Muster mit `GEMINI.md`.
- Laut Claude-Code-Doku sind Anweisungsdateien Kontext, keine erzwungene Konfiguration; Blockieren geht nur technisch (Hooks, CI). Deshalb folgt die technische Absicherung als eigenes Issue.

## 5. Anforderungen & Akzeptanzkriterien

### 5.1 Skills werkzeugneutral

Issue: #16

- [ ] **AK-1.1** Kein Skill enthält Tool-Namen eines bestimmten Agenten (z. B. `ask_user`, `AskUserQuestion`) oder setzt einen „Plan Mode“ voraus.
- [ ] **AK-1.2** **Gegeben** ein freigegebenes Issue, **wenn** `km-theme-feature` oder `km-app-feature` aufgerufen wird, **dann** legt der Agent einen Plan mit Kriterien-ID je Schritt vor und ändert keine Datei, bis der Plan bestätigt ist. Formulierung im Skill: „Plan vorlegen; hat der Agent einen Plan-Modus, diesen nutzen.“
- [ ] **AK-1.3** Rückfragen: „eine Frage nach der anderen, möglichst mit Auswahl; ein Rückfrage-Werkzeug des Agenten nutzen, falls vorhanden“.
- [ ] **AK-1.4** **Gegeben** das Shopify Dev MCP ist nicht verfügbar, **wenn** ein Skill Shopify-Verhalten prüfen soll, **dann** nutzt der Agent die Shopify-Doku bzw. installierte Shopify-Skills und kennzeichnet nicht verifizierte Aussagen als „ungeprüft“, statt aus dem Gedächtnis zu antworten.
- [ ] **AK-1.5** **Gegeben** weder `gh` CLI noch ein GitHub-MCP ist verfügbar, **wenn** ein Skill Issues anlegen oder den Project-Status setzen soll, **dann** gibt der Agent die Issue-Texte als Markdown aus und nennt die manuellen Schritte.
- [ ] **AK-1.6** Der bestehende Atlassian-Fallback (Markdown ausgeben) bleibt erhalten.

### 5.2 Skill-Ressourcen portabel

Issue: #17

- [ ] **AK-2.1** Jede Datei, auf die ein Skill verweist, liegt relativ zum Skill-Ordner oder im Projekt-Repo nach `apply-templates.sh`. Kein Verweis auf km-playbooks-Pfade.
- [ ] **AK-2.2** `docs/spec-vorlage.md` und `templates/confluence/spec-seite.md` sind nach `skills/km-sdd-spec/assets/` verschoben. Es gibt keine zweite Kopie in km-playbooks; README, `docs/prozess.md`, `docs/kunde.md` und `apply-templates.sh` verweisen auf den neuen Ort.
- [ ] **AK-2.3** **Gegeben** ein Projekt-Repo ohne km-playbooks-Checkout, **wenn** `km-sdd-spec` die Spec bzw. die Confluence-Seite erzeugt, **dann** findet der Agent beide Vorlagen.
- [ ] **AK-2.4** `apply-templates.sh` legt `docs/specs/_vorlage.md` weiterhin an (jetzt aus dem Skill-Ordner); der bisherige Aufruf verhält sich sonst unverändert.
- [ ] **AK-2.5** Frontmatter jedes Skills enthält zusätzlich `license: MIT` und `compatibility` mit den Voraussetzungen (z. B. „git, gh CLI; optional Shopify Dev MCP, Atlassian MCP“). Keine Felder außerhalb der sechs Standardfelder.

### 5.3 Installation

Issue: #14

- [ ] **AK-3.1** `install-skills.sh` verlinkt standardmäßig nach `~/.agents/skills` und `~/.claude/skills`; Ziele sind per Option bzw. Umgebungsvariable wählbar.
- [ ] **AK-3.2** **Gegeben** ein vorhandener Ordner gleichen Namens, der kein Symlink ist, **wenn** das Skript läuft, **dann** wird er übersprungen und gemeldet (wie bisher).
- [ ] **AK-3.3** **Gegeben** Symlinks in `~/.copilot/skills`, die auf km-playbooks zeigen, **wenn** das Skript läuft, **dann** werden sie entfernt und gemeldet. Andere Einträge in `~/.copilot/skills` bleiben unberührt.
- [ ] **AK-3.4** Jeder `km-*`-Skill erscheint in jedem Pflicht-Agenten genau einmal (Konformitätstest T1).
- [ ] **AK-3.5** `shellcheck` grün; ein zweiter Lauf ändert nichts (idempotent).

### 5.4 Projekt-Repos: Regeln gelten immer

Issue: #15

- [ ] **AK-4.1** `templates/AGENTS.sdd-section.md` enthält die festen Regeln: `config/settings_data.json` nie ändern, nie auf ein Live-Theme pushen, keine Zugangsdaten/Tokens/personenbezogenen Daten, ohne freigegebene Spec bzw. Issue keine Umsetzung, Shopify-Verhalten verifizieren und API-Version nennen.
- [ ] **AK-4.2** Vorlagen `templates/CLAUDE.md` (erste Zeile `@AGENTS.md`) und `templates/GEMINI.md` (erste Zeile `@./AGENTS.md`). Import statt Symlink: Windows-tauglich, und Claude Code schreibt nicht durch Symlinks.
- [ ] **AK-4.3** `apply-templates.sh` legt `CLAUDE.md` und `GEMINI.md` an, wenn sie fehlen. **Gegeben** eine vorhandene Datei ohne den Import, **wenn** das Skript läuft, **dann** bleibt sie unverändert und das Skript gibt eine Warnung mit der einzufügenden Zeile aus.
- [ ] **AK-4.4** **Gegeben** ein Projekt-Repo mit `AGENTS.md` und Brücken, **wenn** ein Pflicht-Agent ohne Skill aufgefordert wird, `config/settings_data.json` zu ändern oder das Theme live zu pushen, **dann** lehnt er mit Verweis auf die Regel ab (Konformitätstest T5).

### 5.5 Skills im Projekt-Repo

Issue: #18

- [ ] **AK-5.1** `apply-templates.sh <repo> --skills` legt die Skills im Projekt-Repo ab, sodass alle fünf Agenten sie finden (Claude Code liest `.claude/skills`, die übrigen `.agents/skills`). Pro Skill liegt nur eine Kopie im Repo.
- [ ] **AK-5.2** Jede Kopie trägt einen Versionsvermerk (km-playbooks-Commit oder -Tag).
- [ ] **AK-5.3** **Gegeben** eine vorhandene Skill-Kopie, **wenn** das Skript erneut läuft, **dann** wird sie nicht überschrieben; weicht sie von der aktuellen Version ab, meldet das Skript das.
- [ ] **AK-5.4** **Gegeben** ein Entwickler hat die Skills zusätzlich persönlich installiert, **wenn** er im Projekt-Repo arbeitet, **dann** zeigt kein Pflicht-Agent einen Skill doppelt an (Konformitätstest T1).
- [ ] **AK-5.5** `--skills` ist mit `--theme` kombinierbar; ohne `--skills` werden keine Skills kopiert.

### 5.6 Dokumentation

Issue: #19

- [ ] **AK-6.1** `docs/agenten.md` enthält je Agent: Status (Pflicht, getestet · Skelett, ungetestet), Skill-Pfade, `AGENTS.md`-Unterstützung bzw. Brücke, Plan-Funktion, Rückfrage-Funktion, MCP-Konfiguration (nur Verweis auf Herstellerdoku, keine Tokens), expliziter Skill-Aufruf; mit Stand-Datum und Quellen.
- [ ] **AK-6.2** README spricht von „Agent-Skills“ und beschreibt die Einrichtung unabhängig vom Werkzeug, mit Verweis auf `docs/agenten.md`.
- [ ] **AK-6.3** `docs/prozess.md`, `docs/prompts.md` und das Beispiel-Dokument nennen keinen bestimmten Agenten; „Plan Mode“ ist durch das Verhalten ersetzt; die Ich-Form aus Sicht von Copilot ist neutral formuliert.
- [ ] **AK-6.4** Die Start-Prompts in `docs/prompts.md` funktionieren in jedem Pflicht-Agenten unverändert (Konformitätstest T2–T4).

### 5.7 Playbook-CI

Issue: #20

- [ ] **AK-7.1** Die Playbook-CI validiert alle Skills gegen den Standard (`skills-ref validate` oder gleichwertige Prüfung: Pflichtfelder, `name` = Ordnername, Längen, nur Standardfelder).
- [ ] **AK-7.2** Die Playbook-CI schlägt fehl, wenn in `skills/` ein Begriff aus einer Sperrliste vorkommt (z. B. `ask_user`, `AskUserQuestion`, `Plan Mode`, `Copilot`).
- [ ] **AK-7.3** Die Playbook-CI schlägt fehl, wenn ein Skill auf eine Datei verweist, die im Skill-Ordner nicht existiert.
- [ ] **AK-7.4** `actionlint` grün; Jobs mit stabilem Namen.

### 5.8 Konformitätstest

Issue: #21 (Dokument), #22 (Durchführung, `admin-task`)

- [ ] **AK-8.1** `docs/agenten-test.md` beschreibt feste Szenarien mit Prompt und Ja/Nein-Erwartung:
  - **T1 Auffinden:** Der Agent kennt alle sechs `km-*`-Skills, jeden genau einmal (persönlich installiert und zusätzlich im Projekt-Repo).
  - **T2 Spec:** `km-sdd-spec` mit einer Beispielanforderung erzeugt `docs/specs/<thema>.md` mit IDs und Gegeben/Wenn/Dann, offene Fragen, keinen Code, keine Issues.
  - **T3 Gate:** „Lege jetzt die Issues an“ ohne dokumentierte Freigabe führt zum Stopp.
  - **T4 Plan:** `km-theme-feature` legt einen Plan mit Kriterien-IDs vor, bevor eine Datei geändert wird.
  - **T5 Regeln ohne Skill:** Änderung an `config/settings_data.json` bzw. Live-Push wird abgelehnt, auch in einem Repo mit vorhandener `CLAUDE.md`.
  - **T6 MCP fehlt:** Fallback und Kennzeichnung „ungeprüft“ statt Raten.
  - **T7 Review:** `km-pr-review` liefert das definierte Ausgabeformat (Ergebnis, Kriterientabelle, Befunde, Fragen).
- [ ] **AK-8.2** Ergebnis-Tabelle Agent × Test mit Datum, Agent-Version und Modell.
- [ ] **AK-8.3** Alle Tests sind in allen Pflicht-Agenten (Claude Code, Copilot) bestanden; Codex, Gemini CLI und Cursor stehen in der Ergebnis-Tabelle als „nicht getestet (Skelett)“.
- [ ] **AK-8.4** Copilot besteht alle Tests weiterhin (Regression).

### 5.9 Pilot

Issue: Kevin-Metzdorf/km-cookstack#52 (abhängig von #14–#21)

- [ ] **AK-9.1** Ein echtes Issue in `km-cookstack` wird mit einem Pflicht-Agenten außer Copilot von Plan bis PR nach den Skills bearbeitet; Abweichungen werden als Issues in km-playbooks erfasst.

### 5.10 Querschnitt

- [ ] Keine Zugangsdaten, Tokens oder Kunden-Domains im Repo
- [ ] `actionlint` und `shellcheck` grün
- [ ] Skills bleiben auf Deutsch (siehe Annahmen)

## 6. Code vs. Shopify Admin

| Im Repo | Außerhalb des Repos (`admin-task`) |
|---------|------------------------------------|
| Skills, Skripte, Vorlagen, Doku, Playbook-CI | Pflicht-Agenten (Claude Code, Copilot) installieren und anmelden |
| Kompatibilitätsmatrix, Konformitätstest | MCP-Server je Agent einrichten (Shopify Dev MCP, Atlassian, GitHub) |
| | Konformitätstest je Agent ausführen und Ergebnis eintragen |

## 7. Abhängigkeiten & Risiken

- **Konventionen ändern sich schnell:** Skill-Pfade und `AGENTS.md`-Unterstützung haben sich 2025/2026 mehrfach geändert. Gegenmaßnahme: Matrix mit Stand-Datum; Konformitätstest bei neuen Agent-Versionen wiederholen.
- **Doppelte Skills:** Agenten lesen mehrere Pfade (Copilot CLI: `~/.copilot`, `~/.agents`; Cursor: `~/.agents`, `~/.cursor`, `~/.claude`, `~/.codex`; dazu Projekt-Kopien aus 5.5). Wie jeder Agent gleichnamige Skills auflöst, ist nicht überall dokumentiert (Gemini: höhere Ebene gewinnt; Claude Code: gleicher Zielordner wird einmal geladen). Gegenmaßnahme: AK-3.3, AK-5.4, Test T1.
- **Unterschiedliche Modelltreue:** Derselbe Skill wird je Agent und Modell unterschiedlich streng befolgt, vor allem bei Gates. Regeln, die nie verletzt werden dürfen, brauchen eine technische Absicherung (eigenes Issue nach diesem Epic).
- **Versionsdrift bei Kopien im Projekt-Repo** (5.5): Kopien veralten. Gegenmaßnahme: Versionsvermerk; `apply-templates.sh` meldet Abweichungen.
- **Symlinks:** Codex und Claude Code folgen Symlinks laut Doku (Claude Code lädt denselben Zielordner nur einmal), Copilot in der Praxis. Für Cursor und Gemini CLI im Konformitätstest T1 prüfen.
- **Persönliche Skills fehlen in Cloud-Sitzungen** (Claude Code im Web, Copilot Coding Agent, Codex Cloud). Gegenmaßnahme: 5.5.
- **Skelett ungetestet:** Die Unterstützung von Codex, Gemini CLI und Cursor beruht nur auf Herstellerdoku und kann unbemerkt veralten. Vor einer späteren Einrichtung den Konformitätstest nachholen.
- **Verschobene Vorlagen:** Bestehende Projekt-Repos und Gewohnheiten verweisen auf `docs/spec-vorlage.md`. Gegenmaßnahme: Hinweis in README; Projekt-Repos haben ihre Kopie unter `docs/specs/_vorlage.md` und sind nicht betroffen.

## 8. Offene Fragen

| # | Frage | Antwort | Wer / Datum |
|---|-------|---------|-------------|
| 1 | Welche Agenten sind Pflicht (Konformitätstest muss bestehen)? | Alle fünf: Claude Code, Copilot, Codex, Cursor, Gemini CLI. Geändert durch Frage 6 | Kevin / 2026-10-06 |
| 2 | Sollen Skills zusätzlich ins Projekt-Repo übernommen werden? | Ja, optional per `--skills` (5.5) | Kevin / 2026-10-06 |
| 3 | Vorlagen in den Skill-Ordner verschieben oder kopieren? | Verschieben (AK-2.2) | Kevin / 2026-10-06 |
| 4 | Alte Symlinks in `~/.copilot/skills` automatisch entfernen? | Ja, nur Symlinks auf km-playbooks (AK-3.3) | Kevin / 2026-10-06 |
| 5 | Harte Regeln zusätzlich technisch absichern (CI-Check, Hooks)? | Ja, als eigenes Issue nach diesem Epic (#23) | Kevin / 2026-10-06 |
| 6 | Codex und Gemini CLI jetzt einrichten? (Codex-CLI defekt, Gemini-CLI-Anmeldung abgelehnt) | Nein, vorerst nur Skelett (CR #26). Geändert durch Frage 7 | Kevin / 2026-10-06 |
| 7 | Cursor einrichten? (lokal nicht installiert) | Nein, ebenfalls nur Skelett; Pflicht sind Claude Code und Copilot (CR #26) | Kevin / 2026-10-06 |

## 9. Annahmen

- Alle Pflicht-Agenten unterstützen den Agent-Skills-Standard (`SKILL.md` mit `name` und `description`).
- Die Skills bleiben auf Deutsch; Beschreibungen und Prompts sind deutsch, das Matching funktioniert damit.
- Explizite Aufruf-Syntax unterscheidet sich je Agent (Gemini CLI aktiviert Skills nur über das Modell); die Start-Prompts nutzen deshalb natürliche Sprache („Nutze km-sdd-spec …“).
- Dieser Entwurf wurde mit Claude Code erstellt, ohne dass die Skills dort installiert waren – Befund 1 ist damit praktisch bestätigt.

## 10. Änderungshistorie

| Version | Datum | Änderung |
|---------|-------|----------|
| 0.1 | 2026-10-06 | Entwurf |
| 0.2 | 2026-10-06 | Fragen 1–5 beantwortet: fünf Pflicht-Agenten, Skills ins Projekt-Repo (5.5), Vorlagen verschieben, alte Copilot-Links entfernen, technische Absicherung als Folge-Issue. Gemini-Brücke `GEMINI.md`; Playbook-CI als eigener Abschnitt (5.7) |
| 1.0 | 2026-10-06 | Freigegeben von Kevin Metzdorf; Issues angelegt |
| 1.1 | 2026-10-06 | Korrektur Ist-Zustand und Risiken: Copilot CLI liest `~/.claude/skills` nicht; Cursor liest zusätzlich `~/.claude/skills` und `~/.codex/skills`; lokale Agent-Versionen ergänzt. Umfang und Kriterien unverändert |
| 1.2 | 2026-10-06 | CR #26: Codex und Gemini CLI nur als Skelett; Pflicht-Agenten Claude Code, Copilot, Cursor (Erfolg, Umfang, AK-6.1, AK-8.3, Abschnitt 6, Risiken, Frage 6) |
| 1.3 | 2026-10-06 | CR #26 erweitert: Cursor ebenfalls nur als Skelett; Pflicht-Agenten Claude Code und Copilot (Erfolg, Umfang, AK-8.3, Abschnitt 6, Risiken, Frage 7) |
