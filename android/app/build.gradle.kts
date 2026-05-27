plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.simplynet.app"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.simplynet.app"
        minSdk        = flutter.minSdkVersion
        targetSdk     = flutter.targetSdkVersion
        versionCode   = flutter.versionCode
        versionName   = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val storeFile0 = System.getenv("KEYSTORE_PATH")
            val storePass  = System.getenv("STORE_PASSWORD")
            val keyAlias0  = System.getenv("KEY_ALIAS")
            val keyPass    = System.getenv("KEY_PASSWORD")
            if (!storeFile0.isNullOrBlank() && !storePass.isNullOrBlank()) {
                storeFile     = file(storeFile0)
                storePassword = storePass
                keyAlias      = keyAlias0
                keyPassword   = keyPass
            }
        }
    }

    buildTypes {
        release {
            val releaseCfg = signingConfigs.getByName("release")
            signingConfig = if (releaseCfg.storeFile != null) releaseCfg
                            else signingConfigs.getByName("debug")

            // R8 code shrinking + resource shrinking.
            // AGP 9+ requires isMinifyEnabled=true whenever shrinkResources=true.
            // For Flutter apps the R8 rules are generated automatically; we add
            // a consumer rules file for any custom keep-rules we need.
            isMinifyEnabled   = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            isMinifyEnabled   = false
            isShrinkResources = false
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
