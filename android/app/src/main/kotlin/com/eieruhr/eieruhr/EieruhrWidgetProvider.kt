package com.eieruhr.eieruhr

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.app.PendingIntent
import android.content.SharedPreferences
import android.view.View

/** Home screen widget provider for the Eieruhr timer. */
class EieruhrWidgetProvider : AppWidgetProvider() {

    companion object {
        const val ACTION_START_TIMER = "com.eieruhr.eieruhr.ACTION_START_TIMER"
        const val ACTION_STOP_TIMER = "com.eieruhr.eieruhr.ACTION_STOP_TIMER"
        const val EXTRA_PRESET_NAME = "preset_name"
        const val EXTRA_PRESET_DURATION = "preset_duration"
        const val PREFS_NAME = "EieruhrWidgetPrefs"
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)

        when (intent.action) {
            ACTION_START_TIMER -> {
                val presetName = intent.getStringExtra(EXTRA_PRESET_NAME) ?: return
                val duration = intent.getIntExtra(EXTRA_PRESET_DURATION, 0)
                // Reason: Launch the main Flutter app with timer start parameters.
                val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                launchIntent?.apply {
                    putExtra(EXTRA_PRESET_NAME, presetName)
                    putExtra(EXTRA_PRESET_DURATION, duration)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(launchIntent)
            }
            ACTION_STOP_TIMER -> {
                // Reason: Launch the main Flutter app with stop action.
                val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                launchIntent?.apply {
                    putExtra("action", "stop")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(launchIntent)
            }
        }
    }

    private fun updateWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.widget_layout)

        // Read presets from SharedPreferences (set by Flutter via home_widget).
        val prefs = context.getSharedPreferences("HomeWidgetPreferences", Context.MODE_PRIVATE)
        val preset1Name = prefs.getString("preset_0_name", "Eier") ?: "Eier"
        val preset1Duration = prefs.getInt("preset_0_duration", 380)
        val preset2Name = prefs.getString("preset_1_name", "Brot") ?: "Brot"
        val preset2Duration = prefs.getInt("preset_1_duration", 1800)

        // Set button labels.
        views.setTextViewText(R.id.widget_button_1, preset1Name)
        views.setTextViewText(R.id.widget_button_2, preset2Name)

        // Set up pending intents for button clicks.
        views.setOnClickPendingIntent(
            R.id.widget_button_1,
            createStartTimerIntent(context, preset1Name, preset1Duration)
        )
        views.setOnClickPendingIntent(
            R.id.widget_button_2,
            createStartTimerIntent(context, preset2Name, preset2Duration)
        )

        // Stop button.
        views.setOnClickPendingIntent(
            R.id.widget_stop_button,
            createStopTimerIntent(context)
        )

        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun createStartTimerIntent(
        context: Context,
        presetName: String,
        duration: Int
    ): PendingIntent {
        val intent = Intent(context, EieruhrWidgetProvider::class.java).apply {
            action = ACTION_START_TIMER
            putExtra(EXTRA_PRESET_NAME, presetName)
            putExtra(EXTRA_PRESET_DURATION, duration)
        }
        return PendingIntent.getBroadcast(
            context,
            presetName.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }

    private fun createStopTimerIntent(context: Context): PendingIntent {
        val intent = Intent(context, EieruhrWidgetProvider::class.java).apply {
            action = ACTION_STOP_TIMER
        }
        return PendingIntent.getBroadcast(
            context,
            0,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}
