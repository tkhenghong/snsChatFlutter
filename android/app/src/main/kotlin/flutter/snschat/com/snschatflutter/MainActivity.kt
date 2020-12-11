package flutter.snschat.com.snschatflutter

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val TAG = "DefaultPlugin"
    private val CHANNEL = "DefaultChannel"


    @RequiresApi(Build.VERSION_CODES.O)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            // Note: this method is invoked on the main thread.
            when (call.method) {
                "default" -> {
                    Log.i(TAG, "Native Android call works.: ")
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
