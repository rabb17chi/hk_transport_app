# Google Play Store Publishing Guide

## Prerequisites

✅ You have a Google Play Developer account (already purchased)
✅ Your app is signed with a release keystore
✅ Version is set to 1.0.0+1 in `pubspec.yaml`
✅ All features are tested and working

---

## Step 1: Prepare Your App Bundle

### Build the App Bundle (AAB)

Instead of APK, Google Play requires an **Android App Bundle (AAB)** for new apps:

```bash
flutter build appbundle --release
```

This creates: `build/app/outputs/bundle/release/app-release.aab`

**Why AAB?**
- Smaller download size for users
- Google Play generates optimized APKs per device
- Required for new apps on Play Store

---

## Step 2: Prepare Store Listing Assets

### Required Assets

1. **App Icon** (512x512px PNG, no transparency)
   - Location: `android/app/src/main/res/mipmap-*/ic_launcher.png`
   - Or use your existing: `lib/assets/rab17_icon.png`

2. **Feature Graphic** (1024x500px PNG/JPG)
   - Banner shown at top of your Play Store listing
   - Create or use existing graphics

3. **Screenshots** (Required: at least 2, Recommended: 4-8)
   - Phone: 16:9 or 9:16 aspect ratio
   - Minimum: 320px, Maximum: 3840px
   - Take screenshots of your app's main features

4. **Short Description** (80 characters max)
   - Brief summary of your app
   - Example: "Real-time Hong Kong transport information for MTR and KMB buses"

5. **Full Description** (4000 characters max)
   - Detailed description of features
   - Use the content from your README.md

6. **App Category**
   - Primary: Travel & Local (or Transportation)
   - Secondary: (optional)

7. **Content Rating**
   - Complete the questionnaire (usually "Everyone")

8. **Privacy Policy URL** (Required)
   - If your app collects any data, you need a privacy policy
   - Host it on GitHub Pages, your website, or a free hosting service

---

## Step 3: Create App in Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Click **"Create app"**
3. Fill in:
   - **App name**: "HK Transport App" (or your preferred name)
   - **Default language**: English (United States)
   - **App or game**: App
   - **Free or paid**: Free
   - **Declarations**: Check all applicable boxes

---

## Step 4: Complete Store Listing

1. Navigate to **"Store presence" → "Main store listing"**

2. Fill in all required fields:
   - **App name**: HK Transport App
   - **Short description**: (80 chars max)
   - **Full description**: (4000 chars max)
   - **App icon**: Upload 512x512px icon
   - **Feature graphic**: Upload 1024x500px banner
   - **Screenshots**: Upload at least 2 screenshots
   - **Category**: Travel & Local
   - **Contact details**: Your email/website

3. **Privacy Policy**:
   - If you don't have one, create a simple one stating:
     - What data you collect (if any)
     - How you use it
     - That you don't share it with third parties
   - Host it and provide the URL

---

## Step 5: Set Up App Content

1. **Content rating**:
   - Go to **"Policy" → "App content"**
   - Complete the questionnaire
   - Usually results in "Everyone" rating

2. **Target audience**:
   - Select appropriate age groups
   - For transport app: Usually "Everyone"

3. **Data safety**:
   - Declare what data your app collects
   - For your app: Likely "No data collected" or minimal data

---

## Step 6: Upload Your App Bundle

1. Go to **"Production"** (or "Testing" → "Internal testing" for testing first)

2. Click **"Create new release"**

3. **Upload AAB**:
   - Click "Upload" and select your `app-release.aab` file
   - Wait for Google Play to process it

4. **Release name** (optional):
   - Example: "1.0.0 - Initial Release"

5. **Release notes**:
   - Describe what's new in this version
   - Example: "Initial release with MTR and KMB real-time information"

6. Click **"Save"** (don't publish yet if testing)

---

## Step 7: Testing (Recommended Before Production)

### Internal Testing Track

1. Create an **Internal testing** release
2. Add testers (your email or test group)
3. Upload the same AAB
4. Test the app thoroughly
5. Once satisfied, promote to Production

### Test Checklist

- [ ] App installs correctly
- [ ] All features work as expected
- [ ] No crashes on different devices
- [ ] Localization works (English/Chinese)
- [ ] Dark mode works
- [ ] Navigation works smoothly
- [ ] API calls work correctly
- [ ] Bookmarks save/load correctly

---

## Step 8: Production Release

1. Go to **"Production"** track

2. Click **"Create new release"**

3. Upload your AAB file

4. Fill in release notes

5. Review all information

6. Click **"Review release"**

7. If everything looks good, click **"Start rollout to Production"**

8. Your app will be submitted for review (usually 1-7 days)

---

## Step 9: App Review Process

Google Play will review your app for:
- ✅ Policy compliance
- ✅ Content appropriateness
- ✅ Technical issues
- ✅ Security

**Common rejection reasons:**
- Missing privacy policy
- Misleading content
- Inappropriate permissions
- Crashes or bugs

**If rejected:**
- Read the feedback
- Fix the issues
- Resubmit

---

## Step 10: After Publication

### Monitor Your App

1. **Statistics**: Check downloads, ratings, crashes
2. **Reviews**: Respond to user reviews
3. **Crashes**: Monitor crash reports in Play Console
4. **Updates**: Plan for future updates

### Future Updates

For each update:
1. Increment version in `pubspec.yaml` (e.g., 1.0.1+2)
2. Build new AAB: `flutter build appbundle --release`
3. Upload to Play Console
4. Add release notes
5. Submit for review

---

## Important Notes

### Keystore Security

⚠️ **CRITICAL**: Keep your keystore file (`hk_transport.jks`) safe!
- **Never lose it** - you can't update your app without it
- **Back it up** in multiple secure locations
- **Don't commit it to Git** (already in `.gitignore`)
- If lost, you'll need to create a new app listing

### Version Code

- Each release must have a **higher version code** than the previous
- Version code = the number after `+` in `pubspec.yaml`
- Example: 1.0.0+1 → 1.0.1+2 → 1.0.2+3

### Version Name

- Version name = the number before `+` in `pubspec.yaml`
- This is what users see (e.g., "1.0.0")
- Can be any format, but semantic versioning is recommended

---

## Quick Reference Commands

```bash
# Build release AAB
flutter build appbundle --release

# Build release APK (for testing)
flutter build apk --release

# Check app size
flutter build appbundle --release --analyze-size

# Clean build
flutter clean
flutter pub get
flutter build appbundle --release
```

---

## Troubleshooting

### "Upload failed: Invalid AAB"
- Make sure you're using `appbundle`, not `apk`
- Check that your keystore is properly configured

### "Version code already used"
- Increment the build number in `pubspec.yaml`
- Rebuild and upload

### "Missing privacy policy"
- Create a privacy policy document
- Host it online (GitHub Pages, etc.)
- Add the URL in Play Console

### "App rejected"
- Read the rejection reason carefully
- Fix the issues mentioned
- Resubmit with explanations if needed

---

## Resources

- [Google Play Console](https://play.google.com/console)
- [Flutter App Publishing](https://docs.flutter.dev/deployment/android)
- [Google Play Policy](https://play.google.com/about/developer-content-policy/)
- [App Bundle Guide](https://developer.android.com/guide/app-bundle)

---

## Checklist Before Publishing

- [ ] Version set to 1.0.0+1
- [ ] App signed with release keystore
- [ ] AAB built successfully
- [ ] All features tested
- [ ] Screenshots prepared
- [ ] Store listing completed
- [ ] Privacy policy created and linked
- [ ] Content rating completed
- [ ] App tested on multiple devices
- [ ] No crashes or critical bugs
- [ ] Keystore backed up securely

---

Good luck with your publication! 🚀

