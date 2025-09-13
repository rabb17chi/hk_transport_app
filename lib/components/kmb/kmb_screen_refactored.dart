import 'package:flutter/material.dart';
import 'package:hk_transport_app/components/kmb/bookmarked_route_n_station.dart';
import '../../scripts/kmb_api_service.dart';
import '../../scripts/kmb_cache_service.dart';
import 'route_selector.dart';

class KMBTestScreenRefactored extends StatefulWidget {
  const KMBTestScreenRefactored({super.key});

  @override
  State<KMBTestScreenRefactored> createState() =>
      _KMBTestScreenRefactoredState();
}

class _KMBTestScreenRefactoredState extends State<KMBTestScreenRefactored> {
  List<KMBRoute> _routes = [];
  List<KMBStop> _stops = [];

  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedRouteKey = ''; // Changed to store routeKey (route + bound)
  Map<String, dynamic> _cacheInfo = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final routes = await KMBApiService.getAllRoutes();
      final stops = await KMBApiService.getAllStops();
      final cacheInfo = await KMBCacheService.getCacheInfo();

      setState(() {
        _routes = routes;
        _stops = stops;
        _cacheInfo = cacheInfo;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshCache() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Clear existing cache
      await KMBCacheService.clearCache();

      // Reload data (will fetch from API and cache)
      await _loadInitialData();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error refreshing cache: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onRouteSelected(String routeKey) {
    setState(() {
      _selectedRouteKey = routeKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KMB ETA'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCache,
            tooltip: 'Refresh Cache',
          ),
        ],
      ),
      body: _isLoading && _routes.isEmpty && _stops.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error Loading Data',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _loadInitialData,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Route Input and Selector
                      RouteSelector(
                        allRoutes: _routes,
                        selectedRouteKey: _selectedRouteKey,
                        onRouteSelected: _onRouteSelected,
                      ),

                      const SizedBox(height: 16),

                      // Bookmarked Stop Selector
                      const BookmarkedRouteWithStation(),

                      // const SizedBox(height: 16),

                      // InputKeyboard()
                    ],
                  ),
                ),
    );
  }
}
