# Update app icon
1. Change `assets/simplynet.png`.
2. Run in terminal:
```
flutter pub run flutter_launcher_icons:main
```
3. Build and publish.


# (Re)branding
To rebrand SimplyNet as "Quantum Satis" for app store publishing, you need to change:

1. App Name (Display Name)
pubspec.yaml:
```
name: simply_net
description: "Quantum Satis network toolkit"
publish_to: 'none'
```

android/app/build.gradle.kts:
Look for app name references in build config

ios/Runner/Info.plist:
```
<key>CFBundleDisplayName</key>
<string>Quantum Satis</string>
```

2. Package Name / Bundle ID (Unique Identifier)
⚠️ Important: This can't be changed after publishing! Choose wisely.

Android - android/app/build.gradle.kts:
```
android {
    namespace = "com.quantumsatis.simplynet"  // Change this
}
```

Android - android/app/src/main/AndroidManifest.xml:
```
android {
    namespace = "com.quantumsatis.simplynet"  // Change this
}
```

iOS - ios/Runner.xcodeproj/project.pbxproj:
Search for bundle identifier and update:
```
PRODUCT_BUNDLE_IDENTIFIER = com.quantumsatis.simplynet;
```

Or in Xcode: Runner → Build Settings → Product Bundle Identifier

3. Developer Account (Store-side, not code)
Google Play: Create/use a Google Play Developer account registered to "Quantum Satis"
App Store: Create/use an Apple Developer account for "Quantum Satis"
Developer name appears in store listings, not in your code
4. Icons and Screenshots
Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
iOS: Update app icons in Xcode asset catalog
Use `flutter_launcher_icons.yaml` to regenerate:
```
flutter_launcher_icons:
  image_path: "assets/simplynet.png"
  ios: true
  android: true
```

Then run: `flutter pub run flutter_launcher_icons`

5. Metadata Files
pubspec.yaml:
```
name: simply_net
description: "Network toolkit by Quantum Satis"
author: "Quantum Satis"
homepage: "https://quantumsatis.com"  # Update if applicable
```

Checklist before publishing:
- [] Update app display name everywhere
- [] Change package name to com.quantumsatis.simplynet (or similar)
- [] Update app icons/branding assets
- [] Update pubspec.yaml metadata
- [] Update iOS bundle ID
- [] Create store accounts under "Quantum Satis"
- [] Write app store descriptions/marketing copy
- [] Generate signing certificates/keys for both platforms

Pro tip: Use `flutter rename` package to automate some of this:
```
dart pub global activate rename
rename --appname "Quantum Satis" --bundleId com.quantumsatis.simplynet
```

Then verify all changes manually before submitting to stores!
