# MITRA Student App
## Complete Deploy & Go-Live Guide
### Written for non-developers. No coding experience needed.

---

# SECTION A — SET UP YOUR COMPUTER (One-time, ~90 minutes)

---

## Step 1 · Install Git

Git is a background tool Flutter needs. You will never open it yourself.

**Windows:**
1. Go to **https://git-scm.com/download/win**
2. Click the first download link — it starts automatically
3. Open the file → click **Next** on every screen → click **Finish**

**Mac:**
1. Press **Cmd + Space**, type **Terminal**, press Enter
2. Type this and press Enter:
   ```
   xcode-select --install
   ```
3. Click **Install** in the popup — wait 10 minutes

✅ Done when: no red error text appeared

---

## Step 2 · Install Flutter

Flutter converts the code into a real phone app.

**Windows:**
1. Go to **https://docs.flutter.dev/get-started/install/windows**
2. Click **Download Flutter SDK** — a zip file downloads
3. Unzip it — a folder called `flutter` appears
4. Move that folder to `C:\flutter`
5. Press the **Windows key** → type **"environment variables"** → click the first result
6. Click **Environment Variables** at the bottom
7. Under **System Variables**, find **Path** → double-click it
8. Click **New** → type `C:\flutter\bin` → click **OK** on all windows

**Mac:**
1. Go to **https://docs.flutter.dev/get-started/install/macos**
2. Choose **Apple Silicon** (Mac 2020+) or **Intel** (older Mac)
3. Download and unzip — a `flutter` folder appears on your Desktop
4. Open Terminal and paste these 3 lines one at a time:
   ```
   sudo mkdir -p /development
   sudo mv ~/Desktop/flutter /development/flutter
   echo 'export PATH="$PATH:/development/flutter/bin"' >> ~/.zshrc
   ```
5. Close Terminal and reopen it

✅ Done when: typing `flutter --version` shows a version number like `Flutter 3.x.x`

---

## Step 3 · Install Android Studio

This is the code editor and Android build tool in one.

1. Go to **https://developer.android.com/studio**
2. Click the green **Download Android Studio** button
3. Open the installer → click **Next** on everything → choose **Standard** install
4. It downloads more tools automatically — this takes 15–20 minutes. Let it finish.
5. Click **Finish**

✅ Done when: Android Studio opens to a welcome screen

---

## Step 4 · Install the Flutter Plugin in Android Studio

1. Open **Android Studio**
2. Click **Plugins** in the left panel
3. Search for **Flutter** → click **Install**
4. When asked about Dart → click **Yes**
5. Click **Restart IDE**

---

## Step 5 · Accept Android Licenses

Open Terminal (Mac) or Command Prompt (Windows) and type:
```
flutter doctor --android-licenses
```
For every question, type `y` and press Enter until done.

✅ Done when: you see **"All SDK package licenses accepted"**

---

## Step 6 · Verify Everything Works

Type this in Terminal:
```
flutter doctor
```
You should see green ✅ next to:
- Flutter
- Android toolchain
- Android Studio

> If you see a red ✗, read the message — it will tell you exactly what to click to fix it.

---

# SECTION B — SET UP THE MITRA PROJECT

---

## Step 7 · Unzip the Project

1. Find the file **`mitra_student_app.zip`** you downloaded
2. **Windows:** Right-click → **Extract All** → choose your Desktop → Extract
   **Mac:** Double-click the zip file
3. A folder called **`mitra_student`** appears on your Desktop

---

## Step 8 · Open the Project in Android Studio

1. Open **Android Studio**
2. Click **Open** (or **File → Open**)
3. Navigate to and click on the **`mitra_student`** folder
4. Click **OK / Open**

> ⏳ Wait 2–3 minutes while Android Studio reads the project. You'll see a progress bar at the bottom.

---

## Step 9 · Install All Packages

The app needs to download ~25 helper packages from the internet.

1. At the bottom of Android Studio, click the **Terminal** tab
2. Type this exactly and press Enter:
   ```
   flutter pub get
   ```
3. Wait — you'll see text scrolling

✅ Done when: you see **"Got dependencies!"**

---

## Step 10 · Generate Helper Code

Type this in the same Terminal tab and press Enter:
```
flutter pub run build_runner build --delete-conflicting-outputs
```

> ⏳ Takes 2–4 minutes. Copy-paste this line exactly — every word matters.

✅ Done when: you see **"[INFO] Succeeded"**

---

## Step 11 · Generate Language Files

Type this and press Enter:
```
flutter gen-l10n
```

✅ Done when: you see no error (it may show nothing at all — that's fine)

---

# SECTION C — RUN ON YOUR PHONE

---

## Step 12 · Enable Developer Mode on Your Android Phone

> This lets your computer install the app directly on your phone.

1. Open **Settings** on your Android phone
2. Scroll to **About Phone** → tap it
3. Find **Build Number** (sometimes inside **Software Information**)
4. **Tap Build Number 7 times quickly**
   - You'll see: *"You are 4 steps away from being a developer"*
   - Keep tapping until you see: *"You are now a developer!"*
5. Go back to **Settings** — a new **Developer Options** menu is now there
6. Tap **Developer Options**
7. Make sure the toggle at the top is **ON**
8. Scroll down to find **USB Debugging** → turn it **ON**
9. Tap **OK** on the confirmation popup

---

## Step 13 · Connect Your Phone

1. Connect your phone to your laptop using a **USB cable**
2. On your phone, a popup asks **"Allow USB Debugging?"** → tap **Always Allow**
3. In Android Studio, look at the **top toolbar** — there's a dropdown that says `<no device>`
4. Click that dropdown — your phone's name appears (e.g. *"Samsung Galaxy A52"*)
5. Select your phone

> 🔌 If your phone doesn't appear — try a different USB cable. Many phone charger cables are power-only and don't carry data. You need a data cable.

---

## Step 14 · Run the App! 🚀

1. Click the **green ▶ Play button** in Android Studio's top toolbar
2. Android Studio builds and installs the app — **first time takes 3–7 minutes**
3. The MITRA splash screen appears on your phone automatically

**You'll see:**
- A splash screen with the MITRA logo and spinning rings
- The 3-slide onboarding intro
- A login screen with Student / Teacher selector
- OTP login (works with any number in mock mode)

---

# SECTION D — WHAT THE APP DOES RIGHT NOW (Mock Mode)

The app runs entirely on mock data so you can explore every screen:

| Screen | What to try |
|--------|-------------|
| **Splash** | Logo animation, loading dots |
| **Onboarding** | Swipe through 3 slides, tap Get Started |
| **Login** | Enter any 10-digit number, tap Send OTP, enter any 6 digits |
| **Consent** | Read privacy policy, tick checkbox, tap I Agree |
| **State Setup** | Tap a state flag or use Auto-detect |
| **Profile Setup** | Pick an avatar, enter name, choose class |
| **Home** | See stats, subject grid, quick actions, leaderboard preview |
| **Learn** | Browse topics, filter by AR Ready, search |
| **AR** | See camera permission screen, then AR scanner |
| **Ranks** | See podium + full leaderboard |
| **Profile** | See badges, settings shortcuts |
| **Settings** | Toggle dark/light theme, switch languages |

---

# SECTION E — CONNECT YOUR REAL BACKEND (Go Live)

---

## Step 15 · The One URL Change

Once your developer has set up the backend server, you change **one line**:

1. In Android Studio, look at the left file panel
2. Navigate: `lib` → `services` → `api_service.dart`
3. Double-click `api_service.dart`
4. Press **Ctrl+F** (Windows) or **Cmd+F** (Mac) to search
5. Search for: `api.mitra.gov.in`
6. You'll see:
   ```dart
   static const base = 'https://api.mitra.gov.in/v1';
   ```
7. Change the URL to your real server address:
   ```dart
   static const base = 'https://YOUR-REAL-SERVER.com/v1';
   ```
8. Press **Ctrl+S** / **Cmd+S** to save
9. Press the **▶ Play button** again

---

## Step 16 · What Your Developer Must Build

Give your developer the file **`BACKEND_API_CONTRACT.md`** (included in the zip). It contains:

- Every API endpoint the app calls
- Exact JSON request and response shapes
- Complete PostgreSQL database schema (15 tables)
- JWT token format
- WhatsApp OTP integration instructions

**Minimum backend checklist for Day 1:**
- [ ] `POST /auth/otp/request` — sends WhatsApp OTP
- [ ] `POST /auth/otp/verify` — returns JWT tokens
- [ ] `GET /app-config` — returns state config JSON
- [ ] `POST /student/profile/setup` — saves student profile
- [ ] `GET /curriculum/subjects` — returns subject list
- [ ] `GET /curriculum/topics` — returns topic list

---

## Step 17 · WhatsApp OTP Setup

The app sends OTP via WhatsApp (not SMS) — this requires:

1. Sign up at **https://www.twilio.com** (or Meta's WhatsApp Business API)
2. Get a WhatsApp-enabled phone number
3. Set up the OTP message template:
   ```
   Your MITRA verification code is: {{1}}
   This code expires in 10 minutes.
   ```
4. Pass the Twilio credentials to your developer:
   - Account SID
   - Auth Token
   - WhatsApp number

---

## Step 18 · Build the Final App for Distribution

When everything is tested and working:

**For Android (Google Play Store or direct APK):**

In Terminal, type:
```
flutter build apk --release
```
The APK file will be at:
```
build/app/outputs/flutter-apk/app-release.apk
```
This file can be shared directly with schools, or uploaded to Google Play Store.

**For Google Play Store:**
```
flutter build appbundle --release
```
Upload the `.aab` file at **https://play.google.com/console**

**For iOS (iPhone — requires a Mac):**
```
flutter build ipa --release
```
Upload via Xcode or **https://appstoreconnect.apple.com**

---

# SECTION F — TROUBLESHOOTING

---

**Problem:** `flutter` command not found after installing
**Fix:** Close Terminal completely, reopen it, try again. If still not working, restart your computer.

---

**Problem:** Phone not showing in device dropdown
**Fix:**
1. Check USB Debugging is ON (Step 12)
2. Try a different USB cable — your current one may be charge-only
3. On your phone, tap **Always Allow** when the USB debugging popup appears
4. Unplug and replug the cable

---

**Problem:** Build fails with red "Gradle" error
**Fix:**
```
flutter clean
flutter pub get
```
Then press ▶ again. This resets the build cache.

---

**Problem:** `build_runner` fails saying "conflicts"
**Fix:** Make sure you included `--delete-conflicting-outputs` at the very end. Copy the full command from Step 10.

---

**Problem:** App opens but shows "Connection Error"
**Fix:** You're connected to the real backend URL but the server isn't responding.
1. Ask your developer to confirm the server is running
2. Test the URL in a browser — you should see `{"message": "MITRA API"}` or similar
3. Make sure the URL starts with `https://` not `http://`

---

**Problem:** Language text shows English even after switching
**Fix:** You may have skipped Step 11. Run `flutter gen-l10n` in Terminal, then rebuild.

---

**Problem:** AR screen shows permission dialog repeatedly
**Fix:** Go to your phone's **Settings → Apps → MITRA → Permissions** and make sure Camera is set to **Allow**.

---

**Problem:** App crashes immediately on opening
**Fix:**
1. In Terminal, type: `flutter run --debug`
2. Look at the red error text
3. Most likely cause: you skipped Step 10 (build_runner). Run it again.

---

# QUICK REFERENCE CARD

| Task | Command |
|------|---------|
| Install packages | `flutter pub get` |
| Generate code | `flutter pub run build_runner build --delete-conflicting-outputs` |
| Generate language files | `flutter gen-l10n` |
| Run on phone | Press ▶ in Android Studio |
| Clean build cache | `flutter clean` |
| Check setup health | `flutter doctor` |
| Build release APK | `flutter build apk --release` |
| Build Play Store bundle | `flutter build appbundle --release` |

---

# GLOSSARY

| Word | What it means |
|------|--------------|
| **Flutter** | The tool that turns the code files into a real phone app |
| **Dart** | The programming language the code is written in |
| **Riverpod** | The system that manages data inside the app |
| **Hive** | The local database that stores data offline on the phone |
| **WorkManager** | A background service that syncs data while the app is minimised |
| **APK** | The installable app file for Android phones |
| **JWT** | A secure digital badge the server gives the app after login |
| **OTP** | One-Time Password — the 6-digit code sent via WhatsApp |
| **SDUI** | Server-Driven UI — the backend tells the app what features to show |
| **Geofencing** | Restricting features based on the user's state/location |
| **ARB file** | A language file that contains translated text for the app |
| **pub get** | "Download all the packages this project needs" |
| **build_runner** | "Auto-write some code that would be boring to write by hand" |
| **Mock data** | Fake placeholder data used while the real backend is being built |
| **DPDP Act 2023** | India's Digital Personal Data Protection Act — the app complies with it |
| **COPPA** | Children's Online Privacy Protection Act — global children's app standard |
