import 'package:flutter/material.dart';
import '../scripts/kmb_api_service.dart';
import '../components/route_selector.dart';
import '../components/stop_selector.dart';
import '../components/service_type_selector.dart';
import '../components/eta_display.dart';
import '../components/action_button.dart';

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

      setState(() {
        _routes = routes;
        _stops = stops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: $e';
        _isLoading = false;
      });
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
        title: const Text('KMB API Test'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadInitialData,
            tooltip: 'Refresh Data',
          ),
        ],
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

                  // Stop Selector
                  StopSelector(
                    stops: _stops,
                    selectedStop: _selectedStop,
                    onStopSelected: _onStopSelected,
                    onSearch: _searchStops,
                    isLoading: _isLoading,
                  ),

                  const SizedBox(height: 16),

                  // Service Type Selector
                  ServiceTypeSelector(
                    selectedServiceType: _selectedServiceType,
                    onServiceTypeChanged: _onServiceTypeChanged,
                  ),

                  const SizedBox(height: 16),

                  // Get ETA Button
                  ActionButton(
                    text: 'Get Real-time ETA',
                    icon: Icons.schedule,
                    onPressed:
                        _selectedRouteKey.isNotEmpty && _selectedStop.isNotEmpty
                            ? _getETA
                            : null,
                  ),

                  const SizedBox(height: 16),

                  // ETA Display
                  ETADisplay(
                    etas: _etas,
                    isLoading: _isLoading,
                    selectedRoute: _selectedRouteKey.isNotEmpty
                        ? _selectedRouteKey.split('_')[0]
                        : '',
                    errorMessage:
                        _errorMessage.isNotEmpty ? _errorMessage : null,
                  ),
                ],
              ),
            ),
    );
  }
}
