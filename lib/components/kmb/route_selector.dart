import 'package:flutter/material.dart';
import '../../scripts/kmb_api_service.dart';
import 'route_stations_screen.dart';
import 'route_banner.dart';

/// Route Selector Component
///
/// A reusable widget for searching and selecting KMB bus routes
class RouteSelector extends StatefulWidget {
  final List<KMBRoute> allRoutes;
  final String
      selectedRouteKey; // Changed to selectedRouteKey to include direction
  final Function(String) onRouteSelected; // Will pass routeKey (route + bound)

  const RouteSelector({
    super.key,
    required this.allRoutes,
    required this.selectedRouteKey,
    required this.onRouteSelected,
  });

  @override
  State<RouteSelector> createState() => _RouteSelectorState();
}

class _RouteSelectorState extends State<RouteSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<KMBRoute> _filteredRoutes = [];

  @override
  void initState() {
    super.initState();
    _filteredRoutes = List.from(widget.allRoutes);
    _searchController.addListener(_filterRoutes);
  }

  @override
  void didUpdateWidget(RouteSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update filtered routes when allRoutes changes
    if (oldWidget.allRoutes != widget.allRoutes) {
      _filteredRoutes = List.from(widget.allRoutes);
      _filterRoutes(); // Re-filter with current search text
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRoutes() {
    final query = _searchController.text.toUpperCase();

    setState(() {
      if (query.isEmpty) {
        _filteredRoutes = widget.allRoutes;
      } else {
        _filteredRoutes = widget.allRoutes
            .where((route) =>
                route.route.toUpperCase().startsWith(query) ||
                route.route.toUpperCase() == query)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Enter route number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                suffixIcon: Icon(Icons.clear),
              ),
              textCapitalization: TextCapitalization.characters,
              onChanged: (value) {
                // Convert to uppercase as user types
                final upperValue = value.toUpperCase();
                if (value != upperValue) {
                  _searchController.value = _searchController.value.copyWith(
                    text: upperValue,
                    selection:
                        TextSelection.collapsed(offset: upperValue.length),
                  );
                }
              },
              onSubmitted: (_) {
                // Clear search when submitted
                _searchController.clear();
              },
            ),
            const SizedBox(height: 8),
            if (_searchController.text.isNotEmpty) ...[
              if (_filteredRoutes.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 320,
                  child: ListView.builder(
                    itemCount: _filteredRoutes.length,
                    itemBuilder: (context, index) {
                      final route = _filteredRoutes[index];
                      final direction =
                          route.bound == 'I' ? 'Inbound' : 'Outbound';
                      final routeKey =
                          '${route.route}_${route.bound}'; // Create unique key
                      final isSelected = widget.selectedRouteKey == routeKey;

                      return RouteBanner(
                        route: route,
                        isSelected: isSelected,
                        onTap: () {
                          // Print detailed route data
                          print('=== Selected Route Data ===');
                          print('Route: ${route.route}');
                          print('Direction: $direction (${route.bound})');
                          print('Service Type: ${route.serviceType}');
                          print('Origin (EN): ${route.origEn}');
                          print('Origin (TC): ${route.origTc}');
                          print('Origin (SC): ${route.origSc}');
                          print('Destination (EN): ${route.destEn}');
                          print('Destination (TC): ${route.destTc}');
                          print('Destination (SC): ${route.destSc}');
                          print('========================');

                          // Navigate to route stations screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RouteStationsScreen(
                                routeKey: routeKey,
                                routeNumber: route.route,
                                bound: route.bound,
                                destinationTc: route.destTc,
                                destinationEn: route.destEn,
                              ),
                            ),
                          );

                          widget.onRouteSelected(routeKey);
                        },
                      );
                    },
                  ),
                ),
              ] else if (_searchController.text.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'No routes found',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Try a different search term',
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
                    Icon(Icons.search, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Start typing to search routes',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'e.g., 1A, 960, 2A',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
