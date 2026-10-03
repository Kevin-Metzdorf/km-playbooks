# Theme-CI

Die wiederverwendbaren Workflows zentralisieren Theme Check und Lighthouse CI
für Shopify-Theme-Repos. Theme Check erkennt Fehler in Liquid, Schema und
Übersetzungen. Lighthouse misst Storefront-Performance und Accessibility.

## Wann Lighthouse?

Theme Check sollte für jedes Theme-Repo als Pflicht-Check laufen. Lighthouse
ist sinnvoll, wenn die freigegebene Spec messbare Performance- oder
Accessibility-Ziele für konkrete Seiten enthält. Lighthouse-Ergebnisse können
um 5–10 Punkte schwanken; setzt deshalb Ziele mit Puffer statt knapp an der
Mindestgrenze.

Lighthouse lädt Theme-Dateien zur Prüfung in den angegebenen Store und kann
dort ein unveröffentlichtes Theme anlegen. Es veröffentlicht das Theme nicht.
Nutzt einen Dev- oder Staging-Store, nicht ohne ausdrückliche Zustimmung einen
Kunden-Live-Store. Es gibt hier kein Deployment und keinen `theme publish`.

## Einbindung in drei Schritten

1. Theme-Vorlagen übernehmen:

   ```bash
   ./scripts/apply-templates.sh /pfad/zum/projekt-repo --theme
   ```

   Das Skript überschreibt keine vorhandenen Dateien. Für eine Theme-App-
   Extension liegt die Beispielkonfiguration zusätzlich unter
   `templates/theme-app-extension/.theme-check.yml`; kopiert sie in das
   Extension-Verzeichnis und setzt `theme_root` im aufrufenden Workflow auf
   dieses Verzeichnis.

2. Für Lighthouse eine Dev-Dashboard-App anlegen, die App im passenden
   Dev-/Staging-Store installieren und die erforderlichen Secrets im
   Repository unter **Settings → Secrets and variables → Actions** eintragen.
   Benötigt werden `SHOP_STORE`, `SHOP_CLIENT_ID` und `SHOP_CLIENT_SECRET`.
   Optional sind `SHOP_PASSWORD` für einen passwortgeschützten Store und
   `LHCI_GITHUB_APP_TOKEN` für Lighthouse-CI-Status-Checks. Keine Werte in
   Dateien oder Logs übernehmen.

   Die App benötigt die Berechtigungen `read_products` und `write_themes`.
   Tokens werden von der Lighthouse-Action für den Lauf bezogen; Legacy-
   Custom-App-Tokens werden nicht unterstützt.

3. In den Repository-Regeln für `main` den Status-Check **Theme Check** als
   Pflicht-Check setzen. Die Lighthouse-Vorlage startet nur manuell oder wenn
   ein PR das Label `lighthouse` erhält; sie läuft nicht bei jedem Push.
   PR-Läufe aus Forks werden übersprungen, da diese keine Repository-Secrets
   erhalten.

Die Vorlage verwendet die wiederverwendbaren Workflows mit `@v1`. Der
Theme-Check-Aufrufer läuft bei Pull Requests und Pushes auf `main`. Der
Lighthouse-Aufrufer ist separat, damit seine Nutzung bewusst ausgelöst wird.

## Einstellungen und Grenzen

- `theme_root` verweist auf den Theme-Root relativ zum Repo (Standard `.`).
  Theme Check unterstützt auch Unterordner, etwa `./dist`.
- Lighthouse hat Standard-Mindestwerte Performance `0.6` und Accessibility
  `0.9`. Tragt konkrete Ziele in die Spec ein und überschreibt sie in der
  Lighthouse-Workflow-Vorlage.
- `product_handle` und `collection_handle` wählen die geprüften Seiten; ohne
  Werte verwendet die Action jeweils das erste verfügbare Produkt bzw. die
  erste Kollektion. Stores ohne passende Inhalte können damit keinen
  entsprechenden Lauf ausführen.
- `pull_theme` nimmt Theme-ID oder -Name an und nutzt dessen Einstellungen und
  JSON-Templates für den Lauf. Ohne Angabe gelten die Standard-Einstellungen.
- Parallele Lighthouse-Läufe pro PR werden zusammengefasst; ein neuer Lauf
  ersetzt einen noch laufenden.
- Die Workflows referenzieren `shopify/theme-check-action@v2`,
  `shopify/lighthouse-ci-action@v1` und `actions/checkout@v4`. Ändert eine
  kompatible zentrale Änderung, wird der Tag `v1` nach dem Merge auf den neuen
  Stand verschoben. Eine Änderung an Workflow-Eingaben, die bestehende
  Aufrufer inkompatibel macht, erhält stattdessen `v2`.

## `v1` nach einem Merge aktualisieren

Nur Maintainer setzen oder verschieben `v1`, nachdem der passende Commit auf
`main` gemergt ist. Im Playbook-Checkout:

```bash
git fetch origin main
git tag -f v1 origin/main
git push origin v1 --force
```

Das Verschieben von `v1` aktualisiert die zentrale Implementierung für alle
Aufrufer, die `@v1` verwenden. Bei Breaking Changes bleibt `v1` bestehen; der
neue Vertrag wird unter `v2` veröffentlicht und Aufrufer wechseln bewusst auf
`@v2`.
