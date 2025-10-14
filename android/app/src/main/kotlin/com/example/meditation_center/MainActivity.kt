package com.example.meditation_center

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.channel.shared.data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "share") {
                val text = call.argument<String>("text") ?: ""
                val url = call.argument<String>("url") ?: ""

                val intent = Intent(Intent.ACTION_SEND)
                intent.type = "text/plain"
                intent.putExtra(Intent.EXTRA_TEXT, "$text $url")
                startActivity(Intent.createChooser(intent, "Share via"))

                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }
}
