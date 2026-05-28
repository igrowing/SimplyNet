package com.simplynet.app

import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.simplynet.app/screen"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "setScreenTimeout") {
                    val mode = call.argument<Int>("mode") ?: 0
                    when (mode) {
                        // 0 = system (clear keep-screen-on flag)
                        0 -> window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        // 1 = system*3 — we just keep screen on; true "3x system timeout"
                        //     would require DevicePolicyManager which needs admin rights.
                        //     Keeping screen on is the closest practical equivalent.
                        1 -> window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        // 2 = stay on indefinitely
                        2 -> window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                        else -> window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    }
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
