# AI Icon Generator

A Flutter app that generates minimalistic, monochrome icons using Google's Gemini AI model.

## What it does

- Generates simple, flat icons from text descriptions
- Creates icons in solid black on transparent backgrounds
- Saves generated icons to your device gallery
- Shares icons to other apps

## Tech Stack

- Flutter
- Firebase AI (Gemini model)
- Background removal for transparent icons

## Planned Features

- Logo generation
- Multiple icon styles (outlined, filled, rounded)
- Color customization
- Different aspect ratios and sizes

## Setup

1.  Install Flutter SDK (check `pubspec.yaml` for version requirements)
2.  Set up Firebase project and add configuration files:
    - `google-services.json` (Android)
    - `GoogleService-Info.plist` (iOS)
3.  Run:
    ```bash
    flutter pub
