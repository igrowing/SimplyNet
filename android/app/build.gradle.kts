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
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Credentials injected from environment variables by CI.
            // For local builds, set these in your shell or use a local keystore.
            val storeFile0 = System.getenv("KEYSTORE_PATH")
            val storePass  = System.getenv("STORE_PASSWORD")
            val keyAlias0  = System.getenv("KEY_ALIAS")
            val keyPass    = System.getenv("KEY_PASSWORD")
            if (!storeFile0.isNullOrBlank() && !storePass.isNullOrBlank()) {
                storeFile = file(storeFile0)
                storePassword = storePass
                keyAlias = keyAlias0
                keyPassword = keyPass
            }
        }
    }

    buildTypes {
        release {
            // Use release signing if the keystore is available; fall back to
            // debug only for local/branch builds where the secret is absent.
            val releaseCfg = signingConfigs.getByName("release")
            signingConfig = if (releaseCfg.storeFile != null) releaseCfg
                            else signingConfigs.getByName("debug")
            isMinifyEnabled = false
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
