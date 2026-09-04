# Update app icon
**Step 1 — Create padded foreground PNG**

Open `assets/simplynet.png` in any image editor (GIMP, Photoshop, Affinity Photo).
- Canvas must be **1024×1024** (or any square)
- Resize the artwork DOWN to **66% of canvas** (≈680px in a 1024 canvas)
- Center it, leave 17% transparent padding on all four sides
- Save as `assets/simplynet_fg.png` (PNG with transparency)

**Step 2 — Create transparent background PNG**

Create a 1024×1024 fully transparent PNG and save as `assets/icon_bg.png`.
(Or use your brand color — just make sure the artwork edges don't bleed over it.)

**Step 3 - configure Flutter**

In root folder of the project create `flutter_launcher_icons.yaml` with content (adapt for your icon names):

```
flutter_launcher_icons:
  android: true                     # generates ic_launcher and related res
  adaptive_icon_background: "assets/icon_bg.png"    # transparent PNG
  adaptive_icon_foreground: "assets/simplynet_fg.png"  # artwork with 20% padding
  image_path_android: "assets/simplynet_fg.png"
  ios: true
  image_path_ios: "assets/simplynet.png"
  min_sdk_android: 21
  web:
    generate: false
```

Add to `pubspec.yaml` in `dev_dependencies:` section:

```
  flutter_launcher_icons: ^0.14.4
```

**Step 4 — Regenerate icons**

```bash
flutter pub run flutter_launcher_icons:main
```

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
homepage: "https://github.com/igrowing/SimplyNet"  # Update if applicable
```

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
Refer to **Update app icon** chapter.


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
dart pub global run rename setAppName --value "SimplyNet"           
dart pub global run rename setBundleId --value "com.simplytools.simplynet"  
```

Then verify all changes manually before submitting to stores!


# Publishing

## Phase 1: Account Creation & Identity Verification
Google has implemented strict verification security to combat malicious apps.

### Sign Up & Profile Setup:

* Go to the Google Play Console Signup page.
* Log in with a Google account that has Two-Step Verification (2SV) enabled.
* Select Personal Account (Individual).
* Fill out your public developer name (the name visible on the Play Store) and your contact details.
* Pay the Fee: the one-time $25 USD registration.

Important: Ensure the billing address on your credit or debit card matches the country you selected for your developer account, or the transaction may be flagged.

### Submit Verification Documents:

* Google will prompt you to verify your identity. You will need to upload a high-quality photo of a government-issued ID (Passport or National ID card).
* You may also be asked to provide proof of address (such as a utility bill or bank statement less than 3 months old).
* Google typically takes 2 to 4 weeks to fully review and verify new accounts, though individual verifications often process within a few days. Do not try to upload builds until this status shows as completely verified.

## Phase 2: The App Shell & Store Setup
Once verified, you will create the virtual space where your app code lives.

* Create a New App:
  * In the Play Console dashboard, click Create app.
  * Enter your app name, select the default language, and specify that it is an App (not a game) and that it is Free.
* Complete the Initial Dashboard Tasks:
  * Google provides a checklist on the main dashboard called "Set up your app". You cannot skip this.
  * Privacy Policy: Provide a live, public URL to your app's privacy policy. (Since your project is open-source, hosting a standard privacy policy markdown file on GitHub Pages is a common and accepted method).
  * App Content Declarations: Fill out the extensive questionnaires regarding Ads (declare "No ads"), Content Ratings (to get an age rating), Target Audience, and Data Safety (disclose exactly what data your app collects or transmits).

## Phase 3: The 14-Day Closed Testing Gauntlet
For personal accounts, Google disables the "Production" track out of the box. You are required to run an internal test to prove your application's stability.

* Create a Closed Testing Track:
  * In the left menu, navigate to Testing > Closed testing.
  * Create a new track (usually called "Closed Alpha").
* Upload the First Signed Build:
  * Create a new release within your closed testing track and upload your signed .aab file (which you built via GitHub Actions using the dynamic signature insertion or download method).
  * Provide brief release notes and submit the release. Note: Even your very first closed testing build must pass a brief automated Google policy check before testers can download it.
* Recruit Your Testers:
  * Under the closed track's "Testers" tab, create an email list.
  * Google's strict requirement is that you must have at least 12 unique, real testers continuously opted-in.
  * Strategy tip: Recruit 16 to 20 testers instead. If one person drops out, uninstalls the app, or switches devices midway through, the 14-day clock resets. You can find testers by leveraging open-source forums, developer subreddits (like r/AndroidClosedTesting), or communities designed for mutual developer testing.
* The 14-Day Opt-In Countdown:
  * Grab the unique web opt-in link provided by the Play Console and send it to your testers.
  * Testers must click the link, accept the invite via their Google account, and install the app directly from the Play Store onto their physical Android device.
  * The clock starts only when your 12th tester installs the app. They must keep the app installed on their phones for 14 continuous days. You can push updates to the track during this time if you fix bugs, which actually demonstrates positive development activity to Google.

## Phase 4: Production Application & Final Launch
* Apply for Production Access:
  * Once the 14-day milestone is met perfectly, the Apply for Production button will unlock on your console dashboard.
  * You must fill out a formal written application containing three core questions:
  * How did you recruit your testers? (e.g., "Recruited via community forums and alpha testing channels").
  * What feedback did you receive? (Detail any bugs found, layout issues, or performance comments).
  * What fixes/improvements did you make? (Explain the updates you pushed during the 14 days based on that feedback).
  * Google's review team will evaluate your answers and testing metrics. This review takes about 2 to 7 days.
* Go Live to the Public:
  * Once approved, the Production track on your left-hand menu will finally light up.
  * Go to Production, click Create new release, and select the .aab bundle that was successfully vetted in your testing track.
  * Click Review release, and then click Start rollout to Production.
  * Your app will undergo one final, standard policy review. Within a few days, your app will be officially searchable and downloadable by anyone worldwide on the Google Play Store.

## Phase 5: Maintaining the Store Listing

### How to update the app description
* In the Play Console, open your app and go to Grow > Store presence > Main store listing.
* The default listing (short description, full description, app name) applies to the language selected at the top of the page.
* To update a translated description, use the language dropdown at the top of the Main store listing page and switch to the target locale before editing — each locale's copy is stored independently.
* To add a locale that doesn't exist yet, click Manage translations > Add your own translation (or Add translations via a translation service), pick the language, and Play Console will scaffold empty fields for that locale's title/short/full description.
* Keep translated copy in sync with `lib/l10n/` locale coverage — if a locale ships in-app but has no store listing translation, Play Store falls back to the default language listing for that locale.
* Click Save, then Save as draft or Publish (a store-listing-only change like this does not require a new app binary/release).

### How to update app screenshots
* In the same Main store listing page (per-locale, same language dropdown as above), scroll to the Phone/Tablet/Graphics section.
* Screenshots are also per-locale: switch the language dropdown before uploading/removing images so you don't overwrite the wrong locale's set.
* Requirements: PNG or JPEG, 16:9 or 9:16 aspect ratio, min 320px and max 3840px on the longer side; at least 2 phone screenshots are required (Google recommends 4-8).
* Remove outdated screenshots first (hover > trash icon), then drag-and-drop or click Upload to add the new ones in the order you want them displayed.
* Click Save, then Save as draft or Publish. Screenshot/graphics updates, like description updates, go live without needing a new app bundle release.


# Build signed app bundle locally

Adapted for Kotlin from: https://dev.to/teerasej/step-by-step-to-publish-your-flutter-project-as-andriod-app-bundle-1bpe

## 1. Create your Keystore
Keystore is the file you should have to sign your AAB file.

Run the following command in Terminal (NOT PowerShell!) at **your project's root directory**.

`keytool.exe -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`

After entering this command, you will be asked to fill key's password and some information.

## 2. Create a reference file to Keystore
Create a file named `key.properties` at `[project root]/android/`

```
storePassword=<password from previous step>
keyPassword=<password from previous step>
keyAlias=upload
storeFile=../../upload-keystore.jks
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

## 4. Add environment files
Must have:
- android\app\proguard-rules.pro
Copy it from project to ptoject.


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

Add `kotlin.incremental=false` at the bottom of `android/gradle.properties`.

After you modified `build.gradle.kts` file, you should run:

```
flutter clean
flutter pub get
flutter build appbundle
```

If the build has been successful, you will see the AAB's file path on the Terminal's console.

# Build signed app bundle in Github:

## Step A: Convert your Keystore to Base64
Open a terminal on your local PC, navigate to the folder where your upload-keystore.jks file is stored, and run this command to turn it into a text string:

On Windows (PowerShell): 
`[Convert]::ToBase64String([IO.File]::ReadAllBytes("upload-keystore.jks")) | Out-File -FilePath keystore_base64.txt`

On Mac/Linux:
`base64 -i upload-keystore.jks -o keystore_base64.txt`

Open the generated keystore_base64.txt file and copy the massive block of text inside it.

## Step B: Add Secrets to GitHub
Go to your GitHub Repository -> Settings -> Secrets and variables -> Actions.

Click `New repository secret` and add the following four secrets:

* `ANDROID_KEYSTORE_BASE64`: Paste the entire content of keystore_base64.txt.
* `ANDROID_KEYSTORE_PASSWORD`: The password for your keystore.
* `ANDROID_KEY_ALIAS`: The alias name you chose (e.g., upload).
* `ANDROID_KEY_PASSWORD`: The password for your key.

## Step C: Update your GitHub Actions Workflow
In your `.github/workflows/` YAML file, insert a step right before your flutter build appbundle command. This step takes the secrets, decodes the keystore file, and dynamically generates the key.properties file inside the runner.

```
      - name: Configure Android Keystore
        run: |
          # 1. Decode the keystore file from the secret back into a binary file
          echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 --decode > android/app/upload-keystore.jks
          
          # 2. Dynamically create the key.properties file
          echo "storeFile=upload-keystore.jks" > android/key.properties
          echo "storePassword=${{ secrets.ANDROID_KEYSTORE_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}" >> android/key.properties
          echo "keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}" >> android/key.properties

      - name: Build Flutter AAB
        run: flutter build appbundle --release
```

When the GitHub runner finishes its job, the virtual environment is completely destroyed, leaving no trace of your keys or passwords behind. You get a fully signed, production-ready `.aab` file ready for Google Play without risking your security.


## Run the app in Chrome on PC:
```
flutter run -d chrome
```



# TODO
* Enhance device detection list: qnap, fritz, eero, samsung mobile, redmi mobile, huawei mobile, espressif, hui zhou camera reolin dahua, 
* Add Snmp mib browser
* Add more MQ: rabbitmq, zmq, kafka, amazon sqs, google cloud pub/sub

