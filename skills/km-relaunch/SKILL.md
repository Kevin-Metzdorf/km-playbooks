---
name: km-relaunch
description: Playbook für Shopify-Shop-Relaunches (z. B. Headless → natives Online-Store-2.0/Horizon-Theme, Theme-Wechsel, Plattform-Migration). Verwenden für Bestandsaufnahme, Relaunch-Spec, Umsetzungsreihenfolge und Go-Live-Checkliste.
---

# km-relaunch – Relaunch eines Shopify-Shops

Baut auf `km-sdd-spec` auf. Zuerst `AGENTS.md` lesen; sie hat Vorrang.

## Werkzeuge

- **GitHub (Issues, PRs, Project):** über `gh` CLI oder ein GitHub-MCP. Ist keins verfügbar: benötigte Inhalte beim Nutzer erfragen, Texte zum Anlegen als Markdown ausgeben und die manuellen Schritte nennen.

## 1. Bestandsaufnahme (Ist-Zustand)

Als Tabelle in der Spec dokumentieren. Für jeden Punkt festhalten: übernehmen / ersetzen / entfällt.

| Bereich | Was erfassen |
|---|---|
| Templates | Startseite, Kollektion, Produkt, Suche, Warenkorb, Blog, Seiten, Konto, 404 |
| Custom-Features | Konfiguratoren, Filter, Bundles, Größenberater, Personalisierung |
| Inhalte | Herkunft (CMS, Metafields, hart codiert), Ziel (Metaobjects, Sections, Seiten) |
| URLs | Bestehende URL-Struktur, Top-URLs nach Traffic → Redirect-Liste |
| Integrationen | Tracking, Consent, Reviews, Newsletter, ERP/PIM, Suche, Apps |
| Märkte | Sprachen, Währungen, Domains |
| SEO | Titles, Meta Descriptions, strukturierte Daten, hreflang, Sitemap |

Headless-spezifisch: Was erledigte bisher das Frontend, das jetzt Theme, App oder Admin übernehmen muss (Routing, Suche, Filter, Personalisierung)? Dafür Ersatz festlegen.

## 2. Spec

Mit `km-sdd-spec`. Zusätzlich verpflichtend:
- Kriterien für **Parität** („Feature X funktioniert wie vorher“ präzisiert)
- Redirect-Kriterium: alle URLs der Liste liefern 301 auf ein sinnvolles Ziel
- Tracking-Kriterium: Events feuern nach Consent wie spezifiziert
- Performance-Ziele als Zahlen (Platzhalter mit Kunde abstimmen)

## 3. Umsetzungsreihenfolge

1. **Basis:** Theme-Setup, Design-Tokens, Typografie, Header, Footer, Locales
2. **Kern-Commerce:** Kollektion, Produkt, Warenkorb, Suche
3. **Content:** Startseite, Landingpages, Blog, Metaobject-basierte Sections
4. **Integrationen:** Apps, Tracking, Consent
5. **Querschnitt:** Barrierefreiheit, Performance, SEO
6. **Go-Live**

Jede Stufe besteht aus Issues mit Kriterien. Pro Issue zuerst einen Plan vorlegen, ohne Dateien zu ändern, und die Bestätigung abwarten; jeder Planschritt verweist auf eine Kriterien-ID.

## 4. Admin-Aufgaben (kein Code)

Als `admin-task` anlegen: Metaobject-Definitionen und -Inhalte, Navigation, URL-Redirects-Import, Markets/Domains, App-Installation, Checkout-Einstellungen, Theme-Veröffentlichung.

## 5. Go-Live-Checkliste

- [ ] Alle Kriterien im Preview-Theme abgenommen (Kunde)
- [ ] Redirects importiert und stichprobenartig geprüft
- [ ] Tracking und Consent im Preview geprüft
- [ ] Testbestellung im Preview (inkl. Rabattcode, Versandarten)
- [ ] Sitemap, robots, hreflang geprüft
- [ ] Rollback: vorheriges Theme bzw. Headless-Frontend bleibt abrufbar
- [ ] Veröffentlichung durch Kunde oder nach schriftlicher Freigabe als `admin-task`
- [ ] Nach Go-Live: 404-Monitoring, Search Console, Conversion 7/30 Tage

## Feste Regeln

- `config/settings_data.json` nie anfassen.
- Nie auf ein Live-Theme pushen; Arbeit nur in unveröffentlichten Themes.
- Keine Zugangsdaten oder personenbezogenen Daten.
