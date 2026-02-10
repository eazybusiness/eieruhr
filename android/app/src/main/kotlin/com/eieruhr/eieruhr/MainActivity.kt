package com.eieruhr.eieruhr

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/** MainActivity that bridges Android intent extras to Flutter via MethodChannel. */
class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.eieruhr.eieruhr/intent"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getLaunchIntent") {
                    val presetName = intent.getStringExtra("preset_name")
                    val presetDuration = intent.getIntExtra("preset_duration", 0)
                    if (presetName != null && presetDuration > 0) {
                        val map = HashMap<String, Any>()
                        map["preset_name"] = presetName
                        map["preset_duration"] = presetDuration
                        // Reason: Clear extras so re-opening the app doesn't re-trigger.
                        intent.removeExtra("preset_name")
                        intent.removeExtra("preset_duration")
                        result.success(map)
                    } else {
                        result.success(null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}
