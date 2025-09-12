import 'package:flutter/material.dart';
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
  List<KMBETA> _etas = [];

  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedRouteKey = ''; // Changed to store routeKey (route + bound)
  String _selectedStop = '';
  String _selectedServiceType = '1';
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cache refreshed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
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

  // Removed _searchRoutes method as filtering is now handled internally by RouteSelector

  Future<void> _searchStops(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final stops = await KMBApiService.searchStops(query);
      setState(() {
        _stops = stops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching stops: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getETA() async {
    if (_selectedRouteKey.isEmpty || _selectedStop.isEmpty) {
      setState(() {
        _errorMessage = 'Please select both route and stop';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final etas = await KMBApiService.getETA(
          _selectedStop, _selectedRouteKey.split('_')[0], _selectedServiceType);
      setState(() {
        _etas = etas;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching ETA: $e';
        _isLoading = false;
      });
    }
  }

  void _onRouteSelected(String routeKey) {
    setState(() {
      _selectedRouteKey = routeKey;
    });
  }

  void _onStopSelected(String stop) {
    setState(() {
      _selectedStop = stop;
    });
  }

  void _onServiceTypeChanged(String serviceType) {
    setState(() {
      _selectedServiceType = serviceType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KMB ETA'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: _isLoading && _routes.isEmpty && _stops.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route Selector
                  RouteSelector(
                    allRoutes: _routes,
                    selectedRouteKey: _selectedRouteKey,
                    onRouteSelected: _onRouteSelected,
                  ),

                  const SizedBox(height: 16),

                  // Bookmarked Stop Selector
                  // BookmarkedRouteWithStation(
                  // ),

                  const SizedBox(height: 16),

                  // InputKeyboard()
                ],
              ),
            ),
    );
  }
}
