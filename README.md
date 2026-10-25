# SpriteCraft 🎨

An AI-powered pixel art generator and editor built with Flutter.

## What it does

- Generates pixel art sprites from text descriptions using Google's Gemini AI
- Edit and refine generated pixel art
- Saves generated artwork to your device gallery
- Shares artwork to other apps
- Supports multiple platforms: Android, iOS, macOS, Web (PWA)

## Tech Stack

- **Flutter** — cross-platform UI framework
- **Firebase AI (Gemini)** — AI image generation via Vertex AI
- **Firebase Remote Config** — dynamic configuration
- **Riverpod** — state management
- **Go Router** — navigation
- **flutter_localizations** — i18n support (English, Ukrainian, Polish, Russian)

## Platforms

| Platform | Status |
|----------|--------|
| Android  | ✅ Supported |
| iOS      | ✅ Supported |
| macOS    | ✅ Supported |
| Web (PWA)| ✅ Supported |

## Planned Features

- Pixel art editing tools (palette, brush, eraser, fill)
- AI-assisted sprite editing and inpainting
- Export to multiple formats (PNG, GIF, sprite sheets)
- Multiple resolution options (8×8 up to 128×128)
- Animation support (frame-by-frame)
- Color palette customization

## Setup

1. **Install Flutter SDK** — see `pubspec.yaml` for version requirements
2. **Set up a Firebase project** and add your configuration files:
   - `android/app/google-services.json` — Android
   - `ios/Runner/GoogleService-Info.plist` — iOS
   - `macos/Runner/GoogleService-Info.plist` — macOS
   - Update `lib/firebase_options.dart` with your web & macOS config
3. **Install dependencies:**
   ```bash
   flutter pub get
   ```
4. **Run on your target platform:**
   ```bash
   flutter run                        # default device
   flutter run -d chrome              # web
   flutter run -d macos               # macOS
   ```
5. **Build web (PWA):**
   ```bash
   flutter build web --release
   ```

## Project Structure

```
lib/
├── base/               # Global Riverpod providers
├── core/
│   ├── ai_settings.dart
│   ├── architecture/   # Result type, Value Objects, Entities
│   ├── constants/
│   └── theme/
├── data/
│   └── service/        # AI generation & save/share services
├── domain/
│   ├── entities/
│   └── repository/
├── l10n/               # Localization ARB files (en, uk, pl, ru)
├── presentation/
│   └── home/           # Home screen + state management
├── utils/
├── firebase_options.dart
├── main.dart
└── spritecraft_app.dart
```

## Localization

Supported languages:

| Code | Language   |
|------|------------|
| `en` | English    |
| `uk` | Ukrainian  |
| `pl` | Polish     |
| `ru` | Russian    |

To add a new language, create `lib/l10n/app_<locale>.arb` and run:
```bash
flutter gen-l10n
```
