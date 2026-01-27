# Boil Eggs App

A beautiful and simple Flutter application to help you boil eggs perfectly.

## Features
- **Customizable Doneness**: Choose between Soft, Medium, and Hard boiled eggs.
- **Timer & Animations**: Visual timer with smooth animations.
- **Language Support**: English and Spanish support.
- **Local Notifications**: Get notified when your egg is ready.

## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- iOS Simulator or Android Emulator.

### Installation
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd BoilEggs
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Development
- **Code Generation**: If you change `.arb` files, run `flutter gen-l10n` to update translations.
- **Icon Generation**: To update app icons, configure `flutter_launcher_icons.yaml` (if added) and run generation command.

Enjoy your perfect eggs!

---

# 🚀 Publishing Guide

Follow these steps to prepare your app for the Google Play Store and Apple App Store.

## 1. Pre-Publishing Checklist
Before building your release version, ensure you have configured the following:

- **App Icon**: Replace the default Flutter icon.
  - Recommended: Use [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons).
  - Add to `pubspec.yaml`, add your icon file, and run: `dart run flutter_launcher_icons`.
- **Package Name / Bundle ID**:
  - **Android**: Change `com.example.boil_eggs` to your unique domain (e.g., `com.yourname.boileggs`) in `android/app/build.gradle` and everywhere in `android/app/src/main/AndroidManifest.xml` and Kotlin/Java files.
  - **iOS**: Update `Bundle Identifier` in Xcode under `Runner` target -> `General` tab.
- **AdMob ID**:
  - Replace the **Test App ID** in `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist` with your **Production App ID** from AdMob.
  - Create actual Ad Units in AdMob Console and update `ad_service.dart`.
- **Versioning**:
  - Update `version: 1.0.0+1` in `pubspec.yaml` (Format: `x.y.z+buildNumber`).

## 2. Android (Google Play Store)

### 2.1 Signing the App
1.  **Create a Keystore**:
    ```bash
    keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
    ```
2.  **Configure Gradle**:
    - Move `upload-keystore.jks` to `android/app/`.
    - Create `android/key.properties`:
      ```properties
      storePassword=<password>
      keyPassword=<password>
      keyAlias=upload
      storeFile=upload-keystore.jks
      ```
    - Update `android/app/build.gradle` to use this config in `buildTypes { release { ... } }`.

### 2.2 Build Release Bundle
Run the following command to generate the App Bundle (`.aab`) required by Google Play:
```bash
flutter build appbundle
```
File location: `build/app/outputs/bundle/release/app-release.aab`.

### 2.3 Publish
1.  Create an account on [Google Play Console](https://play.google.com/console).
2.  Create a new app.
3.  Upload the `.aab` file to the **Production** (or **Testing**) track.
4.  Complete the store listing (Policies, Data Safety, Screenshots).

## 3. iOS (App Store)

### 3.1 Initial Setup
1.  **Enroll**: You need an [Apple Developer Account](https://developer.apple.com/).
2.  **Register App ID**: Create an Identifier in the Apple Developer Portal matching your Bundle ID.

### 3.2 Xcode Configuration
1.  Open `ios/Runner.xcworkspace`.
2.  Select `Runner` target.
3.  **Signing & Capabilities**: Select your Team. Ensure no errors.
4.  **Widget Extenstion**: Ensure `BoilEggsWidget` is also signed correctly.

### 3.3 Build & Archive
1.  Run build command:
    ```bash
    flutter build ipa
    ```
    This creates an Xcode archive.
2.  **Upload**: Open the generated `build/ios/archive/Runner.xcarchive` (or execute `open build/ios/archive/Runner.xcarchive`).
3.  Click **Distribute App** -> **App Store Connect** -> **Upload**.

### 3.4 Publish
1.  Go to [App Store Connect](https://appstoreconnect.apple.com/).
2.  Create a new App.
3.  Select the build you uploaded.
4.  Fill in metadata, upload screenshots, and submit for review.
