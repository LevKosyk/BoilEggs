# 🥚 Boil Eggs

**Boil Eggs** is a beautiful and intuitive Flutter application designed to help you cook the perfect egg every time. Whether you prefer soft, medium, or hard-boiled eggs, this app calculates the precise boiling time based on your specific preferences.

## ✨ Features

-   📏 **Customizable Settings**: Choose your egg size (Small, Medium, Large, Extra Large) and starting temperature (Fridge or Room Temperature) for accurate timing.
-   🍳 **Doneness Selection**: Select your desired doneness - Soft, Medium, or Hard - with clear visual indicators.
-   ⏱️ **Precise Timer**: A built-in timer that alerts you exactly when your eggs are ready.
-   🎨 **Beautiful UI**: A modern, clean interface with smooth animations and delightful illustrations.
-   🌍 **Localized**: Supports multiple languages (English, German, Spanish, Polish, Portuguese, Ukrainian).

## 📸 Screenshots

| Size & Temp Selection | Doneness Selection | Timer |
|:---:|:---:|:---:|
| ![Home Screen](assets/screenshots/Screenshot%202026-01-28%20at%2022.34.13.png) | ![Doneness](assets/screenshots/Screenshot%202026-01-28%20at%2022.34.28.png) | ![Timer](assets/screenshots/Screenshot%202026-01-28%20at%2022.34.43.png) |

## 🛠️ Tech Stack

This application is built using **Flutter** and leverages the following key packages:

-   🏗️ **State Management**: `provider`
-   ✨ **Animations**: `flutter_animate`
-   🔔 **Notifications**: `flutter_local_notifications`
-   📢 **Ads**: `google_mobile_ads`
-   💾 **Local Storage**: `shared_preferences`
-   🌐 **Localization**: `intl`
-   🎉 **UI Extras**: `confetti`, `google_fonts`, `cupertino_icons`

## 📂 Project Structure

```text
lib/
├── env/             # 🔐 Environment variables
├── l10n/            # 🌍 Localization files (arb & dart)
├── providers/       # 🏗️ State management providers
├── screens/         # 📱 Application screens (Home, Settings, Timer)
├── services/        # ⚙️ Services (Audio, Ads, Notifications)
├── theme/           # 🎨 App theme and color definitions
├── widgets/         # 🧩 Reusable UI components
└── main.dart        # 🚀 App entry point
```

## 🚀 Getting Started

1.  **Clone the repository**
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```
