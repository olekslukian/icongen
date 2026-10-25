# AGENTS.md — SpriteCraft

This file provides guidance for AI coding agents (Copilot, Antigravity, Cursor, etc.) working on this codebase.

## Project Overview

**SpriteCraft** is a Flutter application for AI-powered pixel art generation and editing.
It uses Google's Gemini model (via Firebase AI / Vertex AI) to generate pixel art sprites from text prompts.

- **Package name:** `spritecraft` (folder stays `icongen/`)
- **Firebase project:** `icongen-c5e50` (not renamed)
- **Platforms:** Android, iOS, macOS, Web (PWA)

---

## Architecture

The project follows a layered architecture:

```
Presentation → Domain → Data
```

| Layer        | Location                      | Responsibility                        |
|--------------|-------------------------------|---------------------------------------|
| Presentation | `lib/presentation/`           | Widgets, screens, state (Riverpod)    |
| Domain       | `lib/domain/`                 | Entities, repository interfaces       |
| Data         | `lib/data/`                   | Service implementations               |
| Core         | `lib/core/`                   | Shared utilities, theme, architecture |
| Base         | `lib/base/`                   | Global Riverpod providers             |

### Key Patterns

- **State management:** Riverpod (`flutter_riverpod`). Use `StateNotifier` + `StateNotifierProvider` for complex state, `Provider` for simple dependencies.
- **Repository pattern:** Interfaces live in `lib/domain/repository/i_*.dart`, implementations in `lib/domain/repository/*.dart` (backed by services in `lib/data/service/`).
- **Result type:** All service/repository methods return `Result<T>` (see `lib/core/architecture/data/result.dart`) — never throw.
- **Value objects:** Use value objects for validated domain data (see `lib/core/architecture/domain/`).
- **Routing:** `go_router` — define routes centrally.
- **Logging:** Use `SpriteCraftLogger` (in `lib/utils/spritecraft_logger.dart`), never `print()`.

---

## Naming Conventions

| Thing                   | Convention                        | Example                          |
|-------------------------|-----------------------------------|----------------------------------|
| Dart files              | `snake_case`                      | `spritecraft_app.dart`           |
| Classes                 | `PascalCase`                      | `SpriteCraftApp`                 |
| Riverpod providers      | `camelCaseProvider`               | `aiModelProvider`                |
| ARB locale files        | `app_<locale>.arb`                | `app_pl.arb`                     |
| Screen widgets          | `<Name>Screen`                    | `HomeScreen`                     |
| State classes           | `<Name>State`                     | `ImageGenerationState`           |
| Controllers             | `<Name>Controller`                | `ImageGenerationController`      |

---

## Platform Notes

### Web
- Some plugins are **not available on web**: `gal`, `permission_handler`, `image_background_remover`.
- Use `kIsWeb` guards before calling platform-specific APIs.
- The app is a **PWA** — see `web/manifest.json` and `web/index.html`.

### macOS
- Firebase macOS config (`GoogleService-Info.plist`) must be added to `macos/Runner/`.
- macOS requires network entitlements in `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements` for Firebase / HTTP calls.

### iOS / Android
- Camera/storage permissions are handled via `permission_handler`.
- Gallery saving uses `gal`.

---

## Localization

- ARB files live in `lib/l10n/`.
- Generated Dart files are in `lib/l10n/generated/` — **do not edit manually**.
- Supported locales: `en`, `uk`, `pl`, `ru`.
- After editing any `.arb` file, regenerate with:
  ```bash
  flutter gen-l10n
  ```
- Access strings via `context.l10n` (see `lib/utils/context_extensions.dart`).

---

## Common Commands

```bash
# Run on a specific platform
flutter run -d <device>

# Run all tests
flutter test

# Analyze code
flutter analyze

# Regenerate localizations
flutter gen-l10n

# Get/upgrade packages
flutter pub get
flutter pub upgrade

# Build for web (PWA)
flutter build web --release

# Build for macOS
flutter build macos --release
```

---

## Do / Don't

**Do:**
- Keep platform-specific code behind conditional imports or `kIsWeb` / `Platform` checks.
- Return `Result<T>` from all service and repository methods.
- Use `SpriteCraftLogger` for all logging.
- Write l10n strings for every user-visible string; never hardcode English text in widgets.
- Run `flutter analyze` before committing.

**Don't:**
- Don't use `print()` — use `SpriteCraftLogger`.
- Don't edit files in `lib/l10n/generated/` — they are auto-generated.
- Don't change the Firebase project name or the folder name `icongen/`.
- Don't add platform-unavailable plugins without adding a conditional implementation.
