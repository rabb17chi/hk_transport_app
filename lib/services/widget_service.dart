import 'package:home_widget/home_widget.dart';
import 'package:flutter/material.dart';
import '../scripts/kmb/kmb_cache_service.dart';

class WidgetService {
  static const String _widgetName = 'KMBWidgetProvider';

  /// Initialize the widget service
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId('group.com.example.hk_transport_app');
  }

  /// Update KMB widget with route information
  static Future<void> updateKMBWidget({
    String? route,
    String? destination,
    String? eta,
    String? time,
    String? bound,
    String? serviceType,
  }) async {
    try {
      // Set default values if not provided
      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final routeData = route ?? 'No Route';
      final destinationData = destination ?? 'No Destination';
      final etaData = eta ?? 'No ETA';
      final timeData = time ?? currentTime;
      final boundData = bound ?? 'N/A';
      final serviceTypeData = serviceType ?? 'N/A';

      debugPrint('Saving widget data:');
      debugPrint('  Route: $routeData');
      debugPrint('  Destination: $destinationData');
      debugPrint('  ETA: $etaData');
      debugPrint('  Time: $timeData');
      debugPrint('  Bound: $boundData');
      debugPrint('  Service Type: $serviceTypeData');

      await HomeWidget.saveWidgetData<String>('kmb_route', routeData);
      await HomeWidget.saveWidgetData<String>(
          'kmb_destination', destinationData);
      await HomeWidget.saveWidgetData<String>('kmb_eta', etaData);
      await HomeWidget.saveWidgetData<String>('kmb_time', timeData);
      await HomeWidget.saveWidgetData<String>('kmb_bound', boundData);
      await HomeWidget.saveWidgetData<String>(
          'kmb_service_type', serviceTypeData);

      // Update the widget
      await HomeWidget.updateWidget(name: _widgetName);

      debugPrint('KMB Widget updated successfully');
    } catch (e) {
      debugPrint('Error updating KMB widget: $e');
    }
  }

  /// Update widget with favorite KMB route data
  static Future<void> updateWithFavoriteRoute() async {
    try {
      // Get favorite routes from cache
      final routes = await KMBCacheService.getCachedRoutes();
      if (routes != null && routes.isNotEmpty) {
        final favoriteRoute = routes.first; // Use first route as favorite

        await updateKMBWidget(
          route: favoriteRoute.route,
          destination: favoriteRoute.destTc,
          eta: 'Next: 5 mins', // This would come from ETA API
          time: DateTime.now().toString().substring(11, 16),
        );
      } else {
        await updateKMBWidget(
          route: 'No Routes',
          destination: 'Add favorites in app',
          eta: 'No ETA',
        );
      }
    } catch (e) {
      debugPrint('Error updating widget with favorite route: $e');
    }
  }

  /// Update widget with MTR station data
  static Future<void> updateMTRWidget({
    String? station,
    String? line,
    String? nextTrain,
    String? time,
  }) async {
    try {
      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      await HomeWidget.saveWidgetData<String>(
          'mtr_station', station ?? 'No Station');
      await HomeWidget.saveWidgetData<String>('mtr_line', line ?? 'No Line');
      await HomeWidget.saveWidgetData<String>(
          'mtr_next_train', nextTrain ?? 'No Train');
      await HomeWidget.saveWidgetData<String>('mtr_time', time ?? currentTime);

      await HomeWidget.updateWidget(name: _widgetName);

      debugPrint('MTR Widget updated successfully');
    } catch (e) {
      debugPrint('Error updating MTR widget: $e');
    }
  }

  /// Clear all widget data
  static Future<void> clearWidgetData() async {
    try {
      await HomeWidget.saveWidgetData<String>('kmb_route', '');
      await HomeWidget.saveWidgetData<String>('kmb_destination', '');
      await HomeWidget.saveWidgetData<String>('kmb_eta', '');
      await HomeWidget.saveWidgetData<String>('kmb_time', '');

      await HomeWidget.updateWidget(name: _widgetName);

      debugPrint('Widget data cleared');
    } catch (e) {
      debugPrint('Error clearing widget data: $e');
    }
  }

  /// Test method to save simple data
  static Future<void> testWidget() async {
    try {
      debugPrint('Testing widget with simple data...');

      await HomeWidget.saveWidgetData<String>('kmb_route', 'TEST');
      await HomeWidget.saveWidgetData<String>(
          'kmb_destination', 'Test Destination');
      await HomeWidget.saveWidgetData<String>('kmb_eta', 'Test ETA');
      await HomeWidget.saveWidgetData<String>('kmb_time', '12:34');

      await HomeWidget.updateWidget(name: _widgetName);

      debugPrint('Test widget data saved successfully');
    } catch (e) {
      debugPrint('Error testing widget: $e');
    }
  }
}
