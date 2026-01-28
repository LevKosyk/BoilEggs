# Publishing Guide

## 1. App Identity
Your app package has been updated to:
- **Android**: `com.levkosyk.boileggs`
- **iOS**: `com.levkosyk.boileggs`

## 2. AdMob Configuration (CRITICAL)

### **Android**
1. Open `android/app/src/main/AndroidManifest.xml`.
2. Find the `<meta-data>` tag for `com.google.android.gms.ads.APPLICATION_ID`.
3. **Replace** the value `ca-app-pub-3940256099942544~3347511713` with your **Production AdMob App ID**.

### **iOS**
1. Open `ios/Runner/Info.plist`.
2. Find the key `GADApplicationIdentifier`.
3. **Replace** the value `ca-app-pub-3940256099942544~1458002511` with your **Production AdMob App ID**.

### **Dart Code**
1. Open `lib/env/env.dart`.
2. Replace the test IDs with your **Production Ad Unit IDs**:
   ```dart
   static const String androidBannerAdUnitId = 'YOUR_ANDROID_AD_UNIT_ID';
   static const String iosBannerAdUnitId = 'YOUR_IOS_AD_UNIT_ID';
   ```

## 3. Optimization
- Debug prints have been removed.
- Unused code should be cleaned up.

## 4. Building for Stores

### **Android**
To generate an app bundle for the Play Store:
```bash
flutter build appbundle --release
```
*Note: You need to configure signing keys in `android/app/build.gradle`. See [Flutter Android Deployment](https://flutter.dev/docs/deployment/android).*

### **iOS**
To generate an archive for the App Store (requires a Mac with Xcode):
```bash
flutter build ipa --release
```
*Note: Open `ios/Runner.xcworkspace` in Xcode to configure signing and upload to App Store Connect.*
