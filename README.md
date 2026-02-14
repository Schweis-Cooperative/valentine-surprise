# Valentine Surprise

A personalized proposal application designed to create a special moment for your partner. Built with Flutter, this app offers full customization for every detail, from the letter content to background music and photo galleries.

Maintained by **Schweis Cooperative**.

## 📱 Multi-Platform Support
This app is engineered to run seamlessly across almost all environments:
- **Android & iOS:** Mobile experience for on-the-go surprises.
- **Windows, macOS & Linux:** Desktop versions for high-quality playback.
- **Web:** Quick access via browser.

---

## 📸 Preview
<p align="center">
  <img src="screenshots/linux_screenshot_1.png" width="30%" alt="Linux Screenshot 1" />
  <img src="screenshots/linux_screenshot_2.png" width="30%" alt="Linux Screenshot 2" />
  <img src="screenshots/web_screenshot.png" width="30%" alt="Web Screenshot" />
</p>

---

## 🔥 Key Feature: The Admin Panel
Unlike traditional personalized apps where you have to dig into the code, Valentine Surprise comes with a built-in **Admin Mode**.
- **On-the-fly Edits:** Change names, proposal questions, and the letter content directly in the UI.
- **Automatic Asset Syncing:** When you select a photo or an MP3 from your computer via the Admin Panel, the app automatically copies that file into the project's `assets/` directory. 
- **Easy Bundling:** Once your customization is done in dev mode, your files are already in the right place, ready to be bundled into your final release (APK, EXE, etc.).

---

## 🛠️ Setup & Installation

### Requirements
- Flutter SDK (3.10.0 or higher)
- `libmpv-dev` (Optional, recommended for high-quality audio on Linux)

### Steps
1. **Clone the Repo:**
   ```bash
   git clone https://github.com/Schweis-Cooperative/valentine-surprise.git
   cd valentine-surprise
   ```
2. **Get Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Enable Admin Mode:**
   Go to `lib/core/constants/app_constants.dart` and set:
   ```dart
   static const bool kIsAdminMode = true;
   ```
4. **Run and Configure:**
   Run the app on your preferred platform:
   ```bash
   flutter run
   ```
   Use the Admin Panel to set your partner's name, upload your "Teddy Bear" image, choose your song, and fill the gallery.

5. **Finalize:**
   Once you're satisfied with the preview, set `kIsAdminMode = false` and build your release:
   ```bash
   flutter build apk --release
   ```

---

## ⚖️ License
Developed by **Schweis Cooperative**. All rights reserved for community use.
