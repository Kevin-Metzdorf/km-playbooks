# Spec-Driven Development – Relaunch Headless → Native Shopify

**Ziel dieses Dokuments:** Jeder Schritt einfach erklärt – mit Ergebnis, Freigabe-Gate und konkretem Beispiel für einen Relaunch von einem Headless-Storefront (z. B. Hydrogen/Next.js) auf ein natives Online-Store-2.0-Theme (z. B. Horizon).

```
Anforderung → Spezifikation → Klärung & Freigabe → Plan → Implementierung → Prüfung
     ▲                                                                       │
     └──────────────── neue Erkenntnisse = Spec anpassen, nicht Code raten ───┘
```

**Grundregel:** Jede Phase endet mit einem *Artefakt* und einem *Gate*. Erst wenn das Gate erfüllt ist, geht es weiter.

---

## Übersicht

| # | Phase | Frage | Artefakt | Gate |
|---|-------|-------|----------|------|
| 1 | Anforderung | *Warum* und *was grob*? | Epic-Issue „Relaunch“ | Ziel & Rahmen klar |
| 2 | Spezifikation | *Was genau* soll das System tun? | Spec-Dokument + Feature-Issues mit Akzeptanzkriterien | Jedes Kriterium testbar |
| 3 | Klärung & Freigabe | Ist alles eindeutig und vom Kunden abgenommen? | Offene-Fragen-Liste geschlossen, Freigabe-Kommentar | Kunde gibt frei |
| 4 | Plan | *Wie* und in welcher Reihenfolge? | Umsetzungsplan pro Issue (Plan Mode) | Plan deckt alle Kriterien ab |
| 5 | Implementierung | Bauen | Branch + PR pro Issue | CI grün, PR verlinkt Issue |
| 6 | Prüfung | Erfüllt es die Spec? | Review + Abnahme-Checkliste | Alle Kriterien ✅ |

---

## 1. Anforderung

**Einfach erklärt:** Wir halten fest, *warum* der Kunde das will und *was grob* das Ergebnis sein soll – noch ohne Details oder Technik.

**Fragen an den Kunden**
- Warum weg von Headless? (Kosten, Wartung, Theme Editor für das Marketing, App-Kompatibilität?)
- Was muss gleich bleiben, was darf/soll sich ändern (Design, Funktionen, URLs)?
- Deadline, Budget, Go-Live-Fenster (nicht in der Peak-Saison)?
- Wer nimmt ab, wer liefert Inhalte?

**Artefakt:** Ein Epic-Issue „Relaunch native Theme“ im Repo + GitHub Project.

**Beispiel-Inhalt Epic**
- Ziel: Shop läuft auf nativem OS-2.0-Theme, Marketing pflegt Inhalte selbst im Theme Editor.
- Erfolg: Keine Ranking-Verluste durch kaputte URLs, Conversion mind. auf Vorniveau, Ladezeit vergleichbar oder besser.
- Nicht-Ziele: Kein Redesign der Markenidentität, keine neuen Zahlungsarten.

**Gate:** Ziel, Nicht-Ziele und Erfolgsmessung sind schriftlich festgehalten.

---

## 2. Spezifikation mit Akzeptanzkriterien

**Einfach erklärt:** Wir beschreiben *genau*, was der neue Shop können muss – so, dass man es prüfen kann. Kein „schön“ oder „schnell“, sondern „wenn X, dann Y“.

**Typischer Startpunkt beim Headless-Relaunch: Inventur des Ist-Zustands**

| Bereich | Leitfrage | Ergebnis |
|---------|-----------|----------|
| Seiten & Templates | Welche Seitentypen gibt es heute? | Template-Liste (Home, PLP, PDP, Content, Blog, Landingpages …) |
| Custom-Features | Was ist heute selbst gebaut? | Pro Feature: nachbauen im Theme, durch App ersetzen oder streichen |
| Daten & Inhalte | Wo liegen Inhalte heute (CMS, Metafields)? | Mapping auf Metafields/Metaobjects/Sections |
| URLs & SEO | Welche URL-Struktur existiert? | Redirect-Liste alt → neu |
| Integrationen | Tracking, Reviews, Newsletter, Suche, ERP | Pro Integration: native App oder Theme-Snippet |
| Märkte & Sprachen | Welche Länder/Sprachen? | Übersetzungs- und Markets-Anforderungen |

**Format für Akzeptanzkriterien (Given / When / Then)**

> **Feature:** Produktdetailseite – Variantenwahl
> - **Gegeben** ein Produkt mit Größe und Farbe, **wenn** ich eine nicht verfügbare Kombination wähle, **dann** ist „In den Warenkorb“ deaktiviert und „Ausverkauft“ wird angezeigt.
> - **Gegeben** eine Variante mit eigenem Bild, **wenn** ich sie wähle, **dann** springt die Galerie auf dieses Bild.
> - **Gegeben** die URL `?variant=123`, **wenn** die Seite lädt, **dann** ist diese Variante vorausgewählt.
> - Die Section ist im Theme Editor konfigurierbar (Bildgröße, Reihenfolge der Blöcke).
> - Bedienbar per Tastatur, Fokuszustände sichtbar.

**Querschnitts-Kriterien (gelten für alles)**
- Responsive: 375 px, 768 px, 1280 px geprüft.
- Barrierefreiheit: Lighthouse Accessibility ≥ 90, Tastaturbedienung.
- Performance: Lighthouse Performance mobil ≥ Zielwert X auf Home, PLP, PDP.
- Übersetzungen: Alle Texte über Locale-Dateien, keine hart codierten Strings.
- Theme Editor: Inhalte ohne Code-Änderung pflegbar.

**Wichtig – im Spec trennen: Code vs. Shopify Admin**

| Im Repo (Code) | Im Shopify Admin (nicht Code) |
|----------------|-------------------------------|
| Sections, Blocks, Snippets, Templates | Metaobject-/Metafield-*Definitionen* und Inhalte |
| Locale-Dateien | Navigation/Menüs |
| JS/CSS | URL-Redirects (Import) |
| App-Embed-Einbindung im Theme | Markets, Domains, Checkout-Einstellungen |
| | Apps installieren und konfigurieren |

→ Admin-Aufgaben bekommen eigene Issues mit Label `admin-task`, damit sie nicht untergehen.

**Artefakte**
- `docs/specs/relaunch.md` im Repo (Gesamt-Spec, versioniert).
- Pro Feature ein Issue mit Akzeptanzkriterien, verlinkt mit dem Epic.

**Gate:** Jedes Kriterium ist mit Ja/Nein prüfbar. Kein Kriterium enthält „schön“, „schnell“, „intuitiv“ ohne Messwert.

---

## 3. Klärung und Freigabe

**Einfach erklärt:** Alles, was unklar ist, wird jetzt geklärt – nicht während der Umsetzung. Dann gibt der Kunde die Spec frei. Was nicht in der Spec steht, ist ein Change Request.

**Kundensicht:** Die Spec bleibt im Repo; nach `skills/km-sdd-spec/assets/confluence-spec-seite.md` wird eine kundenlesbare Kopie mit derselben Versionsnummer im Confluence-Bereich des Kunden veröffentlicht. API-Versionen, Repo-Pfade und „Code vs. Admin“ bleiben intern; die Kriterien werden als „Wenn/Dann“ formuliert, ohne Voraussetzungen zu verlieren. Der Kunde beantwortet dort die Fragen und gibt die Version per Kommentar oder Mail frei – nie im GitHub-Epic. Im Epic halten wir nur fest, wer wann welche Version freigegeben hat, mit Link zum Nachweis (bei Mail zusätzlich das Mail-Datum). Details: [Kundensicht](kunde.md).

**Typische offene Fragen beim Headless-Relaunch**
- Werden alle Headless-Sonderfunktionen gebraucht oder reicht eine App?
- Bleiben die URLs gleich? Wenn nein: Wer prüft die Redirect-Liste?
- Wer migriert Inhalte aus dem alten CMS – Kunde oder wir?
- Startet das Theme auf Horizon oder einem anderen Basis-Theme?
- Welche Browser/Geräte sind Pflicht?
- Wie läuft der Go-Live (Zeitfenster, Rollback-Plan, Freeze-Phase)?

**Artefakte**
- Abschnitt „Offene Fragen“ in der Spec – jede Frage mit Antwort und Datum.
- Freigabe-Kommentar auf der Confluence-Seite oder schriftlich per Mail; Nachweis mit Person, Datum und Version im Epic verlinkt.

**Gate:** Offene Fragen = 0 (oder bewusst als Annahme markiert) und Freigabe mit Person, Datum, Version und Link im Epic dokumentiert. Erst danach Umsetzungs-Issues anlegen.

---

## 4. Plan Mode – Umsetzungsplan

**Einfach erklärt:** Jetzt geht es um das *Wie*. Pro Issue: welche Dateien, welche Reihenfolge, welche Risiken, wie wird getestet.

**So nutzt du das mit mir**
1. Session im Repo öffnen, Plan Mode.
2. Prompt: *„Plane Issue #12 gemäß Spec und AGENTS.md. Ordne jeden Schritt einem Akzeptanzkriterium zu.“*
3. Ich stelle Rückfragen, falls die Spec Lücken hat → zurück zu Phase 3, nicht raten.
4. Du gibst den Plan frei.

**Reihenfolge-Empfehlung für den Relaunch**
1. Basis: Theme-Setup, Design-Tokens, Layout, Header/Footer.
2. Kern-Commerce: PLP, PDP, Warenkorb, Suche.
3. Content: Home, Landingpages, Blog, Metaobject-basierte Sections.
4. Integrationen: App-Embeds, Tracking.
5. Querschnitt: Übersetzungen, Accessibility, Performance.
6. Go-Live-Vorbereitung: Redirects, QA, Rollback.

**Gate:** Jeder Planschritt ist einem Akzeptanzkriterium zugeordnet, kein Kriterium ist ohne Planschritt.

---

## 5. Implementierung

**Einfach erklärt:** Gebaut wird nur, was im Plan steht. Weicht die Realität ab, wird erst die Spec/der Plan angepasst.

**Arbeitsweise**
- Ein Branch und ein PR pro Issue; PR-Beschreibung verlinkt das Issue (`Closes #12`).
- Konventionen aus `AGENTS.md` gelten.
- Entwicklung gegen ein **unveröffentlichtes** Theme bzw. Dev-Store – nie direkt auf das Live-Theme pushen.
- `config/settings_data.json` wird nicht angefasst – gehört dem Theme Editor.
- Shopify-Dev-MCP / Theme Check zur Validierung von Liquid und Schemas.

**Gate:** PR offen, CI/Theme Check grün, jedes Akzeptanzkriterium in der PR-Beschreibung als Checkbox.

---

## 6. Prüfung gegen die Kriterien

**Einfach erklärt:** Wir prüfen nicht „sieht gut aus“, sondern hakt jedes Kriterium aus der Spec einzeln ab.

**Drei Ebenen**
1. **Code-Review** (mit mir): PR gegen AGENTS.md und Akzeptanzkriterien.
2. **Funktionale Prüfung**: Preview-Link des unveröffentlichten Themes, jedes Kriterium manuell oder per Playwright testen.
3. **Kundenabnahme**: Kunde prüft auf Preview, bestätigt im Issue.

**Go-Live-Checkliste (Relaunch-spezifisch)**
- [ ] Alle Feature-Issues geschlossen und abgenommen.
- [ ] Alle `admin-task`-Issues erledigt (Menüs, Metaobjects, Redirects, Markets).
- [ ] Redirect-Liste importiert und Stichprobe der wichtigsten alten URLs geprüft.
- [ ] Tracking/Pixel feuern (Testbestellung).
- [ ] Testbestellung je Zahlungsart.
- [ ] Headless-Storefront-Domain-Umstellung und Rollback-Plan dokumentiert.
- [ ] Kunde veröffentlicht das Theme bzw. gibt den Zeitpunkt frei.

**Gate:** Alle Kriterien ✅ → Issue schließen. Ein ❌ → zurück zu Phase 5 (Bug) oder Phase 2 (Spec war falsch).

---

## Einbau in deinen Prozess

| Werkzeug | Rolle im Ablauf |
|----------|-----------------|
| **GitHub Project** | Spalten: `Anforderung` → `Spec` → `Wartet auf Freigabe` → `Bereit` → `In Arbeit` → `Review` → `Abnahme` → `Done` |
| **Labels** | `epic`, `feature`, `admin-task`, `question`, `change-request` |
| **Issue-Template** | Felder: Ziel, Akzeptanzkriterien, Nicht-Ziele, Code vs. Admin, offene Fragen |
| **PR-Template** | `Closes #`, Akzeptanzkriterien als Checkboxen, Preview-Link, Screenshots |
| **`docs/specs/`** | Versionierte Specs im Repo – Quelle der Wahrheit für Feature-Verhalten |
| **`AGENTS.md`** | Quelle der Wahrheit für Stack, Konventionen, Definition of Done |
| **Copilot (ich)** | Phase 1–2: Spec + Issues entwerfen · Phase 3: offene Fragen sammeln · Phase 4: Plan Mode · Phase 5: Umsetzung · Phase 6: Review |

### Wann voll, wann schlank?

| Aufgabe | Vorgehen |
|---------|----------|
| Relaunch, neue App, Checkout-/Admin-Extension | Voller Prozess, alle Gates |
| Neues Feature/Section | Issue mit Akzeptanzkriterien + kurzer Plan |
| Kleiner Bugfix/CSS | Issue mit 1–2 Kriterien, direkt umsetzen |

### Kommerzieller Nebeneffekt
Die freigegebene Spec ist gleichzeitig deine **Angebotsgrundlage** und **Abgrenzung**: Alles außerhalb ist ein Change Request mit eigenem Aufwand.
