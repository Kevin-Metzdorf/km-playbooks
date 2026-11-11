# km-playbooks

Zentrale Quelle für den Spec-Driven-Development-Prozess (SDD) von Kevin Metzdorf Ltd: GitHub-Vorlagen, Labels, Agent-Skills und Prozessdoku für Shopify-Theme- und App-Projekte. Die Skills folgen dem offenen [Agent-Skills-Standard](https://agentskills.io) und sind nicht an einen bestimmten Coding-Agenten gebunden.

## Inhalt

| Pfad | Zweck |
|------|-------|
| `docs/prozess.md` | Der SDD-Ablauf: Phasen, Gates, Board, wann voll / wann schlank |
| `docs/agenten.md` | Unterstützte Coding-Agenten: Status, Einrichtung, Besonderheiten |
| `docs/agenten-test.md` | Konformitätstest: sieben Tests mit Ja/Nein-Kriterien und Ergebnis-Tabelle je Agent |
| `docs/ci.md` | Einbindung der wiederverwendbaren Theme Check- und Lighthouse-CI |
| `skills/km-sdd-spec/assets/spec-vorlage.md` | Vorlage für `docs/specs/<thema>.md` im Projekt-Repo (vorher `docs/spec-vorlage.md`) |
| `docs/kunde.md` | Kundensicht: Gist als Standard, Freigabeweg, Spec Sprint (Confluence optional) |
| `skills/km-sdd-spec/assets/confluence-spec-seite.md` | Kundenfassungsvorlage für Gist/Mail/Confluence (Confluence optional; vorher `templates/confluence/spec-seite.md`) |
| `docs/prompts.md` | Start-Prompts für jede Situation |
| `docs/beispiel-relaunch-headless-zu-native.md` | Ausgearbeitetes Beispiel |
| `templates/` | Dateien, die in Projekt-Repos kopiert werden (Issue-Formulare, PR-Vorlage, AGENTS.md-Abschnitt, Brücken `CLAUDE.md`/`GEMINI.md`) |
| `labels.yml` | Standard-Labels |
| `skills/` | Agent-Skills (Playbooks) pro Situation |
| `scripts/` | Installation der Skills, Übernahme der Vorlagen, Label-Sync, Veröffentlichen der Kundenfassung als Gist |

## Ablauf

GitHub Issues sind der sichtbare SDD-Ablauf: Das Epic-Issue trägt die freigegebene Spec vollständig, die Feature- und Admin-Issues hängen daran, Freigabe-Nachweis und Review stehen im Epic bzw. PR. Jira ist nicht Teil des Prozesses. Die Kundenfassung geht als secret Gist zum Kunden (Link per Mail), Mail ist Rückkanal und Freigabeweg; Confluence ist optional. Das Review übernimmt Kevin oder ein beliebiger Agent; festgelegt ist nur die Checkliste aus `km-pr-review`, kein bestimmter Reviewer oder Bot. Details: [`docs/prozess.md`](docs/prozess.md).

## Skills

| Skill | Situation |
|-------|-----------|
| `km-sdd-spec` | Anforderung → Spec mit Akzeptanzkriterien → Issues (Basis für alles) |
| `km-relaunch` | Relaunch / Replatforming, z. B. Headless → natives OS-2.0-Theme |
| `km-theme-feature` | Neue Section, Block oder Template im Theme |
| `km-app-feature` | Feature in einer Shopify-App (React Router, Admin GraphQL, Extensions) |
| `km-bugfix` | Schlanker Ablauf für Bugs und kleine Änderungen |
| `km-pr-review` | PR-Review gegen AGENTS.md und Akzeptanzkriterien |
| `km-tech-analysis` | Aufgabe vor der Umsetzung per Expertenblick schärfen: Methoden, Rohmaterial, Werkzeuge und Prüfinstanzen in die Aufgabenstellung einarbeiten (automatisch beim Schärfen von Aufgaben, auch manuell per `/km-tech-analysis`) |
| `km-change-request` | Kundenwunsch gegen freigegebene Spec: CR prüfen, Aufwand/Termin bewerten, CR-Issue + Freigabe, Spec aktualisieren |

## Einrichtung

```bash
# 1. Skills persönlich installieren: Symlinks nach ~/.agents/skills und ~/.claude/skills (Updates wirken sofort)
./scripts/install-skills.sh

# 2. Vorlagen in ein Projekt-Repo übernehmen (überschreibt nichts Bestehendes)
./scripts/apply-templates.sh /pfad/zum/projekt-repo

# 3. Labels im Projekt-Repo anlegen/aktualisieren (benötigt gh CLI, eingeloggt)
./scripts/sync-labels.sh owner/repo
```

Danach im Projekt-Repo den Abschnitt aus `templates/AGENTS.sdd-section.md` in die `AGENTS.md` übernehmen und auf das Projekt anpassen. `CLAUDE.md` und `GEMINI.md` (legt `apply-templates.sh` an) binden `AGENTS.md` nur ein; Regeln werden ausschließlich in `AGENTS.md` gepflegt.

## Kundenfassung als Gist veröffentlichen

Die Kundenfassung (Markdown) geht als **secret** Gist zum Kunden; das Skript prüft vorher die EXTERN-Regeln
(keine API-Versionen, Repo-Pfade, „Code vs. Admin“, AK-IDs, interne Aufwände, Zugangsdaten) und gibt die URL aus.

```bash
./scripts/publish-kundenfassung.sh \
  --kunde "De Berkel" --thema "Barrierefreiheits-Audit" --version 1.0 \
  --datei pfad/zur/kundenfassung.md --dry-run
# ohne --dry-run: prüft die EXTERN-Regeln, legt den secret Gist an und gibt die URL aus
```

Preise, Verträge und personenbezogene Daten prüft das Skript nicht – das bleibt eine bewusste Entscheidung
(dafür PDF/Mail oder der Confluence-Bereich des Kunden). Danach Gist-URL und Stand/Revision im Epic als
Freigabe-Beleg eintragen.

Für Theme-Repos können zusätzlich die CI-Vorlagen übernommen werden:
`./scripts/apply-templates.sh /pfad/zum/projekt-repo --theme`. Details stehen in
[`docs/ci.md`](docs/ci.md).

Mit `--skills` landen die Skills zusätzlich im Projekt-Repo (`.agents/skills/`, verlinkt aus `.claude/skills/`), damit Cloud-Agenten und andere Entwickler sie haben. Kombinierbar mit `--theme`.

Welche Coding-Agenten unterstützt sind und was je Agent zu beachten ist (Brücken, Rangfolge bei gleichnamigen Skills, Windows): [`docs/agenten.md`](docs/agenten.md).

## Regeln

- `AGENTS.md` des Projekt-Repos hat Vorrang vor allem hier.
- In Kunden-Orgs mit eigenen Vorlagen: deren Vorlagen nutzen, hier nur die Skills.
- Keine Zugangsdaten, Tokens oder Kundendaten in dieses Repo.
- Kundenfassungen nur als secret Gist (nie public) und ohne interne Abschnitte, Tokens oder personenbezogene Daten; Gist nicht löschen, solange er als Freigabe-Nachweis dient.
- Skills ändern: vor dem Commit `./scripts/check-skills.sh` ausführen (benötigt Ruby). Die CI prüft dasselbe im Job `skills`: Frontmatter nach dem Agent-Skills-Standard, Sperrliste werkzeugspezifischer Begriffe (`scripts/skills-sperrliste.txt`), Verweise auf Dateien.

## Lizenz

Dieses Projekt steht unter der [MIT-Lizenz](LICENSE).
