# 🚀 App Store Deployment Guide

This guide will walk you through the process of building your Flutter app for production and uploading it to the Apple App Store.

## Prerequisites

-   **Apple Developer Program**: You must be enrolled in the [Apple Developer Program](https://developer.apple.com/programs/) ($99/year).
-   **Xcode**: Installed on your Mac.
-   **Transporter** (Optional but recommended): App for uploading builds to App Store Connect.

---

## Step 1: Prepare App for Release

### 1. Update Version Number
Open `pubspec.yaml` and update the version:
```yaml
version: 1.0.0+1  # format: version_name+build_number
```
-   **1.0.0**: Visible to users on the App Store.
-   **+1**: Build number (must increment for every upload).

### 2. Set App Icon
If you haven't set an app icon, use the `flutter_launcher_icons` package.
1.  Add dev dependency: `flutter pub add -d flutter_launcher_icons`
2.  Configure in `pubspec.yaml`:
    ```yaml
    flutter_icons:
      ios: true
      android: false
      image_path: "assets/icon/app_icon.png"
    ```
3.  Run: `flutter pub run flutter_launcher_icons`

### 3. Check Bundle ID
Open **ios/Runner.xcodeproj** in Xcode.
-   Select the **Runner** target.
-   Go to **General** > **Identity**.
-   Ensure **Bundle Identifier** is unique (e.g., `com.yourname.memoflutter`).

---

## Step 2: Register App ID & Create Record

1.  Log in to [Apple Developer Console](https://developer.apple.com/account/).
2.  Go to **Certificates, Identifiers & Profiles** > **Identifiers**.
3.  Click **(+)** to register a new App ID. Select **App** and enter your **Bundle ID** exactly as it appears in Xcode.
4.  Log in to [App Store Connect](https://appstoreconnect.apple.com/).
5.  Click **My Apps** > **(+) New App**.
6.  Select iOS, choose the App ID you created, and fill in the details.

---

## Step 3: Archive and Build

1.  Open the iOS project in Xcode:
    ```bash
    open ios/Runner.xcworkspace
    ```
2.  Select **Any iOS Device (arm64)** as the build target (top bar, next to stop button).
3.  Go to **Product** > **Archive**.
    -   Xcode will build the app. This may take a few minutes.
4.  Once finished, the **Organizer** window will open showing your build.

---

## Step 4: Validate & Upload

1.  In the **Organizer** window, select your build and click **Distribute App**.
2.  Select **App Store Connect** > **Upload** > **Next**.
3.  Follow the prompts (keep default settings for distribution options).
4.  Xcode will validate the app and upload it.
5.  Wait for the success message: **"App uploaded successfully."**

> **Tip:** You can also export the `.ipa` file and upload it using the **Transporter** app if Xcode upload is slow or fails.

---

## Step 5: TestFlight & Release

1.  Go back to [App Store Connect](https://appstoreconnect.apple.com/).
2.  Click on your app > **TestFlight** tab.
3.  Wait for the build to finish processing (you may get an email when ready).
4.  **Internal Testing:** Add your own email to test immediately.
5.  **Release:** Go to the **App Store** tab, scroll to **Build**, select the uploaded build, fill out screenshots/metadata, and click **Submit for Review**.

🎉 **Congratulations! You've submitted your app.**
Review usually takes 24-48 hours.
