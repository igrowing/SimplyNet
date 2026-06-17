# Update app icon
1. Change `assets/simplynet.png`.
2. Run in terminal:
```
flutter pub run flutter_launcher_icons:main
```
3. Build and publish.


# (Re)branding
To rebrand SimplyNet as "SimplyTools" for app store publishing, you need to change:

1. App Name (Display Name)
pubspec.yaml:
```
name: simply_net
description: "SimplyTools network toolkit"
publish_to: 'none'
```

android/app/build.gradle.kts:
Look for app name references in build config

ios/Runner/Info.plist:
```
<key>CFBundleDisplayName</key>
<string>SimplyTools</string>
```

2. Package Name / Bundle ID (Unique Identifier)
⚠️ Important: This can't be changed after publishing! Choose wisely.

Android - android/app/build.gradle.kts:
```
android {
    namespace = "com.simplytools.simplynet"  // Change this
}
```

Android - android/app/src/main/AndroidManifest.xml:
```
android {
    namespace = "com.simplytools.simplynet"  // Change this
}
```

iOS - ios/Runner.xcodeproj/project.pbxproj:
Search for bundle identifier and update:
```
PRODUCT_BUNDLE_IDENTIFIER = com.simplytools.simplynet;
```

Or in Xcode: Runner → Build Settings → Product Bundle Identifier

3. Developer Account (Store-side, not code)
Google Play: Create/use a Google Play Developer account registered to "SimplyTools"
App Store: Create/use an Apple Developer account for "SimplyTools"
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
description: "Network toolkit by SimplyTools"
author: "SimplyTools"
homepage: "https://quantumsatis.com"  # Update if applicable
```

Checklist before publishing:
- [] Update app display name everywhere
- [] Change package name to com.simplytools.simplynet (or similar)
- [] Update app icons/branding assets
- [] Update pubspec.yaml metadata
- [] Update iOS bundle ID
- [] Create store accounts under "SimplyTools"
- [] Write app store descriptions/marketing copy
- [] Generate signing certificates/keys for both platforms

Pro tip: Use `flutter rename` package to automate some of this:
```
dart pub global activate rename
rename --appname "SymplyNet" --bundleId com.simplytools.simplynet
```

Then verify all changes manually before submitting to stores!

# Publish on Google play

Adapted for Kotlin from: https://dev.to/teerasej/step-by-step-to-publish-your-flutter-project-as-andriod-app-bundle-1bpe

## 1. Create your Keystore
Keystore is the file you should have to sign your AAB file.

Run the following command in Terminal at **your project's root directory**.

`keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`

After entering this command, you will be asked to fill key's password and some information.

## 2. Create a reference file to Keystore
Create a file named `key.properties` at `[project root]/android/`

```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=../upload-keystore.jks
```

## 3. Modify app/build.gradle
Now, we have to modify build.gradle. So Flutter can use it to sign and generate an AAB file.

### Load keystore's properties
Open `[project]/android/app/build.gradle.kts`, look for android block, and put following code at the top of its.

```
import java.io.FileInputStream
import java.util.Properties

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

### Replace buildTypes block
find buildTypes and signingConfigs blocks. replace them with following code:

```
    signingConfigs {
        create("release") {
            val storeFileProp = keystoreProperties.getProperty("storeFile")
            storeFile = if (storeFileProp != null) file(storeFileProp) else null
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    buildTypes {
        getByName("release") {
            // Tells Gradle to use the release signing config defined above
            signingConfig = signingConfigs.getByName("release")
            
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
```

## 4. Let's sign and build the release version
Match JDK with Gradle: On a standard Windows installation, Android Studio includes a stable JetBrains Java Runtime (jbr). It is usually located at:
`C:\Program Files\Android\Android Studio\jbr`

`flutter config --jdk-dir="C:\Program Files\Android\Android Studio\jbr"`

After you modified `build.gradle.kts` file, you should run:

```
flutter clean
flutter pub get
flutter build appbundle
```

If the build has been successful, you will see the AAB's file path on the Terminal's console.


# TODO
* Enhance device detection list: qnap, fritz, eero, samsung mobile, redmi mobile, huawei mobile, espressif, hui zhou camera reolin dahua, 

