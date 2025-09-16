import 'package:flutter/material.dart';
import 'package:hk_transport_app/components/kmb/input_keyboard.dart';
import '../../scripts/kmb_api_service.dart';
import 'route_banner.dart';
import 'route_stations_screen.dart';

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
  bool _showSpecialRoutes = false; // serviceType 2/5 visibility

  // Text controller for keyboard communication
  final TextEditingController _searchController = TextEditingController();
  List<KMBRoute> _filteredRoutes = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_filterRoutes);
  }

  @override
  void dispose() {
    _searchController.dispose();
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
        _routes = routes; // keep all service types
        _stops = stops;
        _filteredRoutes = _applyServiceTypeFilter(routes);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading data: $e';
        _isLoading = false;
      });
    }
  }

  void _onRouteSelected(String routeKey) {
    setState(() {
      _selectedRouteKey = routeKey;
    });
  }

  void _filterRoutes() {
    final query = _searchController.text.toUpperCase();

    setState(() {
      if (query.isEmpty) {
        _filteredRoutes = _applyServiceTypeFilter(_routes);
      } else {
        _filteredRoutes = _applyServiceTypeFilter(_routes)
            .where((route) =>
                route.route.toUpperCase().startsWith(query) ||
                route.route.toUpperCase() == query)
            .toList();
      }
    });
  }

  List<KMBRoute> _applyServiceTypeFilter(List<KMBRoute> src) {
    if (_showSpecialRoutes) {
      // show main + special
      return src;
    }
    // default: only main service type == '1'
    return src.where((r) => r.serviceType == '1').toList();
  }

  void _onKeyboardTextChanged(String text) {
    setState(() {
      _searchController.text = text;
      _filterRoutes();
    });
  }

  Set<String> _getAvailableNextCharacters(String currentInput) {
    if (currentInput.length >= 4) return <String>{};

    final availableChars = <String>{};

    for (final route in _routes) {
      final routeStr = route.route.toUpperCase();
      if (routeStr.startsWith(currentInput.toUpperCase()) &&
          routeStr.length > currentInput.length) {
        final nextChar = routeStr[currentInput.length];
        availableChars.add(nextChar);
      }
    }

    // Debug: Print available characters for debugging
    if (currentInput.isNotEmpty) {
      print('Input: "$currentInput" -> Available next chars: $availableChars');
      final matches = _routes
          .where((route) =>
              route.route.toUpperCase().startsWith(currentInput.toUpperCase()))
          .map((r) => '${r.route}(${r.serviceType})')
          .toList();
      print('Matching routes: $matches');
    }

    return availableChars;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KMB班次時間查詢'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
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
              : Column(
                  children: [
                    // Search Field - Fixed height
                    Container(
                      height: 400, // Fixed height to prevent overflow
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: _searchController,
                                decoration: const InputDecoration(
                                  hintText: '請輸入路線號碼',
                                  counterText: "",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.search),
                                ),
                                textCapitalization:
                                    TextCapitalization.characters,
                                readOnly: true, // Disable virtual keyboard
                                maxLength: 4,
                              ),
                              const SizedBox(height: 8),
                              if (_searchController.text.isNotEmpty) ...[
                                if (_filteredRoutes.isNotEmpty) ...[
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _filteredRoutes.length,
                                      itemBuilder: (context, index) {
                                        final route = _filteredRoutes[index];
                                        final routeKey =
                                            '${route.route}_${route.bound}';
                                        final isSelected =
                                            _selectedRouteKey == routeKey;

                                        return RouteBanner(
                                          route: route,
                                          isSelected: isSelected,
                                          onTap: () {
                                            // Navigate to route stations screen
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    RouteStationsScreen(
                                                  routeKey: routeKey,
                                                  routeNumber: route.route,
                                                  bound: route.bound,
                                                  destinationTc: route.destTc,
                                                  destinationEn: route.destEn,
                                                ),
                                              ),
                                            );

                                            _onRouteSelected(routeKey);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ] else if (_searchController
                                    .text.isNotEmpty) ...[
                                  const SizedBox(height: 16),
                                  const Center(
                                    child: Column(
                                      children: [
                                        Icon(Icons.search_off,
                                            size: 48, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text(
                                          '沒有相應路線',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '請重新檢查路線號碼',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ] else ...[
                                const SizedBox(height: 16),
                                const Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.search,
                                          size: 48, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text(
                                        '請輸入路線號碼',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '例如: 1A',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Bookmarked Stop Selector - Takes remaining space
                    // const Expanded(
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: 16.0),
                    //     child: BookmarkedRouteWithStation(),
                    //   ),
                    // ),
                    const Spacer(),
                    // Custom Keyboard - Fixed at bottom
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _searchController,
                      builder: (context, value, child) {
                        return InputKeyboard(
                          onTextChanged: _onKeyboardTextChanged,
                          availableCharacters:
                              _getAvailableNextCharacters(value.text),
                        );
                      },
                    ),
                  ],
                ),
    );
  }
}
