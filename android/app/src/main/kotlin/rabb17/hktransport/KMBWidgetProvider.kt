package rabb17.hktransport

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import java.io.File

class KMBWidgetProvider : AppWidgetProvider() {
    
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val views = RemoteViews(context.packageName, R.layout.kmb_widget)

        // List all available SharedPreferences files for debugging
        val prefsDir = File(context.applicationInfo.dataDir, "shared_prefs")
        val prefFiles = prefsDir.listFiles()?.map { it.name } ?: emptyList()
        android.util.Log.d("KMBWidget", "Available SharedPreferences files: $prefFiles")

        // Try to get data from HomeWidget using the correct method
        var route = "N/A"
        var destination = "N/A"
        var eta = "N/A"
        var time = "N/A"

        try {
            // Use HomeWidget's built-in method to get data
            val homeWidgetData = es.antonborri.home_widget.HomeWidgetPlugin.getData(context)
            route = homeWidgetData.getString("kmb_route", "N/A") ?: "N/A"
            destination = homeWidgetData.getString("kmb_destination", "N/A") ?: "N/A"
            eta = homeWidgetData.getString("kmb_eta", "N/A") ?: "N/A"
            time = homeWidgetData.getString("kmb_time", "N/A") ?: "N/A"
            
            android.util.Log.d("KMBWidget", "Data from HomeWidget.getData():")
            android.util.Log.d("KMBWidget", "  Route: $route")
            android.util.Log.d("KMBWidget", "  Destination: $destination")
            android.util.Log.d("KMBWidget", "  ETA: $eta")
            android.util.Log.d("KMBWidget", "  Time: $time")
        } catch (e: Exception) {
            android.util.Log.e("KMBWidget", "Error getting data from HomeWidget: ${e.message}")
            
            // Fallback: try all possible SharedPreferences files
            val sharedPrefs1 = context.getSharedPreferences("HomeWidgetProvider", Context.MODE_PRIVATE)
            val sharedPrefs2 = context.getSharedPreferences("group.rabb17.hktransport", Context.MODE_PRIVATE)
            val sharedPrefs3 = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val sharedPrefs4 = context.getSharedPreferences("home_widget", Context.MODE_PRIVATE)
            val sharedPrefs5 = context.getSharedPreferences("es.antonborri.home_widget", Context.MODE_PRIVATE)

            route = sharedPrefs1.getString("kmb_route", 
                      sharedPrefs2.getString("kmb_route",
                      sharedPrefs3.getString("kmb_route",
                      sharedPrefs4.getString("kmb_route",
                      sharedPrefs5.getString("kmb_route", "N/A"))))) ?: "N/A"
            destination = sharedPrefs1.getString("kmb_destination",
                             sharedPrefs2.getString("kmb_destination",
                             sharedPrefs3.getString("kmb_destination",
                             sharedPrefs4.getString("kmb_destination",
                             sharedPrefs5.getString("kmb_destination", "N/A"))))) ?: "N/A"
            eta = sharedPrefs1.getString("kmb_eta",
                    sharedPrefs2.getString("kmb_eta",
                    sharedPrefs3.getString("kmb_eta",
                    sharedPrefs4.getString("kmb_eta",
                    sharedPrefs5.getString("kmb_eta", "N/A"))))) ?: "N/A"
            time = sharedPrefs1.getString("kmb_time",
                     sharedPrefs2.getString("kmb_time",
                     sharedPrefs2.getString("kmb_time",
                     sharedPrefs4.getString("kmb_time",
                     sharedPrefs5.getString("kmb_time", "N/A"))))) ?: "N/A"

            android.util.Log.d("KMBWidget", "Fallback data:")
            android.util.Log.d("KMBWidget", "  Route: $route")
            android.util.Log.d("KMBWidget", "  Destination: $destination")
            android.util.Log.d("KMBWidget", "  ETA: $eta")
            android.util.Log.d("KMBWidget", "  Time: $time")
        }
        
        // Update widget views
        views.setTextViewText(R.id.kmb_widget_route, route)
        views.setTextViewText(R.id.kmb_widget_destination, destination)
        views.setTextViewText(R.id.kmb_widget_eta, eta)
        views.setTextViewText(R.id.kmb_widget_time, time)
        
        // Set up click intents
        val intent = HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            Uri.parse("home_widget_example://home_widget_deep_link")
        )
        views.setOnClickPendingIntent(R.id.kmb_widget_route, intent)
        
        // Refresh button
        val refreshIntent = HomeWidgetBackgroundIntent.getBroadcast(
            context,
            Uri.parse("home_widget_example://refresh_widget")
        )
        views.setOnClickPendingIntent(R.id.kmb_widget_refresh, refreshIntent)
        
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
