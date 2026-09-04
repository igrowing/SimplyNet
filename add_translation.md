# Adding a Translation to SimplyNet

SimplyNet is fully localized. A translation has **three parts**:

1. **UI strings** — the short labels, buttons and messages, stored as
   [ARB](https://localizely.com/flutter-arb/) files in [lib/l10n/](lib/l10n/).
2. **Help / About pages** — the long-form Markdown shown by the in-app info
   screens, stored in [assets/help/](assets/help/).
3. **Wiring** — three code/config spots that register the new locale so Flutter
   loads it and the Settings language picker offers it.

This guide walks through all three. Replace `xx` below with your language's
[ISO 639-1 code](https://en.wikipedia.org/wiki/List_of_ISO_639_language_codes)
(e.g. `nl` for Dutch, `sv` for Swedish). Chinese uses script-qualified tags
(`zh_Hans`, `zh_Hant`) — mirror the existing `zh` entries if you add another
Chinese variant.

---

## Prerequisites

- Flutter SDK matching [pubspec.yaml](pubspec.yaml) (`environment: sdk: ^3.12.0`).
- Run `flutter pub get` once after cloning.
- A UTF-8 capable text editor. All ARB and Markdown files are UTF-8, no BOM.

---

## Step 1 — Create the UI string file

1. Copy the English template to your language:

   ```
   cp lib/l10n/app_en.arb lib/l10n/app_xx.arb
   ```

2. Open `lib/l10n/app_xx.arb` and change the locale header on the first line:

   ```json
   "@@locale": "xx",
   ```

3. Translate **every value**, keeping **every key unchanged**. Only the text on
   the right-hand side is translated:

   ```json
   "settingsTitle": "Settings",      →   "settingsTitle": "Instellingen",
   ```

4. **Preserve placeholders and formatting exactly.** Some strings contain
   `{...}` placeholders — keep them verbatim, only move them to where they read
   naturally in your language:

   ```json
   "listeningOn": "Listening on \"{topic}\"",
   "noBandNetworks": "No {band} networks detected.",
   "publishedTo": "Published to {topic}",
   ```

   Also keep escaped quotes (`\"`), `×`, emoji, and leading/trailing spaces as
   in the source.

5. Do **not** add or remove keys. The English file
   [lib/l10n/app_en.arb](lib/l10n/app_en.arb) is the single source of truth
   (~254 keys). If you leave a key out, Flutter falls back to English for that
   string and prints a warning during generation.

---

## Step 2 — Translate the Help / About pages

Each language has its own folder under [assets/help/](assets/help/) containing
six Markdown files:

| File | Shown by |
|------|----------|
| `readme.md` | About SimplyNet screen |
| `ping_info.md` | Ping screen info button |
| `portscan_info.md` | Port Scan screen info button |
| `speedtest_info.md` | Speed Test screen info button |
| `tracert_info.md` | Traceroute screen info button |
| `whois_info.md` | WHOIS screen info button |

1. Create the folder and copy the English originals:

   ```
   mkdir assets/help/xx
   cp assets/help/en/*.md assets/help/xx/
   ```

2. Translate the prose in each file. Keep the Markdown structure intact:
   heading levels (`#`, `##`, `###`), `- ` / `* ` bullet markers, `**bold**`,
   `` `code` ``, `---` rules, table pipes `|`, and `[text](url)` links (translate
   the link *text*, leave the URL). The in-app renderer only supports this
   subset — don't introduce other Markdown.

3. If a help file is missing for your language, the app automatically falls back
   to the English copy (`assets/help/en/<name>`), so a partial translation is
   safe but please aim for all six.

4. Register the new folder in [pubspec.yaml](pubspec.yaml) under
   `flutter: assets:` — add a line next to the other `assets/help/...` entries:

   ```yaml
       - assets/help/xx/
   ```

---

## Step 3 — Wire up the locale

### 3a. Register the language in the picker

Edit [lib/l10n/app_languages.dart](lib/l10n/app_languages.dart) and add an entry
to `AppLanguage.supported` (order = display order in Settings):

```dart
AppLanguage(locale: Locale('xx'), countryCode: 'XX', endonym: 'Nederlands'),
```

- `locale` — `Locale('xx')`, or `Locale.fromSubtags(languageCode: 'xx',
  scriptCode: 'Yyyy')` for script-qualified languages.
- `countryCode` — an ISO 3166-1 alpha-2 code that selects the flag shown in the
  picker (rendered via the `country_flags` package). Pick the country most
  associated with the language (`NL`, `SE`, `BR`, …).
- `endonym` — the language's own name, written in that language
  (`Nederlands`, `Svenska`, `Português`). This is shown regardless of the
  active UI language.

### 3b. Regenerate the Dart localizations

The `AppLocalizations` classes in [lib/l10n/](lib/l10n/) are **generated from the
ARB files and committed to the repo**. Regenerate them:

```
flutter gen-l10n
```

(A normal `flutter run` / `flutter build` also regenerates them because
`flutter: generate: true` is set in [pubspec.yaml](pubspec.yaml).)

This creates `lib/l10n/app_localizations_xx.dart` and updates
`lib/l10n/app_localizations.dart` (its `supportedLocales` list and the
`lookupAppLocalizations` switch). **Commit these generated files** along with
your ARB file — CI and other contributors expect them checked in.

Configuration for generation lives in [l10n.yaml](l10n.yaml); you should not need
to change it.

### 3c. Nothing to change in `main.dart`

[lib/main.dart](lib/main.dart) already wires
`AppLocalizations.localizationsDelegates` and
`AppLocalizations.supportedLocales`, so once generation picks up your locale it
is live.

---

## Step 4 — Verify

1. Regenerate and analyze:

   ```
   flutter gen-l10n
   flutter analyze
   ```

   Watch the `gen-l10n` output for `Untranslated message` warnings — each one is
   a key you missed in `app_xx.arb`.

2. Run the app, open **Settings → Language**, pick your language, and walk
   through the screens:
   - Home, Scan, Network Tools, Logs, Settings
   - Each tool screen and its **ⓘ info button** (checks `assets/help/xx/*`)
   - **About SimplyNet** (checks `assets/help/xx/readme.md`)

3. Check for layout overflow — some languages are much longer than English.
   Shorten wording where a button or column clips.

4. Run the test suite:

   ```
   flutter test
   ```

---

## Step 5 — Submit

1. Bump the language count where it appears in prose:
   [README.md](README.md) ("Translated to N languages") and
   `assets/help/en/readme.md` (plus the other `readme.md` copies if you update
   them).
2. Commit:
   - `lib/l10n/app_xx.arb`
   - `lib/l10n/app_localizations_xx.dart` + regenerated
     `lib/l10n/app_localizations.dart`
   - `lib/l10n/app_languages.dart`
   - `assets/help/xx/*.md`
   - `pubspec.yaml`
   - doc/prose count updates
3. Open a pull request describing the language added and noting whether the
   help pages are complete or partial.

---

## Checklist

- [ ] `lib/l10n/app_xx.arb` created, `@@locale` set, all keys translated, placeholders preserved
- [ ] `assets/help/xx/` created with translated Markdown (all six files ideally)
- [ ] `pubspec.yaml` — `assets/help/xx/` line added
- [ ] `lib/l10n/app_languages.dart` — `AppLanguage` entry added (locale, countryCode, endonym)
- [ ] `flutter gen-l10n` run; generated `app_localizations*.dart` committed
- [ ] `flutter analyze` clean, no untranslated-message warnings
- [ ] `flutter test` passes
- [ ] Manually verified via Settings → Language
- [ ] Language count updated in README / About text
