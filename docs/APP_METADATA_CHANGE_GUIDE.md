# App Icon, Name, and Description Change Guide

## 📱 App Icon

### Current Configuration
The app icon is configured in `pubspec.yaml` using `flutter_launcher_icons`.

**Location**: `pubspec.yaml` (lines 91-96)

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "lib/assets/rab17_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "lib/assets/rab17_icon.png"
```

### How to Change

1. **Replace the icon file**:
   - Replace `lib/assets/rab17_icon.png` with your new icon
   - Recommended size: **1024x1024px** (PNG format)
   - Should be square with transparent or solid background

2. **Update the path** (if using a different file):
   ```yaml
   image_path: "lib/assets/your_new_icon.png"
   ```

3. **Update adaptive icon colors** (Android):
   ```yaml
   adaptive_icon_background: "#YOUR_COLOR"  # Hex color for background
   adaptive_icon_foreground: "lib/assets/your_new_icon.png"
   ```

4. **Regenerate icons**:
   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

   Or if you have it as a dev dependency:
   ```bash
   dart run flutter_launcher_icons
   ```

---

## 📛 App Name

### Android

**Location**: `android/app/src/main/res/values/strings.xml`

```xml
<string name="app_name">rb17_transportT_checker</string>
```

**How to Change**:
1. Open `android/app/src/main/res/values/strings.xml`
2. Change the value inside `<string name="app_name">` to your desired name
3. Example: `<string name="app_name">HK Transport</string>`

**For Chinese localization** (optional):
- Location: `android/app/src/main/res/values-zh-rHK/strings.xml`
- Add the Chinese name there if you want different names per language

### iOS

**Location**: `ios/Runner/Info.plist`

**Lines to change**:
- Line 8: `CFBundleDisplayName` (what users see on home screen)
- Line 16: `CFBundleName` (internal name)

```xml
<key>CFBundleDisplayName</key>
<string>next_transports</string>
<key>CFBundleName</key>
<string>next_transports</string>
```

**How to Change**:
1. Open `ios/Runner/Info.plist`
2. Change both `CFBundleDisplayName` and `CFBundleName` values
3. Example: Change to `HK Transport` or your desired name

---

## 📝 App Description

**Location**: `pubspec.yaml` (line 2)

```yaml
description: "A new Flutter project."
```

**How to Change**:
1. Open `pubspec.yaml`
2. Update the `description` field
3. Example:
   ```yaml
   description: "Real-time Hong Kong transport information app for MTR and KMB buses"
   ```

**Note**: This description is used in:
- Package metadata
- Can be referenced in your app
- Should be a brief summary (1-2 sentences)

---

## 🎯 Quick Change Checklist

### To Change App Icon:
- [ ] Replace `lib/assets/rab17_icon.png` with your new icon (1024x1024px)
- [ ] Update `image_path` in `pubspec.yaml` if using different filename
- [ ] Update `adaptive_icon_background` color if needed
- [ ] Run `flutter pub run flutter_launcher_icons`

### To Change App Name:
- [ ] Update `android/app/src/main/res/values/strings.xml` (Android)
- [ ] Update `ios/Runner/Info.plist` - `CFBundleDisplayName` and `CFBundleName` (iOS)
- [ ] (Optional) Update Chinese strings in `values-zh-rHK/strings.xml`

### To Change Description:
- [ ] Update `description` field in `pubspec.yaml`

---

## 📋 Example Changes

### Example: Change to "HK Transport"

**Android** (`android/app/src/main/res/values/strings.xml`):
```xml
<string name="app_name">HK Transport</string>
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>CFBundleDisplayName</key>
<string>HK Transport</string>
<key>CFBundleName</key>
<string>HK Transport</string>
```

**Description** (`pubspec.yaml`):
```yaml
description: "Real-time Hong Kong transport information for MTR and KMB buses"
```

---

## ⚠️ Important Notes

1. **App Name Length**:
   - Android: Recommended max 30 characters (may be truncated on some devices)
   - iOS: Recommended max 12 characters for home screen (longer names get truncated)

2. **Icon Requirements**:
   - Must be square (1:1 aspect ratio)
   - Recommended: 1024x1024px minimum
   - PNG format with transparency support
   - For Android adaptive icons, the foreground should be centered

3. **After Changes**:
   - Rebuild your app: `flutter clean && flutter build appbundle --release`
   - Test on both Android and iOS to ensure names/icons display correctly

4. **Play Store Listing**:
   - The app name in Play Store can be different from the installed app name
   - You set the Play Store name in Google Play Console (up to 50 characters)

---

## 🔄 Regenerating Icons

After updating the icon configuration:

```bash
# Clean previous builds
flutter clean

# Regenerate icons
flutter pub get
flutter pub run flutter_launcher_icons

# Rebuild app
flutter build appbundle --release
```

---

## 📍 File Locations Summary

| Item | Android | iOS | Description |
|------|---------|-----|-------------|
| **App Name** | `android/app/src/main/res/values/strings.xml` | `ios/Runner/Info.plist` | Display name on device |
| **App Icon** | `pubspec.yaml` (flutter_launcher_icons) | `pubspec.yaml` (flutter_launcher_icons) | Launcher icon |
| **Description** | `pubspec.yaml` | `pubspec.yaml` | Package description |

---

## 🎨 Icon Design Tips

- **Keep it simple**: Icons are small on devices, complex designs don't work well
- **Use high contrast**: Ensure visibility on various backgrounds
- **Test on devices**: Check how it looks on actual devices
- **Follow platform guidelines**:
  - [Android Material Design Icons](https://material.io/design/iconography/product-icons.html)
  - [iOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)

---

Need help? Check the files mentioned above and make your changes!

