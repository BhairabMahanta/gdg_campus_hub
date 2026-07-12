# Flutter Setup Guide — Windows, Zero to Running Android Emulator

Follow this exactly, in order. This gets you a real Android emulator running inside VS Code — the actual app dev experience, not just a browser preview.

Total time: 35-50 minutes depending on internet speed. Most of that is downloads running in the background, so keep this open in another tab while things install.

---

## Step 1 — Install Git

Flutter needs Git to work properly.

1. Go to https://git-scm.com/downloads/win
2. Download the 64-bit installer.
3. Run it. Click "Next" through every screen, keep all defaults.
4. Finish install.

Verify: open Command Prompt and run:

```
git --version
```

You should see a version number.

---

## Step 2 — Install VS Code

1. Go to https://code.visualstudio.com
2. Download for Windows.
3. Run installer, keep defaults, make sure "Add to PATH" is checked during install.
4. Finish and open VS Code once to confirm it launches.

---

## Step 3 — Install Android Studio

Android Studio brings the Android SDK, platform tools, and the emulator manager. You do not need to write code in it — VS Code stays your main editor.

1. Go to https://developer.android.com/studio
2. Download and run the installer.
3. Keep every default in the setup wizard, including "Android Virtual Device."
4. Let it finish downloading the Android SDK components — this step alone can take 10-15 minutes.
5. Once Android Studio opens, go to **More Actions > SDK Manager** (or **Settings > Languages & Frameworks > Android SDK** if a project is open).
6. Under "SDK Platforms" tab, make sure the latest Android version has a checkmark.
7. Under "SDK Tools" tab, make sure these are checked: **Android SDK Build-Tools**, **Android SDK Command-line Tools**, **Android Emulator**, **Android SDK Platform-Tools**.
8. Click Apply, let it install, then close Android Studio.

---

## Step 4 — Download the Flutter SDK

1. Go to https://docs.flutter.dev/install/manual
2. Download the Windows zip file (flutter_windows_x.x.x-stable.zip).
3. Create a folder at `C:\src` (create it yourself, don't use Program Files — permission issues happen there).
4. Extract the zip directly into `C:\src`. After extraction you should have `C:\src\flutter`.

Do not put Flutter inside a folder path with spaces or special characters.

---

## Step 5 — Add Flutter to PATH

1. Press Windows key, search "environment variables", open "Edit the system environment variables".
2. Click "Environment Variables" button.
3. Under "User variables", select "Path", click "Edit".
4. Click "New", paste in:

```
C:\src\flutter\bin
```

5. Click OK on all three windows.
6. Close ALL open terminal windows completely (old windows won't see the update).

Verify: open a brand new Command Prompt and run:

```
flutter --version
```

You should see Flutter's version info. If "flutter is not recognized," redo this step — the PATH wasn't saved.

---

## Step 6 — Run Flutter Doctor and Fix Android Issues

Open a new terminal and run:

```
flutter doctor
```

You'll likely see a warning under Android toolchain about licenses. Fix it by running:

```
flutter doctor --android-licenses
```

Type `y` and press Enter for every license prompt that appears — there are usually 5-7 of them. If this command says "command not found" or crashes, close and reopen your terminal, then try again; it usually means PATH hasn't refreshed yet.

Run `flutter doctor` again. You want to see:

```
[✓] Flutter
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Android Studio
```

VS Code and Connected device rows will show up later, once we finish the remaining steps — that's normal for now.

---

## Step 7 — Install the Flutter and Dart Extensions in VS Code

1. Open VS Code.
2. Click the Extensions icon on the left sidebar (or `Ctrl+Shift+X`).
3. Search "Flutter".
4. Install the official extension named **Flutter** (published by Dart Code). This auto-installs the **Dart** extension too.

---

## Step 8 — Create an Android Emulator (AVD)

This is the actual virtual phone your app will run on.

1. Open Android Studio.
2. Click **More Actions > Virtual Device Manager** (or **Device Manager** icon in the sidebar if a project is open).
3. Click **Create Device** (or the `+` icon).
4. Pick a device model — **Pixel 7** is a safe, well-tested choice. Click Next.
5. Pick a system image — choose the recommended one at the top with a download icon next to it (usually the latest API level). Click Download, wait for it to finish, then click Next.
6. Give it a name if you want, leave everything else default, click **Finish**.

Your emulator now appears in the Device Manager list.

---

## Step 9 — Boot the Emulator

Click the play/triangle icon next to your new virtual device in Device Manager. The emulator window opens — it takes 30-60 seconds to fully boot the first time, same as turning on a real phone.

Leave it running. You'll use it repeatedly.

---

## Step 10 — Clone the Project

In a terminal:

```
git clone https://github.com/BhairabMahanta/gdg_campus_hub.git
cd gdg_campus_hub
```

Open the folder in VS Code: File > Open Folder > select `gdg_campus_hub`.

---

## Step 11 — Get Dependencies

In the VS Code terminal, inside the project folder:

```
flutter pub get
```

This downloads all packages listed in `pubspec.yaml`.

---

## Step 12 — Run the App on the Emulator

With the emulator still open and booted, run:

```
flutter run
```

Flutter auto-detects the running emulator as the target device. First run takes 2-4 minutes to build the Android APK — this is much slower than Chrome because it's compiling a real native app.

Alternative: press `F5` in VS Code, or click the device selector at the bottom-right of VS Code and pick your emulator by name, then hit Run.

---

## Step 13 — Confirm Hot Reload Works

With the app running on the emulator, open any file in `lib/`, change a piece of text (like a button label), save the file (`Ctrl+S`). The emulator updates almost instantly without a full app restart.

If this works, your setup is complete and correct — you now have the full real app dev loop: native build, real Android UI, real permissions behavior, real performance characteristics.

---

## Common Problems

| Problem | Fix |
|---|---|
| `flutter` not recognized in terminal | PATH wasn't set correctly — redo Step 5, then fully close and reopen VS Code |
| License prompt loop never ends or crashes | Close terminal, reopen, run `flutter doctor --android-licenses` again — sometimes it needs two passes |
| Emulator stuck on boot screen for a long time | First boot is always slow (up to 2 minutes) — if it exceeds 5 minutes, cold boot it again from Device Manager (right-click > Cold Boot Now) |
| `flutter run` says "no connected devices" | Make sure the emulator is fully booted (unlocked home screen visible) before running |
| VS Code doesn't show the emulator in device dropdown | Reload VS Code window: `Ctrl+Shift+P` > "Reload Window" |
| Emulator is extremely slow/laggy | Enable virtualization (Intel VT-x / AMD-V) in your laptop's BIOS — required for the emulator to use hardware acceleration |
| Laptop has low RAM (under 8GB) and emulator won't run well | Use a lower-RAM AVD profile (e.g., Pixel 4a) instead of Pixel 7, or fall back to `flutter run -d chrome` for that session only |

---

## Optional but Recommended: Run on a Real Phone Instead

If your laptop struggles with the emulator, you can skip it entirely and use your own Android phone:

1. On your phone: Settings > About Phone > tap "Build Number" 7 times to unlock Developer Options.
2. Settings > Developer Options > enable **USB Debugging**.
3. Connect your phone to your laptop via USB cable.
4. Accept the "Allow USB Debugging" popup on your phone.
5. Run `flutter run` — your phone will appear as a connected device automatically.

This is often faster than an emulator and uses zero laptop resources.
