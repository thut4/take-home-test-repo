# J'Donuts

A working slice of the J'Donuts customer app, built for the Madivizion Senior
Flutter Developer code test: fake login and registration with real
validation, an offline-first Home and Product detail, and an animated Rewards
screen.

| | |
|---|---|
| Flutter | 3.47.9 (stable) |
| Dart | 3.13.7 |
| Platforms | iOS Simulator, Android emulator |
| State management | Riverpod 3 (`flutter_riverpod` 3.5) |
| Local database | Drift (SQLite), schema v2 |
| Fake OTP code | **123456** |
| Demo account (log-in path) | **09 123 456 789** |

## Run it

```bash
flutter pub get
dart run build_runner build      # Drift, freezed, json_serializable
flutter run                      # pick the iOS Simulator or an Android emulator
```

Optional mock server (to see background refresh and image caching work):

```bash
cd server
dart pub get
dart run bin/server.dart         # http://localhost:8080
```

The app looks for the server at `http://10.0.2.2:8080` on the Android
emulator and `http://localhost:8080` on the iOS Simulator. Override with
`--dart-define=API_BASE_URL=http://<host>:8080`. The app works fully without
the server; it just keeps its bundled data.

### Tests

```bash
flutter analyze
flutter test                                   # unit + widget (154 tests)
flutter test integration_test -d <simulator>   # Register → Home → Product detail

# Same flow, saving a screenshot of every screen to build/screenshots/
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_flow_test.dart -d <simulator>
```

### Builds

```bash
flutter build apk --release                    # build/app/outputs/flutter-apk/app-release.apk
flutter build ios --simulator                  # build/ios/iphonesimulator/Runner.app
```

## Trying the flows

- **Register:** Let's get started → any valid Myanmar number (e.g.
  `09 254 135 592`) → `123456` → name → date of birth → Welcome → Home.
- **Log in:** Log in → `09 123 456 789` (seeded account "Hania") →
  `123456` → Home. An unregistered number shows an inline message with a
  link to register; a registered number on the register path offers Log in.
- **Session:** relaunch while signed in opens Home. Settings → Log out
  returns to Onboarding.
- **Offline:** use the app once, turn on airplane mode, relaunch. Home,
  Product detail and Rewards render from the database with images; a bar
  says you're offline. Turn the network back on and Home refreshes by
  itself (or pull to refresh). With the mock server running, a refresh
  adds the server-only *Matcha Glazed Donut* and its banner, and its image
  stays cached for the next offline launch.
- **Language:** Settings → Language switches English ↔ Burmese.

## Architecture

Feature-first, three layers per feature. Presentation depends on domain;
data implements domain's interfaces. Replacing the fake auth or the mock
server touches only the data layer and one provider.

```
lib/
  main.dart                    → bootstrap()
  app/                         app root, router (auth guard), routes, locale, shared widgets
  core/                        Result + typed Failures, Drift database + seeder,
                               Dio client (envelope, retry, logging), connectivity, env
  design_system/               tokens (colour, type, spacing, motion) + components
  l10n/                        ARB files (en, my) and generated localisations
  features/
    auth/      domain/  validators (pure), AuthRepository, use cases, UserAccount
               data/    FakeAuthRepository (local users table), SecureSessionStore
               presentation/ session, flow and OTP controllers; screens 1–7
    home/      domain/  HomeRepository, banners, sections, shops
               data/    DriftHomeRepository, CatalogRemoteDataSource, DTOs
               presentation/ Home (screen 8), catalogue sync controller
    product/   domain/  Product, ProductRepository   data/ Drift   presentation/ screen 9
    member/    domain/  Member, Tier                 data/ Drift
    rewards/   domain/  Challenge, tier ladder       data/ Drift   presentation/ screen 10
    shell/     bottom navigation with the sliding pill, placeholder tabs
    settings/  Log out, language
server/                        mock API (Dart shelf): /v1/..., {data, error, meta}
tool/art/                      script that generates every bitmap in assets/images
```

Rules that are enforced by tests (`test/architecture/import_boundaries_test.dart`):

- Domain layers import no Flutter, no data and no presentation code.
- Screens import UI only through `design_system/design_system.dart`, never
  `material_ui`/`cupertino_ui` or the deprecated in-SDK libraries.
- Presentation never imports a data source directly.

Other conventions:

- Repositories and use cases return `Result<T>` (`Ok` / `Err(Failure)`);
  nothing throws across a layer boundary. Database errors become
  `CacheFailure`, transport errors `NetworkFailure`/`ServerFailure`, and the
  original error is logged where it happens.
- Every screen and Home section handles loading (skeletons), empty and
  error (with retry).
- Colours, type, spacing, radii and every animation duration/curve are
  tokens in `lib/design_system/tokens/`; widgets contain no literal colours.
- Models are immutable (`freezed` entities, `json_serializable` DTOs).

### Why Riverpod

It covers dependency injection and state in one tool: repositories and use
cases are plain providers that tests override one at a time, and screen
state is `Notifier` / `StreamProvider` with `AsyncValue`, so loading, error
and data are handled exhaustively with a `switch`. There are no
`BuildContext`s in controllers, and `autoDispose` cleans up the OTP timer
and database watchers when a screen goes away. BLoC would have worked too,
but needs get_it (or similar) for DI and more boilerplate for the same
result.

## Offline strategy

- **The database is the single source of truth.** Screens only watch Drift
  queries. Nothing in the UI waits on the network.
- **First launch seeds everything** (products, sections, banners, shops,
  tiers, challenges, the member template and a demo account) from
  `assets/seed/seed.json` in one transaction, so the app works in airplane
  mode from the very first launch.
- **Refresh is a background concern.** `CatalogSyncController` refreshes
  when connectivity goes from offline to online, on start-up when online,
  and on pull-to-refresh. A refresh downloads `/v1/products`, `/sections`,
  `/banners` and `/shops` in parallel and writes them in **one transaction**,
  so Home never shows a half-updated catalogue. A failed refresh leaves the
  data as it was.
- **Online means reachable.** `connectivity_plus` only says an interface is
  up, so every change is confirmed with a real request, and the status is
  re-checked every 15 s to notice recovery the plugin doesn't report.
- **Images:** `cached_network_image` keeps downloaded images on disk. Every
  image also has a bundled copy (`assets/images/<same path>`), used as the
  placeholder and as the fallback when the network copy can't load. Images
  that only exist on the server work offline once they've been cached.
- **One member record.** The designs disagree (Home: Bronze, 1,290 to Gold;
  Rewards: Silver, 500). Both screens read the same `members` row: Silver,
  500 tier points to Gold. *Total points* (680,000) is a separate lifetime
  counter and is not used for tier progress.
- **Migrations:** schema v2 adds the `cart_items` table and
  `products.updated_at`; `test/core/database_test.dart` upgrades a real v1
  database and checks nothing is lost.

## Validation rules (Task 1)

Validators are pure functions in `features/auth/domain/validators/`, each
rule unit-tested:

- **Phone:** after +95, strip spaces and dashes, a pasted `+95`, and one
  leading 0; the rest must be `9` followed by 7–9 digits
  (`09254135592 → +959254135592`). Continue stays disabled until valid; the
  message appears once the field loses focus.
- **OTP:** six digits, `123456` passes. A wrong code shakes and clears the
  boxes and says how many tries are left; three wrong codes lock entry until
  Resend. One hidden field drives the six boxes, so typing advances,
  backspace goes back, paste fills all six, the keyboard is numeric and the
  `oneTimeCode` autofill hint is set.
- **Resend:** counts down from 5:00; at 0:00 Resend becomes active and
  restarts the timer (and unlocks entry).
- **Names:** first name required, 1–50 characters after trimming; last name
  optional. Letters and spaces in any script. Burmese vowel signs, tone
  marks and asat are Unicode *marks*, so the rule is `[\p{L}\p{M} ]`; digits
  of any script (including ၀–၉) are rejected.
- **Date of birth:** tapping any of the three fields opens one sheet with
  Month, Day and Year wheels (same on iOS and Android, no typing), a pink
  selection band, haptic ticks and a Done button. The sheet validates as the
  wheels turn. The year wheel runs newest first from `today.year −
  minimumAgeYears` (2013 in 2026) back to 1900, so it moves forward each
  year. The day wheel always offers 1–31, so the rules stay visible: a real
  calendar date (no 31 April, 29 February only in leap years), not in the
  future, age at least `minimumAgeYears` (13). For example, 31 December 2013
  is offered but is still too young today. A failure shows an inline
  message and disables Continue.
- **Every step:** Continue morphs into a loading state during the fake call
  (~1 s); the controller ignores taps while a request runs, so a double tap
  sends one request (tested).

## Animations

All durations and curves live in `lib/design_system/tokens/motion_tokens.dart`.
Reduce Motion (`MediaQuery.disableAnimations`) shortens every duration to
zero, stops repeating animations (shimmer, idle float, Earn pulse) and
turns off carousel auto-play.

| Where | What |
|---|---|
| Onboarding | Donut circles drift in from the edges, then float gently; title, buttons, social row and footer enter staggered |
| Registration | Shared-axis transition between steps; the progress ring grows 25 → 50 → 75 → 100% and morphs into a check; the ring is a Hero, so it stays put while pages slide |
| Inputs | Outline animates to pink on focus and red on error; error messages slide in; OTP boxes shake on a wrong code; digits pop in |
| Buttons | Scale on press; Continue morphs into a round loading state |
| Welcome | Donut tiles slide in from both sides, staggered, then the title fades up |
| Home | Skeleton shimmer while loading; header, carousel and sections enter staggered; banner carousel auto-plays (pauses while dragged) with animated dots; offline bar slides down |
| Tile → detail | Hero flight of the product image; quantity slides up or down as it changes; live total in the CTA |
| Rewards | Points ring sweeps to the member's progress while the total counts up to 680,000; tiers appear in order with the line to the next tier filling; Rewards badge pops in; tab indicator slides and the card list slides/fades; cards enter staggered; donut art colours in by quarters and the coffee arc fills; Earn pulses when a challenge is complete |
| Bottom nav | Pink pill slides between tabs; Rewards replays its entrance each time it opens |

The ring, tier shields, progress art, hills and step ring are drawn with
`CustomPainter`; there is no Lottie or Rive.

## Tests

- **Unit:** every validator rule, auth use cases, fake auth repository,
  database seeding and v1 → v2 migration, Home repository (read, failed
  refresh, successful refresh), member tier maths and the tier ladder,
  router redirect rules.
- **Widget:** phone validation and blur behaviour, unregistered-number
  message, double-tap guard, wrong OTP / lock / resend / countdown, name and
  date-of-birth rules, session relaunch, log out, Rewards reading the same
  member as Home, and layout at 4.7" and 6.9" with text scale 1.3 (overflow
  fails the test).
- **Integration:** Register → Home → Product detail (then Rewards), run on
  the iOS Simulator, offline.
- **Architecture:** import boundaries (see above).

## Assets and licences

- No client screenshots are in the repository.
- Every product, shop, banner and avatar image is generated by
  `tool/art/generate_art.py` (Pillow + NumPy), so there are no third-party
  image licences.
- Social sign-in icons are SVGs in `assets/images/svg/`, drawn with
  `flutter_svg`. Every asset path lives in `lib/core/app_assets.dart`
  (`AppAsset.facebook`, `AppAsset.seed`, ...); a test checks each one
  exists and is declared in pubspec.yaml.
- Font: Urbanist (SIL Open Font Licence, `assets/fonts/OFL.txt`), bundled so
  it renders offline. Burmese text uses the system font.

## Known gaps

- Auth is fake (by design): codes aren't really sent, and the OTP lock lasts
  until the 5:00 countdown ends, as the brief specifies, which can mean a
  wait of almost five minutes after three wrong codes.
- Add to cart persists to the database, but there is no cart screen.
- Order and Wallet tabs are placeholders; Explore now, Order online and the
  bell show a snackbar or do nothing (display only, per the brief).
- The Gift tab has no design; its cards reuse the challenge card with a
  Redeem button.
- `connectivity_plus` is pinned to 7.0.0: 7.1+ needs the iOS 26 SDK (Xcode
  26) to compile, and this was built with Xcode 16.4.
- Fonts and imagery are close stand-ins, not the client's originals.
- The design is light-only; the app pins the light theme (dark tokens exist
  in the design system).

## Time spent

- About 1.5 days
