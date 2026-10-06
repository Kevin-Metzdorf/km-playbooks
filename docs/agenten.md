# Coding-Agenten

Die Playbooks sind an keinen bestimmten Agenten gebunden: Skills folgen dem offenen [Agent-Skills-Standard](https://agentskills.io/specification), Projektregeln stehen in `AGENTS.md`. Diese Seite hält fest, was je Agent zu beachten ist.

**Stand:** 2026-10-06, aus der Herstellerdoku und eigenen Tests. Bei neuen Agent-Versionen prüfen und den Konformitätstest wiederholen.

## Status

| Agent | Status | Konformitätstest |
|-------|--------|------------------|
| Claude Code | Pflicht | ausstehend (#22) |
| GitHub Copilot (CLI, VS Code) | Pflicht | ausstehend (#22) |
| OpenAI Codex | Skelett, ungetestet | – (CR #26) |
| Cursor | Skelett, ungetestet | – (CR #26) |
| Gemini CLI | Skelett, ungetestet | – (CR #26) |

**Pflicht:** Der Konformitätstest muss bestehen. **Skelett:** Pfade, Brücken und dieser Eintrag sind vorbereitet; der Agent ist weder eingerichtet noch getestet. Die Angaben beruhen nur auf der Herstellerdoku.

## Einrichtung

1. Skills persönlich installieren: `./scripts/install-skills.sh` verlinkt nach `~/.agents/skills` und `~/.claude/skills`. Damit finden alle Agenten unten die Skills.
2. Projekt-Repo: `./scripts/apply-templates.sh <repo>` legt `CLAUDE.md` und `GEMINI.md` als Brücken zu `AGENTS.md` an. Mit `--skills` liegen die Skills zusätzlich im Repo (für Cloud-Agenten und andere Entwickler).
3. MCP-Server je Agent einrichten (Shopify Dev MCP, optional Atlassian und GitHub), siehe Spalte „MCP-Konfiguration“. Keine Tokens in Repos, Issues oder Logs.

## Übersicht

| Agent | Skills persönlich | Skills im Projekt | `AGENTS.md` | Plan vor Änderungen | Rückfrage-Werkzeug | MCP-Konfiguration | Skill ausdrücklich aufrufen |
|-------|-------------------|-------------------|-------------|---------------------|--------------------|-------------------|-----------------------------|
| Claude Code | `~/.claude/skills` | `.claude/skills` (liest kein `.agents/`) | nativ ab v2.1.277, aber nur ohne `CLAUDE.md`/`CLAUDE.local.md`; sonst Brücke `CLAUDE.md` mit `@AGENTS.md` | Plan-Modus: `Shift+Tab` oder `--permission-mode plan` | `AskUserQuestion` | `~/.claude.json` (lokal und persönlich), im Projekt `.mcp.json`; `claude mcp add` ([Doku](https://code.claude.com/docs/en/mcp)) | `/km-sdd-spec` |
| GitHub Copilot | `~/.copilot/skills`, `~/.agents/skills` (CLI liest `~/.claude/skills` nicht) | `.github/skills`, `.agents/skills`, `.claude/skills` | nativ; liest `CLAUDE.md` und `GEMINI.md` zusätzlich mit | Plan-Modus: `Shift+Tab`, `/plan` oder `--plan` (CLI); VS Code: `/plan` bzw. Agent „Plan“ | `ask_user` (CLI, abschaltbar mit `--no-ask-user`); VS Code: Name nicht dokumentiert | CLI: `~/.copilot/mcp-config.json`, im Projekt `.mcp.json` oder `.github/mcp.json` ([Doku](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers)); VS Code: `.vscode/mcp.json` ([Doku](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)) | `/km-sdd-spec` (CLI und VS Code) |
| OpenAI Codex | `~/.agents/skills` | `.agents/skills` | nativ (Repo-Root) | Plan-Modus: `/plan` oder `Shift+Tab` | Plan-Modus stellt Rückfragen; Werkzeugname nicht dokumentiert | `~/.codex/config.toml` (`[mcp_servers.<name>]`), im Projekt `.codex/config.toml` nur bei vertrauenswürdigen Projekten ([Doku](https://learn.chatgpt.com/docs/extend/mcp?surface=cli)) | `$km-sdd-spec` oder `/skills` |
| Cursor | `~/.agents/skills`, `~/.cursor/skills`; auch `~/.claude/skills`, `~/.codex/skills` | `.agents/skills`, `.cursor/skills`; auch `.claude/skills`, `.codex/skills` | nativ | Plan Mode: `Shift+Tab` oder Modus-Auswahl; CLI auch `/plan`, `--mode=plan` | eingebautes Werkzeug „Ask questions“; interner Name nicht dokumentiert | `~/.cursor/mcp.json`, im Projekt `.cursor/mcp.json` ([Doku](https://cursor.com/docs/context/mcp)) | `/km-sdd-spec` im Agent-Chat |
| Gemini CLI | `~/.gemini/skills`, `~/.agents/skills` | `.gemini/skills`, `.agents/skills` | nur über Brücke `GEMINI.md` mit `@./AGENTS.md` oder `context.fileName` | Plan Mode: `--approval-mode=plan`, `Shift+Tab` oder `/plan` | `ask_user` | `~/.gemini/settings.json` bzw. `.gemini/settings.json` (`mcpServers`), `gemini mcp add` ([Doku](https://geminicli.com/docs/tools/mcp-server)) | nicht dokumentiert; das Modell aktiviert Skills selbst (`activate_skill`), `/skills` verwaltet nur |

## Besonderheiten

### Claude Code

- **`AGENTS.md` wird stillschweigend ignoriert**, sobald im Projekt eine `CLAUDE.md` (z. B. durch `/init`) oder eine private `CLAUDE.local.md` liegt. Deshalb immer die Brücke `CLAUDE.md` mit `@AGENTS.md` als erster Zeile; `apply-templates.sh` warnt, wenn der Import fehlt. Getestet mit CLI 2.1.272: mit Brücke werden die festen Regeln befolgt, ohne Brücke findet Claude Code keine Projektregeln.
- **Gleichnamige Skills:** Die persönliche Installation hat Vorrang vor der Kopie im Projekt (Enterprise > persönlich > Projekt). Angezeigt wird der Skill einmal.

### GitHub Copilot

- Liest `AGENTS.md`, `CLAUDE.md` und `GEMINI.md` als Anweisungen (`copilot instruction list`). Weil die Brücken nur den Import enthalten, kommen die Regeln nicht doppelt.
- **Gleichnamige Skills (CLI):** Der zuerst gefundene gewinnt; Projektordner kommen vor den persönlichen. Damit hat die Kopie im Projekt Vorrang, und Skills aus `.agents/skills` und `.claude/skills` erscheinen nur einmal (getestet mit `copilot skill list`, CLI 1.0.90).
- **Copilot in VS Code** liest zusätzlich `~/.claude/skills`; die Rangfolge persönlich gegen Projekt ist dort nicht dokumentiert. Ob die Skills doppelt erscheinen, prüft T1 (#22).
- **MCP:** CLI und VS Code nutzen verschiedene Dateien (`.mcp.json` mit `mcpServers` bzw. `.vscode/mcp.json` mit `servers`); die CLI liest die VS-Code-Datei nicht.

### OpenAI Codex (Skelett)

- Liest nur die `AGENTS.md` im Repo-Root, keine verschachtelten.
- **Gleichnamige Skills werden nicht zusammengeführt;** persönliche Installation und Projektkopie (`--skills`) erscheinen beide. Für Codex deshalb entweder persönlich installieren oder die Projektkopie nutzen, nicht beides.

### Cursor (Skelett)

- Liest zusätzlich `~/.claude/skills` und `~/.codex/skills`. Mit `install-skills.sh` liegen die Skills in `~/.agents/skills` und `~/.claude/skills`; ob Cursor sie dann doppelt zeigt, ist ungetestet. Die Rangfolge bei gleichem Namen ist nicht dokumentiert.

### Gemini CLI (Skelett)

- Die Anmeldung über „Gemini Code Assist for individuals“ wurde am 2026-10-06 abgelehnt (`IneligibleTierError`); Google verweist auf eigene Nachfolgeprodukte.
- Entweder die Brücke `GEMINI.md` nutzen oder `AGENTS.md` über `context.fileName` einbinden, nicht beides, sonst wird `AGENTS.md` doppelt geladen.
- **Gleichnamige Skills:** Workspace vor persönlicher Installation; innerhalb einer Ebene `.agents/skills` vor `.gemini/skills`.

## Welche Skill-Version gilt?

- **Persönliche Installation:** Die Links zeigen auf den Arbeitsordner von km-playbooks. Aktiv ist der Stand des ausgecheckten Branches; im Alltag `main` ausgecheckt lassen.
- **Kopie im Projekt (`--skills`):** Stand des Commits aus `.agents/skills/<name>/.km-playbooks-version`. Aktualisieren: den Skill-Ordner löschen und `apply-templates.sh <repo> --skills` erneut ausführen. Das Skript meldet abweichende Kopien.
- **Beides vorhanden:** Claude Code nimmt die persönliche Installation, Copilot CLI und Gemini CLI die Projektkopie, Codex zeigt beide, bei Cursor ist es nicht dokumentiert. Weichen die Stände ab, arbeiten die Agenten mit unterschiedlichen Skills; die Projektkopie deshalb aktuell halten.

## Windows

- `install-skills.sh` legt Symlinks an. Unter Windows braucht das den Entwicklermodus oder Administratorrechte (z. B. in Git Bash oder WSL).
- `apply-templates.sh --skills` committet Symlinks in `.claude/skills`. Ohne `git config core.symlinks true` (und Entwicklermodus) werden daraus beim Klonen Textdateien, und Claude Code findet die Skills nicht. Die Brücken `CLAUDE.md`/`GEMINI.md` sind Importe, keine Symlinks, und funktionieren überall.

## Quellen

- Agent-Skills-Standard: <https://agentskills.io/specification>
- Claude Code: [Skills](https://code.claude.com/docs/en/skills), [CLAUDE.md und AGENTS.md](https://code.claude.com/docs/en/memory), [Plan-Modus](https://code.claude.com/docs/en/permission-modes), [MCP](https://code.claude.com/docs/en/mcp)
- GitHub Copilot: [CLI-Skills](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-skills), [CLI-Referenz](https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-command-reference), [CLI-MCP](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-mcp-servers), [VS Code Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills), [VS Code Plan](https://code.visualstudio.com/docs/agents/run/planning), [VS Code MCP](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)
- OpenAI Codex: [Skills](https://learn.chatgpt.com/docs/build-skills), [Plan-Modus](https://learn.chatgpt.com/guides/best-practices), [MCP](https://learn.chatgpt.com/docs/extend/mcp?surface=cli)
- Cursor: [Skills](https://cursor.com/docs/skills), [Plan Mode](https://cursor.com/docs/agent/plan-mode), [Agent-Werkzeuge](https://cursor.com/docs/agent/overview#tools), [CLI](https://cursor.com/docs/cli/overview), [MCP](https://cursor.com/docs/context/mcp)
- Gemini CLI: [Skills](https://geminicli.com/docs/cli/skills/), [GEMINI.md](https://github.com/google-gemini/gemini-cli/blob/main/docs/cli/gemini-md.md), [Plan Mode](https://geminicli.com/docs/cli/plan-mode), [ask_user](https://geminicli.com/docs/tools/ask-user), [MCP](https://geminicli.com/docs/tools/mcp-server)
