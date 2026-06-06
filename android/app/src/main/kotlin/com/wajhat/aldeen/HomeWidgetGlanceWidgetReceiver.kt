package com.wajhat.aldeen

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context

/**
 * Base class for Glance-based home widget receivers.
 * The actual widget content is handled by IslamicGlanceWidget via home_widget plugin.
 */
abstract class HomeWidgetGlanceWidgetReceiver<T : Any> : AppWidgetProvider() {
    abstract val glanceAppWidget: T

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        super.onUpdate(context, appWidgetManager, appWidgetIds)
    }
}
