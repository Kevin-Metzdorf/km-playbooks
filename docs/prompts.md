# Start-Prompts

Kopierfertige Einstiege. Die Skills liefern die Details; der Prompt nennt nur Situation und Eingaben.

## Neue Anforderung → Spec

```
Nutze km-sdd-spec. Kunde: <Name>. Anforderung:
<Text, Mail, Gesprächsnotizen einfügen>
Erstelle Epic, Spec-Entwurf unter docs/specs/<thema>.md und die offenen Fragen. Noch keine Issues anlegen.
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
Nutze km-theme-feature für Issue #<nr>. Erst Plan Mode, dann umsetzen.
```

## App-Feature

```
Nutze km-app-feature für Issue #<nr>. Prüfe Scopes und API-Version über das Shopify Dev MCP, dann Plan.
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
