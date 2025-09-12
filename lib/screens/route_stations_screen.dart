import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../scripts/kmb_api_service.dart';

/// Route Stations Screen
///
/// Displays all stations for a selected route and bound
class RouteStationsScreen extends StatefulWidget {
  final String routeKey; // Format: "route_bound" (e.g., "13_I")
  final String routeNumber;
  final String bound;
  final String destinationTc;
  final String destinationEn;

  const RouteStationsScreen({
    super.key,
    required this.routeKey,
    required this.routeNumber,
    required this.bound,
    required this.destinationTc,
    required this.destinationEn,
  });

  @override
  State<RouteStationsScreen> createState() => _RouteStationsScreenState();
}

class _RouteStationsScreenState extends State<RouteStationsScreen> {
  List<KMBRouteStop> _routeStops = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRouteStops();
  }

  Future<void> _loadRouteStops() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final routeStops = await KMBApiService.getRouteStops(
        widget.routeNumber,
        widget.bound,
      );

      setState(() {
        _routeStops = routeStops;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading stations: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Route ${widget.routeNumber} - ${widget.bound == 'I' ? 'Inbound' : 'Outbound'}'),
        backgroundColor: const Color(0xFF323232),
        foregroundColor: const Color(0xFFF7A925),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRouteStops,
            tooltip: 'Refresh Stations',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFF7A925),
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadRouteStops,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF7A925),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Route Info Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFF323232),
                        border: Border(
                          bottom:
                              BorderSide(color: Color(0xFF555555), width: 1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Route ${widget.routeNumber} (${widget.bound == 'I' ? 'Inbound' : 'Outbound'})',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF7A925),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'To: ${widget.destinationTc}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFFF7A925),
                            ),
                          ),
                          Text(
                            'To: ${widget.destinationEn}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFF7A925),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_routeStops.length} stations',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Stations List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _routeStops.length,
                        itemBuilder: (context, index) {
                          final stop = _routeStops[index];
                          final isLast = index == _routeStops.length - 1;

                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              // You can add navigation to stop details here
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF323232),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFF555555),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Station Number
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7A925),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Station Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stop.stopNameTc,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFF7A925),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          stop.stopNameEn,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Arrow or End indicator
                                  if (isLast)
                                    const Icon(
                                      Icons.flag,
                                      color: Color(0xFFF7A925),
                                      size: 24,
                                    )
                                  else
                                    const Icon(
                                      Icons.arrow_downward,
                                      color: Color(0xFFF7A925),
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
