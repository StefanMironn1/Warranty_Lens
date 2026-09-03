# WarrantyLens

WarrantyLens is a polished, local-first Flutter application for organizing receipts, tracking warranty coverage, receiving expiry alerts, and preparing warranty claims.

It is designed as a complete portfolio project: every primary action is connected, useful demo data is available on first launch, and no account, API key, or backend setup is required.

## Highlights

- Responsive mobile and tablet interface with a custom dark glass design
- Local profile setup and persistent on-device data
- Dynamic dashboard with active, expiring, and expired warranty counts
- Search, filter, sort, and favorite warranty records
- Add and edit flows with validation, date selection, coverage duration, and reminders
- Interactive receipt scanning and OCR simulation for a self-contained demo
- Detailed warranty view with receipt metadata and a claim preparation checklist
- Expiry alert center generated from real coverage dates
- Insights dashboard with coverage distribution, protected value, category analysis, and vault quality
- JSON data export, currency preference, notification preference, and demo reset
- Sample data whose expiry states stay meaningful relative to the current date

## Screens

1. Welcome and local profile setup
2. Home dashboard
3. Warranty library
4. Add/edit warranty
5. Receipt scan simulation
6. Warranty details and claim checklist
7. Expiry alerts
8. Protection insights
9. Profile, settings, and data export

## Architecture

```text
lib/
├── app_screens/        # Complete feature screens and navigation shell
├── core/               # Theme, colors, and formatting helpers
├── models/             # Serializable warranty domain model
├── state/              # ChangeNotifier store and persistence orchestration
├── widgets/            # Shared cards, status UI, and product visuals
└── main.dart            # App bootstrap and dependency wiring
```

The project intentionally uses Flutter SDK state management (`ChangeNotifier`) to keep the architecture understandable in a portfolio review. `SharedPreferences` persists warranty records, profile details, and settings as JSON. The UI reads computed expiry status directly from the domain model, which keeps filtering, alerts, details, and insights consistent.

## Run locally

Requirements:

- Flutter 3.38 or newer
- Dart 3.12.2 or newer
- Android Studio, Xcode, or a supported desktop/web toolchain

```bash
flutter pub get
flutter run
```

Quality checks:

```bash
flutter analyze
flutter test
```

## Demo notes

The receipt scanner is an intentional offline OCR simulation. It demonstrates the complete interaction and smart-fill flow without camera permissions, paid OCR services, or secret API keys. A production version can replace `ScanReceiptScreen` with ML Kit, VisionKit, or a cloud OCR adapter without changing the warranty form or data model.

Receipt attachments are represented by portable metadata in this public build. This avoids committing personal documents while preserving the full add, display, and export flow.

## Technology

- Flutter and Dart
- Material 3
- SharedPreferences
- Google Fonts
- CustomPainter for analytics visualization
- JSON serialization

## Roadmap for a production release

- Real camera/gallery receipt import and OCR adapter
- Encrypted document storage and optional cloud synchronization
- Native scheduled notifications
- Authentication and multi-device backup
- Localized English, Greek, and Romanian strings

## Author

Built by **Stefan Miron** as a Flutter portfolio project.

## License

This project is available under the MIT License.
