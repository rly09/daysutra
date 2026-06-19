package com.example.daysutra

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import android.graphics.BitmapFactory
import android.view.View
import android.net.Uri
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent

class InspirationWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.inspiration_widget_layout).apply {
                val isDark = widgetData.getBoolean("is_dark_theme", false)
                val backgroundRes = if (isDark) R.drawable.widget_background_dark else R.drawable.widget_background_light
                setInt(R.id.widget_container, "setBackgroundResource", backgroundRes)

                val titleColor = if (isDark) 0xFFF3F0EE.toInt() else 0xFF141413.toInt()
                val subtitleColor = if (isDark) 0xFF9E9E9E.toInt() else 0xFF696969.toInt()
                setTextColor(R.id.fallback_title, titleColor)
                setTextColor(R.id.fallback_subtitle, subtitleColor)

                val imagePath = widgetData.getString("inspiration_widget_image", null)
                if (imagePath != null) {
                    val bitmap = BitmapFactory.decodeFile(imagePath)
                    if (bitmap != null) {
                        setImageViewBitmap(R.id.widget_image, bitmap)
                        setViewVisibility(R.id.widget_image, View.VISIBLE)
                        setViewVisibility(R.id.widget_fallback, View.GONE)
                    } else {
                        setViewVisibility(R.id.widget_image, View.GONE)
                        setViewVisibility(R.id.widget_fallback, View.VISIBLE)
                        setTextViewText(R.id.fallback_title, "Inspiration")
                        setTextViewText(R.id.fallback_subtitle, "Open app to configure")
                    }
                } else {
                    setViewVisibility(R.id.widget_image, View.GONE)
                    setViewVisibility(R.id.widget_fallback, View.VISIBLE)
                    setTextViewText(R.id.fallback_title, "Inspiration")
                    setTextViewText(R.id.fallback_subtitle, "Open app to configure")
                }

                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java,
                    Uri.parse("daysutra://inspiration")
                )
                setOnClickPendingIntent(R.id.widget_container, pendingIntent)
            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
