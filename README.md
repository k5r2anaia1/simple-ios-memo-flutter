# 📝 Simple iOS Memo App (Flutter)

A clean, minimalist memo application built with Flutter, designed to mimic the native iOS experience using Cupertino widgets. This app focuses on simplicity, speed, and local data privacy, now with rich multimedia support.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

## ✨ Features

-   **Apple-Style Design**: Uses `Cupertino` widgets for a native iOS look and feel.
-   **Local Storage**: All data is saved locally on your device using `shared_preferences`. No internet required.
-   **Real-time Search**: Instantly filter memos by title or content.
-   **Multimedia Support**: 
    -   📸 **Photos & Videos**: Attach images and videos directly from your camera or gallery.
    -   🎤 **Voice Memos**: Record and playback audio notes.
    -   ✏️ **Handwriting**: Draw sketches or handwritten notes on a canvas.
-   **CRUD Operations**: Create, Read, Update, and Delete memos easily.
-   **Auto-Sort**: Memos are automatically sorted by the latest update time.

## 📂 Source Code Structure

The project follows a clean architecture pattern to separate logic from UI.

```
lib/
├── main.dart                  # Entry point of the application
├── models/
│   └── memo.dart             # Data model including multimedia paths
├── services/
│   └── memo_provider.dart    # State management & Business logic
└── screens/
    ├── home_screen.dart      # Main list view with search bar
    └── edit_screen.dart      # Memo editor with multimedia toolbar
```

### Key Components

-   **`MemoProvider`**: Manages the list of memos and handles data persistence. It notifies listeners (UI) whenever data changes.
-   **`HomeScreen`**: Displays the list of memos. Implements a `CupertinoSearchTextField` for filtering.
-   **`EditScreen`**: A rich editor supporting text, image/video attachments, voice recording, and drawing.

## 🚀 How to Build & Install

### Prerequisites

To run this app on iOS (Simulator or Physical Device), you need a macOS environment with the following tools installed:

1.  **Xcode**: Essential for iOS development.
    *   Install from the **Mac App Store** or [developer.apple.com](https://developer.apple.com/download/all/).
    *   Run license agreement: `sudo xcodebuild -license`

2.  **CocoaPods**: Dependency manager for Swift/Objective-C projects.
    *   Install: `brew install cocoapods` or `sudo gem install cocoapods`

3.  **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install/macos) and add it to your PATH.

### 1. Clone the Repository

```bash
git clone https://github.com/k5r2anaia1/simple-ios-memo-flutter.git
cd simple-ios-memo-flutter
# Switch to the multimedia feature branch if not merged yet
git checkout feature/multimedia-support
```

### 2. Install Dependencies

Fetch Flutter packages and install iOS pods.

```bash
flutter pub get
cd ios && pod install && cd ..
```

### 3. Run on iOS Simulator

Open your simulator and run the app:

```bash
open -a Simulator
flutter run
```

### 4. Build for Physical iPhone (macOS only)

1.  Open the iOS project in Xcode: `open ios/Runner.xcworkspace`
2.  Select your connected iPhone.
3.  Go to **Signing & Capabilities** tab and select your Team (Apple ID).
4.  Press **Run (▶️)**.

> **Note:** On first launch, the app will request permissions for **Camera**, **Microphone**, and **Photo Library** to enable multimedia features.

## 🛠 Tech Stack

-   **Framework**: Flutter (Dart)
-   **UI Library**: Cupertino (iOS style)
-   **State Management**: Provider
-   **Local Database**: Shared Preferences
-   **Multimedia Packages**:
    -   `image_picker` (Photo/Video)
    -   `record` & `audioplayers` (Audio)
    -   `signature` (Handwriting)
    -   `video_player` (Video Playback)

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
