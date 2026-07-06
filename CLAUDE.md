# SoftWork HR (RRHH) Client — System Handbook (CLAUDE.md)

Authoritative guide for working in this repository. Read this before making changes.
All code, comments, identifiers, and documentation in this project are **English only**.

---

## 1. Project Overview

SoftWork HR (RRHH) Client is an enterprise Flutter application (iOS + Android only) for **Human
Resources personnel** — managing employees, teams, dashboards, and organizational resources. It is
**not** the Employee-facing client; its users are RRHH profiles. It talks to the **ELYSIUM** Spring
Boot backend (see `docs/backend/ELYSIUM-API_DOCUMENTATION.md` — the single source of truth for the API).

- **Flutter/Dart SDK**: Dart `^3.12.2` (Flutter 3.44+).
- **Design language**: SoftWork spec, `Exo` type family (bundled asset font, no `google_fonts`).
- **Flavors**: none. The former mock flavor has been permanently removed — the app is wired
  exclusively to live infrastructure.

---

## 2. Architecture

**Custom Hexagonal Architecture + BLoC + GetIt**, organized **package-by-feature (bounded context)**.

Layer rules (strict):

- `domain/` — pure Dart. **No** annotations, serialization, Flutter, or infrastructure imports.
  Entities implement value equality by hand (no `equatable` in domain).
- `data/` — adapters + DTO-equivalents. Owns serialization, network, database, and provider SDKs.
  Maps to/from domain only via explicit `.toDomain()` / `.toCompanion()` methods.
- `application/` — BLoCs. Translate UI intent into port calls; never navigate.
- `presentation/` — views/components/navigation. React to BLoC state; no business logic.

Dependency direction always points inward toward `domain/`. BLoCs depend on **ports**
(`AuthenticationStore`), never on concrete adapters.

### Bounded contexts

- `lib/iam/` — Identity & Access Management (auth, session, profile).
- `lib/shared/` — cross-cutting foundation (network client, local DB, design system, i18n,
  reusable widgets, the authenticated bottom-nav shell, and the dashboard). Also hosts screens
  that have no dedicated context yet (Menu/Alerts/Reports).

---

## 3. Directory Map

```
lib/
├── main.dart                     # Bootstrap: Firebase → ServiceLocator → runApp
├── app_router.dart               # Dual-router (GoRouter) + reactive redirect guards
├── service_locator.dart          # Production composition root (GetIt)
├── firebase_options.dart         # Generated FlutterFire options (if present)
├── shared/
│   ├── domain/models/            # Reusable domain (Id value object)
│   ├── data/
│   │   ├── local/                # app_database.dart (Drift + native sqlite3) + .g.dart
│   │   ├── network/              # api_client.dart, environment_config.dart
│   │   └── pref/                 # shared_preferences_adapter.dart (general KV cache)
│   ├── shared_dependencies.dart  # Registers AppDatabase-backed ApiClient + prefs
│   └── presentation/
│       ├── design/               # app_colors, app_typography, app_dimensions, app_theme
│       ├── i18n/                 # app_strings.dart (intl; ALL user-facing text)
│       ├── utils/                # corporate_email.dart
│       ├── components/           # gradient_button, app_text_field, user_avatar, ...
│       └── views/                # home_shell_view, main_menu_view, alerts_view, reports_view
└── iam/
    ├── domain/
    │   ├── models/               # user.dart, auth_session.dart (pure only)
    │   └── stores/               # authentication_store.dart (PORT)
    ├── data/
    │   ├── models/               # *Response (@JsonSerializable) + db_mapping_extensions
    │   ├── network/              # iam_web_service.dart + requests/ (*Request)
    │   └── stores/               # firebase_authentication_store.dart (ADAPTER)
    ├── application/bloc/         # login, registration, session BLoCs
    ├── iam_dependencies.dart     # Registers IamWebService + BLoCs
    └── presentation/             # navigation/, views/, components/
```

---

## 4. State Management & Dependency Injection

- **GetIt** is the service locator. Entry point: `ServiceLocator.init()` (awaited in `main`).
  - `AppDatabase`, `ApiClient`, `IamWebService`, `AuthenticationStore`, `SessionBloc` → lazy singletons.
  - `LoginBloc`, `RegistrationBloc` → **factories** (fresh per `BlocProvider` boundary; the locator
    never holds volatile UI state).
- **SessionBloc** is the long-lived, app-wide source of truth for auth status. It subscribes to
  `AuthenticationStore.sessionChanges()` and is provided above `MaterialApp.router` via
  `BlocProvider.value`.
- Views obtain feature BLoCs with `GetIt.instance<T>()` inside a `BlocProvider(create: ...)`.

---

## 5. Navigation (Dual Router)

`app_router.dart` builds a single `GoRouter` with a reactive `redirect` driven by `SessionBloc`
(bridged to `refreshListenable` via `GoRouterRefreshStream`):

- **Unauthenticated shell**: `/iam/login`, `/iam/register` (+ neutral success interstitials).
- **Authenticated shell**: `StatefulShellRoute.indexedStack` with a persistent bottom navigation bar —
  **Menu** (`/menu`), **Profile** (`/profile`), **Alerts** (`/alerts`), **Reports** (`/reports`) —
  plus the full-screen `/profile/edit`.
- Guard: unauthenticated users are redirected to login; authenticated users are bounced out of the
  auth-flow screens to `/menu`.

---

## 6. Data Layer Conventions

- **Naming (mandatory)**: inbound API payloads are suffixed `*Response`; outbound payloads `*Request`;
  Drift database rows `*Row` (e.g. `CachedSessionRow`). The legacy `*Dto` nomenclature is banned.
- **Serialization**: `@JsonSerializable` with generated parts. Responses use `createFactory: true`
  (inbound), requests use `createFactory: false` (outbound-only `toJson`).
- **snake_case everywhere**: the ELYSIUM backend serializes **all** request and response JSON keys as
  `snake_case` (class-level `@JsonNaming(SnakeCaseStrategy)`). All `@JsonKey(name: ...)` mappings must
  be snake_case. Watch the documented residual quirks (`rrhhdepartment`, `star_start`) — no underscore
  between consecutive capitals.
- **Domain mapping**: only in `data/` via `.toDomain()` (Response → entity) and `.toCompanion()`
  (entity → `CachedSessionsCompanion`). Domain never imports a transport/DB type.

### Local database (Drift + native sqlite3)

- `lib/shared/data/local/app_database.dart`. Uses **pure `sqlite3` v3** through
  `NativeDatabase.createInBackground` (writes run off the UI isolate). **Never** import
  `sqlite3_flutter_libs` (obsolete) and **never** import a Flutter package into this file — Flutter's
  `Table` widget collides with Drift's `Table`. If a presentation import is ever unavoidable, add
  `hide Table`.
- `CachedSessions` table stores the active session (`accessToken`, `userId`). `AppDatabase` exposes
  `cacheSession`, `clearCachedSessions`, `readAccessToken`.
- The `ApiClient` bearer-token provider reads `AppDatabase.readAccessToken()`, so the session survives
  cold starts and authorizes every outbound request.

---

## 7. Backend Connection (ELYSIUM)

> Full contract: `docs/backend/ELYSIUM-API_DOCUMENTATION.md`. Summary below.

| Item | Value |
|---|---|
| Base URL (dev) | `http://localhost:8092` |
| Base URL (prod) | host on `${PORT:8080}` (configure via `API_BASE_URL`) |
| API prefix | `/api/v1` |
| Auth scheme | `Authorization: Bearer <JWT>` (all endpoints except the public auth ones) |
| Content-Type | `application/json` (JSON keys are snake_case) |

### Authentication endpoints (public)

- `POST /api/v1/authentication/sign-in` → body `{ "email", "password" }` → `{ "id", "email", "token" }`
- **`POST /api/v1/authentication/sign-up/rrhh`** → **the sign-up endpoint for THIS app** →
  `{ "id", "email", "token" }`. Request (`RRHHProfileSignUpRequest`):
  `{ name, last_name, phone_number, dni, email, password, anonymous_name, rrhhdepartment, status_hierarchy }`.
  Note `rrhhdepartment` has **no** underscore (consecutive capitals in the Java field `RRHHDepartment`).
- `POST /api/v1/authentication/sign-up/employee` → Employee sign-up — belongs to the *Employee* app,
  **not** used here.

The returned `token` is the JWT used as the bearer credential for every subsequent request.

### Error envelopes (snake_case)

| Status | Shape |
|---|---|
| 400 | `{ status, error, message, field_errors: { <snake_case_field>: <msg> } }` |
| 404 | `{ status, error, message }` |
| 500 | `{ status, error, message }` |
| 503 | `{ status, error, message }` (DB down) |

`ApiClient` normalizes non-2xx into a single `ApiException(statusCode, uri, message)`.

### Seed test credentials (dev profile)

All use password `password123`, e.g. `carlos.mendoza@techcorp.pe`, `maria.lopez@techcorp.pe`
(full list in the API doc §12).

### ⚠️ Known architectural gap (do not "fix" silently — confirm first)

The current `IamWebService`/`FirebaseAuthenticationStore` implement a **Firebase ID-token bridge**
(`SignInRequest{ id_token }` → `/iam/sessions`). The ELYSIUM backend does **not** expose those
endpoints; it authenticates with **email/password → JWT** at `/api/v1/authentication/sign-in`
(no Firebase). Reconciling the client to ELYSIUM's real flow (email/password credentials, JWT storage,
dropping or repurposing the Firebase layer) is a deliberate follow-up, not yet done.

Because this is the **HR (RRHH)** app, that reconciliation must target the **RRHH** contracts:
registration maps to `RRHHProfileSignUpRequest` at `/api/v1/authentication/sign-up/rrhh` (with the
RRHH fields above), not the employee sign-up. The registration form/BLoC and `RegisterRequest`
currently carry only `username`/`email` and will need the RRHH fields when this work is picked up.

---

## 8. Environment Configuration

All build-time config lives in `lib/shared/data/network/environment_config.dart`
(`String/bool/int.fromEnvironment`). Pass via `--dart-define`:

| Key | Default | Purpose |
|---|---|---|
| `API_BASE_URL` | `http://localhost:8092` | Backend host |
| `API_PREFIX` | `/api/v1` | Endpoint prefix |
| `API_TIMEOUT_SECONDS` | `20` | HTTP timeout |
| `API_LOGGING` | `false` | Request/response diagnostic logging |
| `GOOGLE_SERVER_CLIENT_ID` | `""` | Google OAuth server client id |
| `FIREBASE_API_KEY` / `FIREBASE_APP_ID` / `FIREBASE_MESSAGING_SENDER_ID` / `FIREBASE_PROJECT_ID` / `FIREBASE_STORAGE_BUCKET` | `""` | Firebase overrides |

`Firebase.initializeApp` uses explicit `FirebaseOptions` only when `hasFirebaseConfiguration` is true
(all core Firebase keys present); otherwise it falls back to native `google-services.json` /
`GoogleService-Info.plist`. Initialization is non-fatal — the app boots to the login screen even if
Firebase is unavailable.

---

## 9. Typography (Exo)

- `Exo` is a **bundled asset font** (`assets/fonts/exo-*.ttf`, declared under `flutter: assets:`).
  Flutter supports only `.ttf`/`.otf`/`.ttc` — never `.woff2`.
- Registered purely in Dart via `AppTheme.ensureFontsLoaded()` (a `FontLoader`), called in `main`
  before `runApp`. `AppTheme.light()` applies `Exo` across the whole `TextTheme`, with an on-device
  fallback chain (`Roboto`, `Arial`) — no runtime font network request.

---

## 10. Code Generation

Generators: `drift_dev` (database) and `json_serializable` (models/requests), scoped by
`build.yaml`. Generated `*.g.dart` parts are committed.

```bash
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

- The database part (`app_database.g.dart`) requires `drift_dev` as a dev-dependency and a plain
  list literal in `@DriftDatabase(tables: [CachedSessions])` (no explicit `<Type>` generic, or the
  generator silently skips the file).
- After changing any annotated class, table, `@DataClassName`, or `@JsonKey`, re-run generation.

---

## 11. Common Commands

```bash
flutter pub get
flutter analyze                 # must be clean (0 errors) before shipping
flutter run                     # production wiring; needs backend + Firebase config
flutter run --dart-define=API_BASE_URL=https://<host> --dart-define=API_LOGGING=true
dart run build_runner build     # regenerate parts
```

---

## 12. Conventions Checklist (enforce on every change)

- English only — identifiers, labels, comments, dartdoc.
- Triple-slash `///` dartdoc on every public class, constructor, field, and method.
- All user-facing strings go through `AppStrings` (i18n) — no hard-coded UI text.
- Design tokens only (`AppColors`, `AppTypography`, `AppSpacing`, `AppRadii`, `AppSizes`,
  `AppGradients`) — no magic colors/sizes.
- Keep `domain/` pure; keep serialization/DB in `data/`; keep UI logic out of BLoCs.
- Run `flutter analyze` and, if generated code was touched, `build_runner`, before considering a task done.
```

---

## 13. Architectural Optimization and Scaling Conventions

> Titled "Architectural Optimization and Scaling Conventions" per the performance
> engineering cycle. Numbered `13` because section `7` (Backend Connection) is
> already the canonical ELYSIUM contract — the section number was advanced rather
> than duplicated to keep the handbook's structure unambiguous.

This section codifies the performance baseline established during the frame-stability
and memory-pressure hardening pass. These are **enforced constraints**, not
suggestions — new code must not regress below them.

### 13.1 Selective rebuild boundaries (state emission)

- **Prefer `BlocSelector` over `BlocBuilder`** whenever a view consumes only a
  narrow projection of a bloc's state. Select the smallest value the subtree
  actually renders (e.g. `state.user`, `state.user?.username`), never the whole
  state object. The selector's `==` result gates the rebuild, so value-equal
  re-emissions are dropped before the builder runs.
  - Reference: `main_menu_view.dart` selects `username`; `profile_view.dart`
    selects the value-equal `User?` entity.
- **Add `buildWhen` to every `BlocBuilder`/`BlocConsumer` whose state carries
  fields the builder does not consume.** Gate rebuilds on the *structural* fields
  only. Transient acknowledgement fields (timestamps, one-shot flags such as
  `reportRequestedAt`) must be routed through `listenWhen`/`listener`, never
  through the builder.
  - Reference: `hr_reports_view.dart` — the "Generate report" tick is a
    listener-only event; `buildWhen` compares `status`/`teams`/`selectedTeam`/
    `metrics`.
- **State objects remain `Equatable`** (or hand-written value equality in
  `domain/`) so both the bloc's internal dedupe and the selector comparisons are
  cheap and correct. Never put a non-value-equal field in `props`.

### 13.2 Repaint isolation and immutable subtrees

- **Hoist state-independent subtrees to `const`.** Any widget whose inputs are
  compile-time constants (e.g. a card fed a `static const` list) must be
  constructed `const` so it is excluded from ancestor rebuilds.
  - Reference: `const _AssignedTeamsCard(teams: _sampleTeams)`.
- **Wrap every `CustomPaint`/`CustomPainter` in a `RepaintBoundary`** so ambient
  repaints (animation ticks, fades, scrolls) do not force re-rasterization of the
  painted layer. Set `isComplex: true` and `willChange: false` on static charts to
  mark the layer cacheable; only set `willChange: true` for painters that animate
  every frame.
  - Reference: `_HistoricalProgressChart` in `hr_reports_view.dart`.
- **`CustomPainter.shouldRepaint` must compare inputs by identity/value**, never
  return `true` unconditionally.

### 13.3 Stream and resource lifecycle hardening (baseline — do not regress)

The following disposal discipline is already established and is **mandatory** for
every new bloc, adapter, and stateful view:

- Every `StreamSubscription` created in a bloc/adapter is stored in a
  `late final` field and cancelled in `close()`/`dispose()`.
  (`session_bloc.dart`, `membership_gate_bloc.dart`, `GoRouterRefreshStream`.)
- Every `StreamController` is `.close()`d in the owner's `dispose()`, and writes
  are guarded with an `isClosed` check. (`firebase_authentication_store.dart`.)
- Every `TextEditingController`/`AnimationController` lives in a `StatefulWidget`,
  is created in `initState`, and is `dispose()`d in `dispose()`.
  (`add_card_view.dart`.)
- The `ApiClient` closes its owned `http.Client` in `dispose()`, and only when it
  created it (`_ownsClient`).
- Drift writes run off the UI isolate via `NativeDatabase.createInBackground`;
  cache-replacement operations are wrapped in a single `transaction`/`batch` so a
  refresh never leaves partially-stale rows.

### 13.4 Data-collection and mapping efficiency

- **Domain/DB mappers stay single-pass.** `.toDomain()` / `.toCompanion()`
  extensions map one row/response to one entity with no nested loops and no
  intermediate list cloning. Repository loaders use one `.map(...).toList()` per
  transformation stage.
- **Hot paths (painters, per-frame builds) must not allocate throwaway
  iterables.** Compute extrema/aggregates with a single explicit `for` loop rather
  than chained lazy `map().reduce()` pipelines.
  - Reference: `_LineChartPainter.paint` computes `min`/`max` in one scan.
- **Never re-derive an aggregate inside `itemBuilder`.** Compute list-wide values
  (e.g. `maxPrice`) once in the builder body, above the `ListView`, and close over
  the result.

### 13.5 Verification gate

Before considering any optimization complete:

1. `flutter analyze` — **zero** issues.
2. `dart run build_runner build` — clean, when any annotated class/table changed.
3. No behavioral regression: selective-rebuild and repaint changes must be
   output-equivalent; only the rebuild/repaint *frequency* may change.

### 13.6 Internationalization (i18n) reactive state

Runtime language switching is a first-class, reactive feature. It is **on** by
default: the app ships English + Spanish and defaults to Spanish
(`AppLanguage.fallback`, matching the `S/.` currency and the approved mockups).

**Architecture (one directional flow, layer-pure):**

```
Profile toggle ──add(LocaleSelected)──▶ LocaleBloc ──emit(LocaleState)──▶ BlocSelector
      (presentation)                    (application, depends only          (main.dart)
                                          on LocaleStore port)                    │
                            LocaleStore ◀── persist ──┘                           ▼
                         (domain port; PreferencesLocaleStore adapter)   set AppLocale.current
                                                                          + MaterialApp.locale
                                                                                  │
                                                                                  ▼
                                                                    Localizations subtree rebuilds
                                                                    → AppStrings.* re-resolve
```

**Enforced rules for any new localized surface:**

- **All user-facing copy goes through `AppStrings`, and every getter resolves via
  `AppLocale.t(en: ..., es: ...)`** — never `Intl.message`, never a hard-coded
  literal, never a raw ternary on the language. Adding a language extends
  `AppLanguage` and the `switch` in `AppLocale.t`, which then fails to compile
  until every string is translated (totality is the safety net).
- **`AppLocale.current` is written from exactly one place:** the `MaterialApp`
  `BlocSelector<LocaleBloc, LocaleState, AppLanguage>` builder in `main.dart`,
  immediately before the `Localizations` subtree rebuilds. Never mutate it from a
  view, a bloc, or a mapper. The `LocaleBloc` stays presentation-agnostic (it
  depends only on the `LocaleStore` domain port), so the language-application
  side effect lives entirely in the presentation boundary.
- **The language switch is the *only* trigger that rebuilds `MaterialApp`.** It is
  gated by a `BlocSelector` on `LocaleState.language`; do not widen it to rebuild
  on unrelated global state. Re-selecting the active language is a no-op in the
  bloc, so no redundant locale rebuild is emitted.
- **`MaterialApp` must keep the `flutter_localizations` delegates**
  (`GlobalMaterialLocalizations`, `GlobalWidgetsLocalizations`,
  `GlobalCupertinoLocalizations`) and `supportedLocales: [es, en]` so Material
  widgets (pickers, tooltips, date formatting) localize alongside `AppStrings`.
- **Persistence is a port.** The selected language is stored via the `LocaleStore`
  port (`PreferencesLocaleStore` over `SharedPreferencesAdapter`) and hydrated
  once at bootstrap by dispatching `LocaleInitialized` before `runApp`, so the app
  opens in the persisted language with no flash of the default.
- **Locale changes never touch the network or database layers.** Switching
  language only re-resolves text and rebuilds the widget tree; it must never
  re-instantiate the `ApiClient`, reopen the Drift connection, or re-subscribe an
  existing stream. The long-lived `LocaleBloc` is a GetIt singleton and holds no
  disposable resources of its own.
