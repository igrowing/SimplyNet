pluginManagement {
    val flutterSdkPath = run {
        // CI sets FLUTTER_ROOT; local dev uses local.properties
        val fromEnv = System.getenv("FLUTTER_ROOT")
        if (!fromEnv.isNullOrBlank()) {
            fromEnv
        } else {
            val properties = java.util.Properties()
            val localPropsFile = file("local.properties")
            if (localPropsFile.exists()) {
                localPropsFile.inputStream().use { properties.load(it) }
            }
            val fromProps = properties.getProperty("flutter.sdk")
            require(!fromProps.isNullOrBlank()) {
                "flutter.sdk not set. Either set FLUTTER_ROOT env var or add flutter.sdk to local.properties"
            }
            fromProps
        }
    }


    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
}

include(":app")
