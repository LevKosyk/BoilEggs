package com.levkosyk.boileggs
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
class BoilEggsWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            val status = widgetData.getString("status", "Idle")
            val doneness = widgetData.getString("doneness", "--")
            val endTimestamp = widgetData.getLong("end_timestamp", 0)
            views.setTextViewText(R.id.widget_status, status)
            if (status == "boiling" && endTimestamp > 0) {
                views.setChronometer(R.id.widget_timer, endTimestamp, null, true)
                if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                     views.setChronometerCountDown(R.id.widget_timer, true)
                }
                views.setTextViewText(R.id.widget_title, "Boiling: $doneness")
            } else {
                views.setTextViewText(R.id.widget_timer, "--:--")
                views.setChronometer(R.id.widget_timer, 0, null, false)  
                views.setTextViewText(R.id.widget_title, "Boil Eggs")
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
