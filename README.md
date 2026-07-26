# QuoteVerse Frontend (Mobile & Web App)

A production-ready, highly polished cross-platform **Random Quote Generator** client application built with **Flutter**, named **Quote Duniya** (internally structured as **QuoteVerse**). It supports Android and Web platforms out of the box with responsive layouts and Material Design 3 guidelines.

---

## Features

- **Premium UI & Glassmorphic Quotes Card**: Rich purple-blue gradients with BackdropFilter blur overlays and custom gradient border rendering.
- **Micro-Animations**: Springy tap-down scale interactions, animated switcher slide fades on quote load, and seamless theme transition rotates.
- **Offline Cache**: Persistent caching for the last loaded random quote and theme preference using `SharedPreferences`.
- **Favorites Center**: Local bookmarks center matching dismissible swiping actions to easily delete saved quotes.
- **One-Click Sharing**: Copy text to Clipboard or launch system shares (using native shares on Mobile and Web APIs on Web).
- **Responsive Layout**: Adapts gracefully from compact mobile displays to wide desktop monitors, wrapping sections cleanly.
- **Pull to Refresh**: Drag down to fetch a new random quote from the database.

---

## Folder Structure

Following Clean Architecture structure (Separated Models, Controllers/Providers, Services, Views/Screens, and Utility styling):

```text
quoteverse-frontend/
├── lib/
│   ├── models/
│   │   └── quote_model.dart     # JSON model serializer
│   ├── providers/
│   │   ├── quote_provider.dart  # Core quote state
│   │   └── theme_provider.dart  # App dark/light toggler
│   ├── screens/
│   │   └── home_screen.dart     # App main dashboard view
│   ├── services/
│   │   ├── api_service.dart     # Server HTTP integration
│   │   └── cache_service.dart   # Local preferences manager
│   ├── theme/
│   │   └── app_theme.dart       # Material 3 light/dark presets
│   ├── widgets/
│   │   ├── action_button.dart   # Scale animated click buttons
│   │   ├── error_view.dart      # Connection failure screens
│   │   ├── glass_container.dart # Glassmorphism painters
│   │   └── quote_card.dart      # Translucent visual text layout
│   ├── utils/
│   │   └── constants.dart       # Keys & configuration urls
│   └── main.dart                # App bootstrap / providers init
└── pubspec.yaml                 # Packages declaration
```

---

## Requirements

- **Flutter SDK** (v3.20.0 or higher)
- **Dart SDK** (v3.0.0 or higher)

---

## Installation & Setup

1. **Navigate to the frontend folder**:
   ```bash
   cd quoteverse-frontend
   ```

2. **Retrieve dependencies**:
   ```bash
   flutter pub get
   ```

---

## Running the Application

### 1. Web Platform
Run a local development server for the browser:
```bash
flutter run -d chrome
```

### 2. Android Emulator/Device
Ensure an Android Emulator or device is active, then run:
```bash
flutter run
```

*Note: The app is pre-configured to point to the correct REST API automatically (`http://10.0.2.2:5000` for Android Emulator, and `http://localhost:5000` for Web).*

---

## Build Commands

### 1. Build Android APK
Compile a release build of the Android application:
```bash
flutter build apk --release
```
The generated APK will be available under:
`build/app/outputs/flutter-apk/app-release.apk`

### 2. Build Web Bundle
Compile a highly optimized release build for web hosting:
```bash
flutter build web --release
```
The static website bundle will be available under the `build/web/` directory, ready to deploy to GitHub Pages, Vercel, Firebase Hosting, or Netlify.

---

## Future Scope

- **Custom Seeding / Admin Additions**: Form in the app to directly post new quotes to the Express server.
- **Offline Sync**: Auto-sync local modifications back to the remote server once network connectivity resolves.
- **Auth Guard**: Implement Firebase/Auth0 integrations for multi-device sync of favorite lists.
