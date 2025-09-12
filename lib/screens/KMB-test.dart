import 'package:flutter/material.dart';
import '../scripts/KMB-api-script.dart';

class KMBTestScreen extends StatefulWidget {
  const KMBTestScreen({super.key});

  @override
  State<KMBTestScreen> createState() => _KMBTestScreenState();
}

class _KMBTestScreenState extends State<KMBTestScreen> {
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _stopController = TextEditingController();

  List<KMBRoute> _routes = [];
  List<KMBStop> _stops = [];
  List<KMBETA> _etas = [];

  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedRoute = '';
  String _selectedStop = '';
  String _selectedServiceType = '1';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _routeController.dispose();
    _stopController.dispose();
    super.dispose();
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

  Future<void> _searchRoutes() async {
    if (_routeController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final routes = await KMBApiService.searchRoutes(_routeController.text);
      setState(() {
        _routes = routes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error searching routes: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchStops() async {
    if (_stopController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final stops = await KMBApiService.searchStops(_stopController.text);
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
    if (_selectedRoute.isEmpty || _selectedStop.isEmpty) {
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
          _selectedStop, _selectedRoute, _selectedServiceType);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KMB API Test'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Route Search Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Routes',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _routeController,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Enter route number (e.g., 1A, 960)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _searchRoutes,
                                child: const Text('Search'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Found ${_routes.length} routes'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Stop Search Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Search Stops',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _stopController,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Enter stop name (e.g., Central, 中環)',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _searchStops,
                                child: const Text('Search'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Found ${_stops.length} stops'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Route Selection
                  if (_routes.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Route',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: _routes.length,
                                itemBuilder: (context, index) {
                                  final route = _routes[index];
                                  return ListTile(
                                    title: Text('Route ${route.route}'),
                                    subtitle: Text(
                                        '${route.origEn} → ${route.destEn}'),
                                    trailing: _selectedRoute == route.route
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedRoute = route.route;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Stop Selection
                  if (_stops.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Stop',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                itemCount: _stops.length,
                                itemBuilder: (context, index) {
                                  final stop = _stops[index];
                                  return ListTile(
                                    title: Text(stop.nameEn),
                                    subtitle:
                                        Text('${stop.nameTc} (${stop.nameSc})'),
                                    trailing: _selectedStop == stop.stop
                                        ? const Icon(Icons.check,
                                            color: Colors.green)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedStop = stop.stop;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Service Type Selection
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Service Type',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButton<String>(
                            value: _selectedServiceType,
                            items: const [
                              DropdownMenuItem(
                                  value: '1', child: Text('Regular Service')),
                              DropdownMenuItem(
                                  value: '2', child: Text('Special Service')),
                              DropdownMenuItem(
                                  value: '3', child: Text('Night Service')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedServiceType = value ?? '1';
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Get ETA Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _selectedRoute.isNotEmpty && _selectedStop.isNotEmpty
                              ? _getETA
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Get Real-time ETA',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Error Message
                  if (_errorMessage.isNotEmpty)
                    Card(
                      color: Colors.red[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red[800]),
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // ETA Results
                  if (_etas.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Real-time ETA Results',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ..._etas.map((eta) => Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: const Icon(Icons.directions_bus,
                                        color: Colors.blue),
                                    title: Text('Route ${eta.route}'),
                                    subtitle: Text(eta.destEn),
                                    trailing: Text(
                                      eta.minutesUntilArrival > 0
                                          ? '${eta.minutesUntilArrival} min'
                                          : eta.minutesUntilArrival == 0
                                              ? 'Arriving now'
                                              : eta.eta,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ] else if (_selectedRoute.isNotEmpty &&
                      _selectedStop.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const Icon(Icons.info_outline,
                                size: 48, color: Colors.grey),
                            const SizedBox(height: 8),
                            const Text(
                              'No ETA data available',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              'This might be due to:\n• No buses currently running\n• Service not available at this time\n• Invalid route/stop combination',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
