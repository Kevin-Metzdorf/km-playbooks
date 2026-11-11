---
name: km-a11y-audit
description: Zeitboxiertes Barrierefreiheits-Audit (WCAG 2.2 AA) für ein Shopify-Theme-Frontend – erst Repo-Code, dann Live-URL im Browser, Ergebnis als Markdown-Bericht mit Kunden- und Rohversion. Verwenden, wenn ein Accessibility-Check, ein "grober Überblick" über Barrierefreiheit oder die Suche nach Low-Hanging-Fruits für einen Kunden ansteht. Nicht für Checkout (Shopify-eigen), nicht für sofortige Fixes.
license: MIT
compatibility: "Node.js 20+, Playwright (Chromium), axe-core temporär. Optional: Shopify CLI."
---

# km-a11y-audit – Barrierefreiheit prüfen, Bericht erstellen

## Grundsätze

Diese fünf Regeln gelten immer, auch wenn der Auftrag anders klingt:

1. **Zeitbudget: 2 Stunden.** Das ist eine Stichprobe, keine Vollprüfung. Wird es knapp, wird der Umfang gekürzt – nicht die Sorgfalt pro Punkt.
2. **Nur prüfen, nicht reparieren.** Kein Code ändern. Der Kunde entscheidet, was behoben wird.
3. **Jeder Befund hat eine Fundstelle.** `datei:zeile` im Code, `URL + Selektor` live. Ohne Fundstelle ist es ein Verdacht und gehört nicht in den Bericht.
4. **Keine Muss-Sprache.** Nicht "muss behoben werden", sondern "betrifft …", "Aufwand …", "Auswirkung …". Der Kunde wählt.
5. **Nichts erfinden.** Findet sich nichts, steht das im Bericht. Ein leerer Befund ist ein Ergebnis, kein Fehler.

Nicht im Umfang: Checkout (Shopify-eigen), Shopify Admin, App-Backends, Performance, Rechtssicherheit/BFSG-Beratung. Diese Grenzen im Bericht nennen.

## Zeitplan

| Phase | Minuten | Ergebnis |
|---|---|---|
| 1 Umfang festlegen | 5 | 7 Flows, davon 3 für Tastatur-Test |
| 2 Code-Scan automatisiert | 15 | Rohliste potenzieller Befunde |
| 3 Code-Detail | 15 | verifizierte Befunde mit Datei:Zeile |
| 4 Live-Prüfung | 45 | Kontraste, Fokus, Tastatur, axe-Befunde |
| 5 Manuelle Stichprobe | 15 | Alt-Text-Sinn, Fehlermeldungen, Zoom |
| 6 Bericht | 30 | Markdown-Dokument mit Kunden- und Rohversion |

## Schritt 0 – Vorbereitung (einmalig, nicht im Budget)

```bash
node -v                      # 20+
node -e "require('playwright')" 2>/dev/null || npm i --prefix /tmp/a11y playwright
npm i --prefix /tmp/a11y @axe-core/playwright
npx --prefix /tmp/a11y playwright install chromium
```

**Wichtig:** Werkzeuge liegen in `/tmp/a11y`, nie im Theme-Repo. Das Theme hat keinen Build-Step – ein `node_modules` im Repo ist ein Fehler und landet im Diff.

## Schritt 1 – Umfang festlegen

Standardumfang, wenn der Kunde nichts anderes nennt: Startseite, Kategorie (Filter/Swatches), Produkt (Variante, Galerie, B2B/B2C-Umschalter), Warenkorb + Drawer, Suche inkl. Predictive Search, Kontaktformular, Mediacenter.

Für den **Tastatur-Test nur 3 Flows**, weil dort die meisten Barrieren sitzen: Produkt (Variantenwahl), Warenkorb-Drawer (Fokus-Falle), Kontaktformular (Labels/Fehler).

Der Kunde bestätigt Umfang und Erwartung **vor** der Prüfung. Ein Satz genügt: "Stichprobe über 7 Bereiche, 2 Stunden, Fokus auf schnell behebbare Punkte."

## Schritt 2 – Code-Scan (automatisiert)

Rohbefunde sammeln, noch nicht bewerten. Erst die einfachen Zeilenprüfungen (BSD-`grep`, ohne Zusatzinstallation – `ripgrep` ist auf dem Mac nicht vorinstalliert):

```bash
grep -rnE --include='*.liquid' 'tabindex="[1-9]' .
grep -rnE --include='*.liquid' '<(div|span)[^>]*(onclick|data-action)' .
grep -rohE --include='*.liquid' '<h[1-6][ >]' . | sort | uniq -c
grep -n '<html' layout/theme.liquid
grep -c ':focus' assets/custom.css
grep -rn 'aria-hidden="true"' --include='*.liquid' snippets sections \
  | grep -iE 'badge|sale|sold|price|status'
```

Dann tag-genau, weil `grep` zeilenweise arbeitet: `alt` und `aria-label` stehen in Liquid-Tags fast immer in der nächsten Zeile. Ein zeilenbasierter Scan meldet dadurch massenhaft Fehlalarme (in der Praxis: 12 Treffer, 0 echt) und übersieht gleichzeitig echte Fälle. Deshalb Python:

```bash
python3 - <<'PY'
import re, pathlib

def ln(s, i): return s[:i].count(chr(10)) + 1

bilder, namenlos = [], []
for p in pathlib.Path('.').rglob('*.liquid'):
    s = p.read_text(encoding='utf-8', errors='ignore')

    # <img> ohne alt oder bewusst dekorativ
    for m in re.finditer(r'<img\b[^>]*>', s, re.S):
        t = m.group(0)
        if 'alt=' not in t and 'role="presentation"' not in t:
            bilder.append(f"{p}:{ln(s, m.start())}")

    # Button/Link ohne zugänglichen Namen
    for m in re.finditer(r'<(button|a)\b([^>]*)>(.*?)</\1>', s, re.S):
        attrs, inner = m.group(2), m.group(3)
        if 'aria-label' in attrs or 'aria-labelledby' in attrs: continue
        if 'visually-hidden' in inner: continue
        if '<img' in inner and 'alt=' in inner: continue
        c = re.sub(r'\{%.*?%\}|<!--.*?-->', '', inner, flags=re.S)
        if re.search(r'[A-Za-zÄÖÜäöüß0-9]|\{\{', c): continue
        namenlos.append(f"{p}:{ln(s, m.start())}: " + re.sub(r'\s+', ' ', inner)[:70])

print('--- Bilder ohne alt:', len(bilder)); [print(' ', b) for b in bilder]
print('--- Buttons/Links ohne Namen:', len(namenlos)); [print(' ', n) for n in namenlos]
PY
```

Alle Treffer sind Kandidaten, keine Befunde. Besonders `aria-hidden` trifft oft nur Icons und ist dann korrekt - im Kontext prüfen, bevor etwas in den Bericht wandert.

Der zweite Block lohnt sich erfahrungsgemäß mehr als der erste: Er findet icon-only Buttons, deren Inhalt nur ein `{% render 'icon-...' %}` ist - der umschließende `<button>` steht dann in der Zeile darüber, und ein zeilenbasierter `grep` sieht dort keinen leeren Button.

## Schritt 3 – Code-Detail

Nur die Dateien lesen, die für die 7 Flows tatsächlich rendern. Reihenfolge:

1. `layout/theme.liquid` – `lang`, Skip-Link, Landmarks
2. `snippets/menu-drawer.liquid`, `snippets/cart-drawer*.liquid` – Fokus-Falle, `aria-hidden` auf Öffnen/Schließen
3. `snippets/buy-buttons.liquid`, `snippets/product-variant-picker*` – Variantenwahl per Tastatur, Radio-Gruppen
4. `snippets/price.liquid`, `snippets/pcard-badges.liquid` – Preis- und Rabattinformation für Screenreader
5. `snippets/predictive-search*`, `snippets/localization-drawer.liquid` – Ergebnisansage, Ländersuche
6. Kontaktformular-Section + `snippets/form-*` – Labels, Fehler, Pflichtfelder
7. Mediacenter (`sections/mediacenter*.liquid`) – Auswahlstatus, Download-Buttons

Für jeden Kandidaten aus Schritt 2 gilt: im gerenderten Kontext prüfen, nicht nur im Text. Was sich nicht bestätigen lässt, fliegt raus oder wird als "unbestätigt" markiert.

Prüfpunkte je Prinzip:

**Wahrnehmbarkeit** – Alt-Texte (dekorativ vs. informativ), Icon-Buttons mit `aria-label`, Video/iframe mit Titel und Untertiteln, genau eine `h1`, keine Überschriften-Sprünge, `<html lang>`, Information nicht nur über Farbe (Sale, "nicht verfügbar", Pflichtfeld), versteckte Inhalte in `aria-hidden`.

**Bedienbarkeit** – Klickbares `div`/`span` ohne `role`/`tabindex`, `tabindex > 0`, Drawer/Modal mit Fokus-Falle und Escape, Slider mit Tastatur und Pause, sichtbarer Fokus-Rahmen, Formular per Tastatur vollständig bedienbar.

**Verständlichkeit** – Fehlermeldungen vorhanden und konkret, Pflichtfelder erkennbar (nicht nur Sternchen/Farbe), beschreibende Linktexte, fremdsprachige Passagen mit eigenem `lang`, `autocomplete` gesetzt.

**Robustheit** – gültige ARIA-Rollen, keine doppelten `id`, `<button>` vs. `<a>` korrekt, Live-Region für Warenkorb-Updates (`role="status"` / `aria-live`), jeder Button/Link hat einen zugänglichen Namen.

## Schritt 4 – Live-Prüfung

Automatisiert über alle 7 URLs, danach Tastatur-Test von Hand.

```bash
mkdir -p /tmp/a11y/out
cat > /tmp/a11y/scan.js <<'EOF'
const { chromium } = require('/tmp/a11y/node_modules/playwright');
const fs = require('fs');
const AxeBuilder = require('/tmp/a11y/node_modules/@axe-core/playwright').default;

const urls = process.argv.slice(2);

(async () => {
  const browser = await chromium.launch();
  for (const url of urls) {
    const context = await browser.newContext({ viewport: { width: 1280, height: 900 } });
    const page = await context.newPage();
    await page.goto(url, { waitUntil: 'networkidle', timeout: 60000 });
    const axe = await new AxeBuilder({ page })
      .withTags(['wcag2a', 'wcag2aa', 'wcag21a', 'wcag21aa', 'wcag22aa'])
      .analyze();
    const u = new URL(url);
    const name = (u.hostname + u.pathname).replace(/\W+/g, '_').replace(/_+$/, '') || 'start';
    fs.writeFileSync('/tmp/a11y/out/' + name + '.json', JSON.stringify({ url, violations: axe.violations }, null, 2));
    console.log(name + ': ' + axe.violations.length + ' Verstöße');
    await context.close();
  }
  await browser.close();
})();
EOF
node /tmp/a11y/scan.js https://example.com/ https://example.com/collections/all
```

Was axe **nicht** findet und deshalb von Hand kommt:

- **Kontraste der eigenen Farbtokens.** Theme-Editor-Einstellungen und `custom.css` überschreiben sich – nur der gerenderte Zustand zählt.
- **Sichtbaren Fokus.** Pro Seite einmal mit Tab durchgehen und prüfen, ob der Fokusring sichtbar bleibt, auch auf Bildern und in Drawers.
- **Fokus-Falle.** Drawer öffnen, Tab bis zum Ende, Escape, danach prüfen, ob der Fokus zum Auslöser zurückkehrt.
- **Zoom 200 % und 320 px Breite.** Kein horizontales Scrollen, nichts abgeschnitten.
- **Fehlerzustände.** Formular absichtlich falsch absenden: wird die Meldung angesagt und dem Feld zugeordnet?
- **`prefers-reduced-motion`.** Slider und Animationen ruhig stellen.

Ein Befund aus einer App (Chat-Widget, Consent-Banner, Bewertungs-Widget) ist kein Theme-Befund. Als "Drittanbieter, nicht im Theme behebbar" kennzeichnen.

## Schritt 5 – Manuelle Stichprobe

15 Minuten, drei Dinge:

1. **Alt-Text-Sinn.** Drei Produktbilder anhören statt lesen: beschreibt der Text das Bild oder wiederholt er nur den Produktnamen?
2. **Fehlermeldung.** Kontaktformular ohne E-Mail absenden. Steht die Meldung am Feld, ist sie verständlich, wird sie vorgelesen?
3. **VoiceOver-Stichprobe** auf der Produktseite: Sind Preis, Variante und Kaufen-Button in sinnvoller Reihenfolge erreichbar?

## Schritt 6 – Bericht

Markdown, eine Datei, zwei Ebenen: oben für den Kunden, Anhang für dich. Sprache Deutsch, sofern nicht anders vereinbart.

```markdown
# Barrierefreiheit – Überblick

**Store:** <domain> · **Stand:** <Datum> · **Grundlage:** WCAG 2.2 AA
**Umfang:** <7 Bereiche> · **Art:** Stichprobe, keine vollständige Prüfung

## 1. Kurzfassung
Drei bis fünf Sätze: Was fällt auf, was ist solide, wo liegt der größte Hebel.
Keine Fachbegriffe ohne Erklärung.

## 2. Sofort machbar (Low Hanging Fruits)
| # | Befund | Wo | Auswirkung für Nutzer | Aufwand | Kriterium |
|---|---|---|---|---|---|
| 1 | … | `datei:zeile` / Selektor | … | 0,5 h | 1.1.1 |

## 3. Größere Themen
Kurz, je 2–3 Sätze, mit Aufwand. Ohne Empfehlung – die Entscheidung liegt beim Kunden.

## 4. Was schon gut ist
Mindestens drei konkrete Punkte. Baut Vertrauen und verhindert, dass Bewährtes
versehentlich geändert wird.

## 5. Was nicht geprüft wurde
| Bereich | Grund |
|---|---|
| Checkout | Shopify-eigen, nicht Theme |
| Screenreader-Tiefentest | außerhalb des 2-Stunden-Rahmens |
| Drittanbieter-Apps | nicht im Theme behebbar |

## 6. Anhang: Rohbefunde
| ID | Fundstelle | Beobachtung | Kriterium | Erfasst durch |
|---|---|---|---|---|
| R-01 | `snippets/x.liquid:42` | … | 4.1.2 | Code-Scan |
| R-02 | `/products/x` · `.card` | … | 1.4.3 | axe |
```

Regeln für den Bericht:

- **Maximal 10 Befunde in Abschnitt 2**, sortiert nach Wirkung für Nutzer. Alles Weitere in den Anhang. Zwanzig Punkte auf einmal lähmen – zehn werden abgearbeitet.
- **Aufwand in Stunden:** 0,5 / 1 / 2 / mehr als 2. Keine T-Shirt-Größen, keine Story Points.
- **Kriterium als Zusatz**, nicht als Überschrift: Das Prinzip führt, die WCAG-Nummer steht in Klammern dahinter.
- **Originalton der Fundstelle**, nicht Paraphrase. Ein Entwickler muss den Befund ohne Rückfrage wiederfinden.
- **Keine Empfehlung, was zuerst kommt.** Der Kunde priorisiert.

## Referenz: Prinzip → Kriterium

| Prinzip | Kriterien (WCAG 2.2 AA, Auswahl) |
|---|---|
| Wahrnehmbarkeit | 1.1.1 Alt-Texte · 1.2.2/1.2.3 Untertitel · 1.3.1 Struktur · 1.3.5 Eingabezweck · 1.4.1 Farbe allein · 1.4.3 Kontrast Text · 1.4.4 Zoom · 1.4.11 Kontrast Nicht-Text · 1.4.13 Hover/Fokus-Inhalte |
| Bedienbarkeit | 2.1.1 Tastatur · 2.1.2 Keine Falle · 2.2.2 Pause · 2.3.1 Keine Blitze · 2.4.3 Fokus-Reihenfolge · 2.4.7 Fokus sichtbar · 2.4.11 Fokus nicht verdeckt · 2.5.7 Ziehen · 2.5.8 Zielgröße mindestens (2.5.5 Zielgröße verbessert ist AAA, freiwillig) |
| Verständlichkeit | 3.1.1 Sprache · 3.1.2 Sprachwechsel · 3.2.1 Bei Fokus · 3.2.2 Bei Eingabe · 3.3.1 Fehlerkennzeichnung · 3.3.2 Labels · 3.3.3 Fehlervorschlag · 3.3.7 Redundante Eingabe |
| Robustheit | 4.1.2 Name, Rolle, Wert · 4.1.3 Statusmeldungen |

## Fallen, die in Shopify/Hyper-Themes fast immer auftreten

- **Badges in `aria-hidden`** – "Sale" oder "Ausverkauft" wird stumm versteckt, obwohl es Information ist.
- **Drawer ohne Fokus-Rückgabe** – nach dem Schließen steht der Fokus wieder am Seitenanfang.
- **Farbe als einzige Information** – Swatches ohne Text, Filterchips nur farbig, Pflichtfelder nur rot.
- **Swiper/Slider** – Pfeile nur per Maus, Autoplay ohne Pause.
- **AJAX-Warenkorb ohne Ansage** – Artikel landet im Korb, Screenreader erfahren nichts (4.1.3).
- **Custom-CSS ohne Fokus-Regeln** – Theme-CSS hat sie, eigene Komponenten nicht.
- **Kontrast im Code nicht beurteilbar** – Theme-Editor-Settings entscheiden; nur live messen.
- **App-Markup** – Consent-, Quote-, Bewertungs-Widgets sind nicht Theme-Sache. Kennzeichnen.

## Kurz-Checkliste

Zum Abhaken während des Audits:

- [ ] 7 Flows und 3 Tastatur-Flows mit Kunde bestätigt
- [ ] Werkzeuge in `/tmp/a11y`, Repo sauber
- [ ] Code-Scan gelaufen, Kandidaten gesammelt
- [ ] Alt-Texte geprüft
- [ ] Icon-Buttons haben zugängliche Namen
- [ ] Überschriften-Reihenfolge ok, eine `h1`
- [ ] `<html lang>` gesetzt
- [ ] Tastatur: alles erreichbar, nichts gefangen
- [ ] Fokus überall sichtbar
- [ ] Drawer: Fokus-Falle, Escape, Rückgabe
- [ ] Formular: Labels verknüpft
- [ ] Fehlermeldung angesagt und zugeordnet
- [ ] Kontraste live gemessen (Text, Icons, Fokusring)
- [ ] Zoom 200 % und 320 px
- [ ] Live-Region für Warenkorb geprüft
- [ ] `prefers-reduced-motion` beachtet
- [ ] Drittanbieter-Befunde markiert
- [ ] Alle Befunde mit Fundstelle
- [ ] Zwei Berichtsebenen erzeugt, max. 10 im Kundenteil
- [ ] Grenzen im Bericht genannt

## Was nicht prüfbar ist

Sinnhaftigkeit von Alt-Texten über die Stichprobe hinaus, Verständlichkeit der Sprache für echte Nutzer, das vollständige Screenreader-Erlebnis, Zeitlimits und Blitzinhalte, rechtliche Bewertung. Diese Punkte im Bericht als Grenze benennen – nicht als erledigt darstellen.

Automatische Prüfwerkzeuge finden erfahrungsgemäß nur einen Minderheitsanteil der Probleme. Der Bericht darf nie den Eindruck erwecken, die Seite sei damit vollständig geprüft.
