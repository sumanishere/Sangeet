package com.suman.sangeet

import MainActivity
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
 
class SangeetMusicWidget : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
}

internal fun updateAppWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int) {
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.black_hole_music_widget)

    // val intent = Intent(context, MainActivity::class.java);
    val intent = Intent(Intent.ACTION_VIEW, Uri.parse("app://sangeet/play"))

    // val intent = Intent(Intent.ACTION_VIEW)
    // intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

    val pendingIntent = PendingIntent.getActivity(context, 0, intent, 0)
    views.setOnClickPendingIntent(R.id.button_play_pause, pendingIntent)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}