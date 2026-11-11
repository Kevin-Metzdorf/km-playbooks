# Start-Prompts

Kopierfertige Einstiege. Die Skills liefern die Details; der Prompt nennt nur Situation und Eingaben.

Die Prompts sind normale Sprache und funktionieren in jedem unterstützten Coding-Agenten. Wie man einen Skill je Agent ausdrücklich aufruft, steht in [`docs/agenten.md`](agenten.md).

## Neue Anforderung → Spec

```
Nutze km-sdd-spec. Kunde: <Name>. Anforderung:
<Text, Mail, Gesprächsnotizen einfügen>
Erstelle Epic, Spec-Entwurf unter docs/specs/<thema>.md und die offenen Fragen. Noch keine Issues anlegen.
```

## Kundenfassung erzeugen (Confluence optional)

```
Nutze km-sdd-spec. Erzeuge aus docs/specs/<thema>.md, Version <x>, eine kundenlesbare Fassung
nach der Vorlage aus km-sdd-spec. Ohne API-Versionen, Repo-Pfade und Abschnitt „Code vs. Admin“;
Kriterien als „Wenn/Dann“, ohne Voraussetzungen wegzulassen. Standardweg: Markdown/PDF per Mail
an den Kunden. Optional: im Confluence-Bereich <Bereich> des Kunden veröffentlichen, wenn vorhanden
(ist das Atlassian MCP verfügbar, lege die Seite dort direkt an; sonst gib Markdown aus).
Die Spec im Repo bleibt die Quelle. Noch keine Umsetzungs-Issues anlegen.
```

## Spec in Epic eintragen

```
Nutze km-sdd-spec. Trage den vollständigen Spec-Text aus docs/specs/<thema>.md, Version <x>,
in Epic #<nr> ein: Abschnitte 1–10, mit Versionsnummer und Link zum Dateipfad.
Die Datei bleibt die Quelle, das Epic-Issue ist die sichtbare Kopie. Bei Versionsänderungen
den Spec-Text im Epic mit derselben Version aktualisieren. Noch keine Umsetzungs-Issues anlegen.
```

## Freigabe eintragen

```
Nutze km-sdd-spec. Kunde hat die Spec docs/specs/<thema>.md freigegeben:
Version <x>, von <Name>, am <Datum>, Nachweis <Mail-Datum mit Link, Link zum Kommentar oder Confluence-Link (optional)>.
Trage wer, wann, Version und Nachweis ins Epic #<nr> ein und setze dessen Status im Project auf „Bereit“.
Steht der Spec-Text noch nicht vollständig im Epic, trage ihn dort ein (Abschnitte 1–10, mit Version).
Der Nachweis kann per Mail, Kommentar oder in Confluence (optional) entstanden sein. Noch keine Umsetzungs-Issues anlegen.
```

## Spec freigegeben → Issues

```
Nutze km-sdd-spec. Die Spec docs/specs/<thema>.md ist freigegeben (Version <x>).
Lege die Feature- und admin-task-Issues an, verlinke sie mit Epic #<nr> und setze sie im Project auf „Bereit“.
```

## Relaunch

```
Nutze km-relaunch. Ist-Stand: <Headless-Stack, URL, Repo>. Ziel: <Basis-Theme, z. B. Horizon>.
Starte mit der Inventur und liefere Spec-Entwurf + offene Fragen.
```

## Neue Section / Block

```
Nutze km-theme-feature für Issue #<nr>. Erst den Plan vorlegen und auf meine Bestätigung warten, dann umsetzen.
```

## App-Feature

```
Nutze km-app-feature für Issue #<nr>. Prüfe Scopes und API-Version, dann den Plan vorlegen und auf meine Bestätigung warten.
```

## Bug

```
Nutze km-bugfix für Issue #<nr>. Reproduzieren, Ursache benennen, minimal fixen.
```

## PR-Review

```
Nutze km-pr-review für PR #<nr>.
```

## Change Request

```
Der Kunde wünscht: <Text>. Prüfe gegen docs/specs/<thema>.md, ob das ein Change Request ist,
und entwirf ggf. ein Change-Request-Issue mit Auswirkung auf Aufwand und Spec.
```
