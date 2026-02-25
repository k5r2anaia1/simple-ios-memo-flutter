# 📝 Simple iOS Memo App (Flutter)

A clean, minimalist memo application built with Flutter, designed to mimic the native iOS experience using Cupertino widgets. This app focuses on simplicity, speed, and local data privacy.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

## ✨ Features

-   **Apple-Style Design**: Uses `Cupertino` widgets for a native iOS look and feel.
-   **Local Storage**: All data is saved locally on your device using `shared_preferences`. No internet required.
-   **Real-time Search**: Instantly filter memos by title or content.
-   **CRUD Operations**: Create, Read, Update, and Delete memos easily.
-   **Auto-Sort**: Memos are automatically sorted by the latest update time.

## 📂 Source Code Structure

The project follows a clean architecture pattern to separate logic from UI.

```
lib/
├── main.dart                  # Entry point of the application
├── models/
│   └── memo.dart             # Data model for Memo (ID, title, content, dates)
├── services/
│   └── memo_provider.dart    # State management & Business logic (Provider + SharedPreferences)
└── screens/
    ├── home_screen.dart      # Main list view with search bar
    └── edit_screen.dart      # Memo creation and editing interface
```

### Key Components

-   **`MemoProvider`**: Manages the list of memos and handles data persistence. It notifies listeners (UI) whenever data changes.
-   **`HomeScreen`**: Displays the list of memos. Implements a `CupertinoSearchTextField` for filtering.
-   **`EditScreen`**: A simple text editor for writing notes. Supports auto-expanding text fields.

## 🚀 How to Build & Install

### Prerequisites

-   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed
-   **Xcode** (for iOS development on macOS)
-   **CocoaPods** (if running on iOS)

### 1. Clone the Repository

```bash
git clone https://github.com/k5r2anaia1/simple-ios-memo-flutter.git
cd simple-ios-memo-flutter
```

### 2. Install Dependencies

Fetch the required Flutter packages listed in `pubspec.yaml`.

```bash
flutter pub get
```

### 3. Run on iOS Simulator

Open your simulator and run the app:

```bash
open -a Simulator
flutter run
```

### 4. Build for Physical iPhone (macOS only)

1.  Open the iOS project in Xcode:
    ```bash
    open ios/Runner.xcworkspace
    ```
2.  Select your connected iPhone from the device list in Xcode.
3.  Go to the **Signing & Capabilities** tab in project settings.
4.  Select your **Team** (Apple ID) to sign the app.
5.  Press **Run (▶️)** or use `flutter run -d <device_id>`.

## 🛠 Tech Stack

-   **Framework**: Flutter (Dart)
-   **UI Library**: Cupertino (iOS style)
-   **State Management**: Provider
-   **Local Database**: Shared Preferences
-   **Utilities**: UUID (for unique IDs), Intl (for date formatting)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
