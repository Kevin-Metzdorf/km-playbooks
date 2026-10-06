# km-playbooks

Zentrale Quelle für den Spec-Driven-Development-Prozess (SDD) von Kevin Metzdorf Ltd: GitHub-Vorlagen, Labels, Copilot-Skills und Prozessdoku für Shopify-Theme- und App-Projekte.

## Inhalt

| Pfad | Zweck |
|------|-------|
| `docs/prozess.md` | Der SDD-Ablauf: Phasen, Gates, Board, wann voll / wann schlank |
| `docs/ci.md` | Einbindung der wiederverwendbaren Theme Check- und Lighthouse-CI |
| `docs/spec-vorlage.md` | Vorlage für `docs/specs/<thema>.md` im Projekt-Repo |
| `docs/kunde.md` | Kundensicht: Confluence als Schaufenster, Freigabeweg, Spec Sprint |
| `templates/confluence/spec-seite.md` | Kundenlesbare Spec-Seite für den Confluence-Bereich des Kunden |
| `docs/prompts.md` | Start-Prompts für jede Situation |
| `docs/beispiel-relaunch-headless-zu-native.md` | Ausgearbeitetes Beispiel |
| `templates/` | Dateien, die in Projekt-Repos kopiert werden (Issue-Formulare, PR-Vorlage, AGENTS.md-Abschnitt) |
| `labels.yml` | Standard-Labels |
| `skills/` | Copilot-Skills (Playbooks) pro Situation |
| `scripts/` | Installation der Skills, Übernahme der Vorlagen, Label-Sync |

## Skills

| Skill | Situation |
|-------|-----------|
| `km-sdd-spec` | Anforderung → Spec mit Akzeptanzkriterien → Issues (Basis für alles) |
| `km-relaunch` | Relaunch / Replatforming, z. B. Headless → natives OS-2.0-Theme |
| `km-theme-feature` | Neue Section, Block oder Template im Theme |
| `km-app-feature` | Feature in einer Shopify-App (React Router, Admin GraphQL, Extensions) |
| `km-bugfix` | Schlanker Ablauf für Bugs und kleine Änderungen |
| `km-pr-review` | PR-Review gegen AGENTS.md und Akzeptanzkriterien |

## Einrichtung

```bash
# 1. Skills für alle Agenten verfügbar machen: Symlinks nach ~/.agents/skills und ~/.claude/skills (Updates wirken sofort)
./scripts/install-skills.sh

# 2. Vorlagen in ein Projekt-Repo übernehmen (überschreibt nichts Bestehendes)
./scripts/apply-templates.sh /pfad/zum/projekt-repo

# 3. Labels im Projekt-Repo anlegen/aktualisieren (benötigt gh CLI, eingeloggt)
./scripts/sync-labels.sh owner/repo
```

Danach im Projekt-Repo den Abschnitt aus `templates/AGENTS.sdd-section.md` in die `AGENTS.md` übernehmen und auf das Projekt anpassen.

Für Theme-Repos können zusätzlich die CI-Vorlagen übernommen werden:
`./scripts/apply-templates.sh /pfad/zum/projekt-repo --theme`. Details stehen in
[`docs/ci.md`](docs/ci.md).

## Regeln

- `AGENTS.md` des Projekt-Repos hat Vorrang vor allem hier.
- In Kunden-Orgs mit eigenen Vorlagen: deren Vorlagen nutzen, hier nur die Skills.
- Keine Zugangsdaten, Tokens oder Kundendaten in dieses Repo.

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).
