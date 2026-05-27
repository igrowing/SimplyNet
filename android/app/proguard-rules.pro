# ─── SimplyNet ProGuard / R8 rules ───────────────────────────────────────────
#
# Flutter & the Flutter Gradle plugin generate rules automatically for:
#   • Flutter engine classes
#   • dart2java bridge methods
# So most things Just Work.  Add explicit rules only for libraries that use
# reflection, JNI, or dynamic class loading.

# ── Kotlin ────────────────────────────────────────────────────────────────────
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod

# ── network_info_plus ─────────────────────────────────────────────────────────
# Android WifiManager / NetworkInterface accessed via reflection on some devices
-keep class dev.fluttercommunity.plus.** { *; }

# ── permission_handler ────────────────────────────────────────────────────────
-keep class com.baseflow.permissionhandler.** { *; }

# ── Shared Preferences ───────────────────────────────────────────────────────
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ── path_provider ─────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.pathprovider.** { *; }

# ── url_launcher ──────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.urllauncher.** { *; }

# ── Keep Dart → Java bridge entry points (R8 may otherwise inline them) ──────
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.common.** { *; }

# ── Preserve line numbers in crash stack traces ───────────────────────────────
-keepattributes SourceFile, LineNumberTable
-renamesourcefileattribute SourceFile
