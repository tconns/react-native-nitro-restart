package com.margelo.nitro.restart

import android.content.Context
import android.content.Intent
import android.util.Log
import com.facebook.proguard.annotations.DoNotStrip
import com.margelo.nitro.NitroModules
import android.os.Process
import android.app.Activity
import com.facebook.react.bridge.ReactContext
import android.os.Handler
import android.os.Looper

@DoNotStrip
class NitroRestart : HybridNitroRestartSpec() {
  private val applicationContext: Context? = NitroModules.applicationContext
  private val mainHandler = Handler(Looper.getMainLooper())
  
  private fun getCurrentActivity(): Activity? {
    return try {
      val reactContext = applicationContext as? ReactContext
      reactContext?.currentActivity
    } catch (e: Exception) {
      Log.w("NitroRestart", "Unable to get current activity: ${e.message}")
      null
    }
  }

  override fun getPid(): Double {
    return Process.myPid().toDouble()
  }

  override fun restartApp(moduleName: String) {
    val appContext = applicationContext
    if (appContext == null) {
      Log.e("NitroRestart", "Cannot restart app: applicationContext is null")
      return
    }

    try {
      mainHandler.post {
        val packageManager = appContext.packageManager
        val intent = packageManager.getLaunchIntentForPackage(appContext.packageName)
        if (intent != null) {
          intent.addFlags(
            Intent.FLAG_ACTIVITY_NEW_TASK or
              Intent.FLAG_ACTIVITY_CLEAR_TASK or
              Intent.FLAG_ACTIVITY_CLEAR_TOP
          )
          appContext.startActivity(intent)
          getCurrentActivity()?.finishAffinity()
        } else {
          Log.e("NitroRestart", "Cannot restart app: launch intent is null")
        }
      }
    } catch (e: Exception) {
      Log.e("NitroRestart", "Error restarting app: ${e.message}")
    }
  }

  override fun restartCurrentApp() {
    restartApp("")
  }

  override fun exitApp() {
    // Note: Killing the process violates Google Play policies
    // This implementation moves the app to background instead
    val activity = getCurrentActivity()
    if (activity == null) {
      Log.e("NitroRestart", "Cannot exit app: Activity is null")
      return
    }

    try {
      Handler(Looper.getMainLooper()).post {
        // Move app to background (safer than killing process)
        activity.moveTaskToBack(true)
        // Optionally finish the activity
        activity.finishAffinity()
      }
    } catch (e: Exception) {
      Log.e("NitroRestart", "Error exiting app: ${e.message}")
    }
  }

  override fun canExitApp(): Boolean {
    return true
  }
}
