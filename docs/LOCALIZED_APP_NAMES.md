# Localized App Names Guide

Your app now supports different names for English and Chinese users!

## 📱 Current Setup

### Android
- **English**: "HK Transport" (shown when device language is English)
- **Chinese**: "香港交通" (shown when device language is Chinese)

### iOS
- **English**: "HK Transport" (shown when device language is English)
- **Chinese**: "香港交通" (shown when device language is Traditional Chinese)

---

## 🔧 How It Works

### Android
Android automatically uses the correct `strings.xml` file based on the device language:
- `values/strings.xml` → Default/English
- `values-zh-rHK/strings.xml` → Chinese (Hong Kong)

### iOS
iOS uses `InfoPlist.strings` files in language-specific folders:
- `en.lproj/InfoPlist.strings` → English
- `zh-Hant.lproj/InfoPlist.strings` → Traditional Chinese

---

## ✏️ How to Change the Names

### Android - English Name

**File**: `android/app/src/main/res/values/strings.xml`

```xml
<string name="app_name">Your English Name</string>
```

### Android - Chinese Name

**File**: `android/app/src/main/res/values-zh-rHK/strings.xml`

```xml
<string name="app_name">您的中文名稱</string>
```

### iOS - English Name

**File**: `ios/Runner/en.lproj/InfoPlist.strings`

```
CFBundleDisplayName = "Your English Name";
CFBundleName = "Your English Name";
```

### iOS - Chinese Name

**File**: `ios/Runner/zh-Hant.lproj/InfoPlist.strings`

```
CFBundleDisplayName = "您的中文名稱";
CFBundleName = "您的中文名稱";
```

---

## 📋 File Locations Summary

| Platform | Language | File Location |
|----------|----------|---------------|
| **Android** | English | `android/app/src/main/res/values/strings.xml` |
| **Android** | Chinese | `android/app/src/main/res/values-zh-rHK/strings.xml` |
| **iOS** | English | `ios/Runner/en.lproj/InfoPlist.strings` |
| **iOS** | Chinese | `ios/Runner/zh-Hant.lproj/InfoPlist.strings` |

---

## 🎯 Adding More Languages

### Android
Create new folders following the pattern:
- `values-zh/strings.xml` (Simplified Chinese)
- `values-ja/strings.xml` (Japanese)
- `values-ko/strings.xml` (Korean)
- etc.

### iOS
Create new `.lproj` folders:
- `zh-Hans.lproj/InfoPlist.strings` (Simplified Chinese)
- `ja.lproj/InfoPlist.strings` (Japanese)
- `ko.lproj/InfoPlist.strings` (Korean)
- etc.

---

## ⚠️ Important Notes

1. **Name Length**:
   - Android: Recommended max 30 characters
   - iOS: Recommended max 12 characters (longer names get truncated on home screen)

2. **After Changes**:
   - Rebuild your app: `flutter clean && flutter build appbundle --release`
   - Test on devices with different languages to verify

3. **Testing**:
   - Change your device language to test different names
   - Android: Settings → System → Languages
   - iOS: Settings → General → Language & Region

4. **Fallback**:
   - If a language folder doesn't exist, the default (English) will be used

---

## 🔍 Current Configuration

### English Names
- **Android**: `values/strings.xml` → "HK Transport"
- **iOS**: `en.lproj/InfoPlist.strings` → "HK Transport"

### Chinese Names
- **Android**: `values-zh-rHK/strings.xml` → "香港交通"
- **iOS**: `zh-Hant.lproj/InfoPlist.strings` → "香港交通"

---

## 🧪 Testing

To test localized names:

1. **On Android**:
   - Change device language to English → Should show "HK Transport"
   - Change device language to Chinese (繁體中文) → Should show "香港交通"

2. **On iOS**:
   - Change device language to English → Should show "HK Transport"
   - Change device language to Chinese (繁體中文) → Should show "香港交通"

3. **In Simulator/Emulator**:
   - You can change language in device settings
   - Restart the app to see the new name

---

## 📝 Example: Custom Names

If you want to change to different names:

### Example: "Transport HK" (English) and "交通香港" (Chinese)

**Android English** (`values/strings.xml`):
```xml
<string name="app_name">Transport HK</string>
```

**Android Chinese** (`values-zh-rHK/strings.xml`):
```xml
<string name="app_name">交通香港</string>
```

**iOS English** (`en.lproj/InfoPlist.strings`):
```
CFBundleDisplayName = "Transport HK";
CFBundleName = "Transport HK";
```

**iOS Chinese** (`zh-Hant.lproj/InfoPlist.strings`):
```
CFBundleDisplayName = "交通香港";
CFBundleName = "交通香港";
```

---

That's it! Your app will automatically show the correct name based on the user's device language! 🌍

