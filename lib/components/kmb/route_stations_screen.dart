import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../scripts/kmb_api_service.dart';

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
  List<KMBETA> _etaData = [];
  bool _isLoadingETA = false;
  String? _selectedStopId; // Track which station is selected
  int? _selectedStationSeq; // Track the sequence number of selected station

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

  Future<void> _loadETA(String stopId, int stationSeq) async {
    try {
      setState(() {
        _isLoadingETA = true;
        _selectedStopId = stopId; // Set selected station
        _selectedStationSeq = stationSeq; // Set selected station sequence
        _etaData = []; // Clear previous ETA data
      });

      final etaData =
          await KMBApiService.getETA(stopId, widget.routeNumber, '1');

      for (int i = 0; i < 1; i++) {
        final eta = etaData[i];
        print(
            'RouteData: ${eta.route} | ${eta.dir} | ${eta.serviceType} | by ${eta.co}');
      }
      print('========================');

      setState(() {
        _etaData = etaData;
        _isLoadingETA = false;
      });
    } catch (e) {
      print('=== ETA Error ===');
      print('Error: $e');
      print('================');
      setState(() {
        _errorMessage = 'Error loading ETA: $e';
        _isLoadingETA = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.routeNumber} 往 ${widget.destinationTc}'),
        backgroundColor: const Color(0xFF323232),
        foregroundColor: const Color(0xFFF7A925),
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
              : SafeArea(
                  child: _routeStops.isEmpty
                      ? const Center(
                          child: Text(
                            'No stations found',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16,
                              16), // Bottom padding for navigation bar
                          itemCount: _routeStops.length,
                          itemBuilder: (context, index) {
                            final stop = _routeStops[index];
                            final isLast = index == _routeStops.length - 1;
                            final isSelected = _selectedStopId == stop.stop &&
                                _selectedStationSeq == stop.seq;

                            return Column(
                              children: [
                                // Station Item
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    // Print station ID and details
                                    print('=== Station Selected ===');
                                    print(
                                        'Station Name (TC): ${stop.stopNameTc}');
                                    print('Station Sequence: ${stop.seq}');
                                    print('Station ID: ${stop.stop}');
                                    print('======================');
                                    _loadETA(stop.stop, stop.seq);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white, // White background
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors
                                                .black, // Green when selected, black otherwise
                                        width: isSelected
                                            ? 3
                                            : 1, // Thicker border when selected
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
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                                  color: Colors
                                                      .black, // Black text
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                stop.stopNameEn,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[
                                                      700], // Darker grey for better contrast
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
                                ),
                                // ETA Display Section - Only show under selected station
                                if (isSelected &&
                                    _etaData.isNotEmpty &&
                                    _etaData.any((eta) =>
                                        eta.seq == _selectedStationSeq)) ...[
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      // color: const Color(0xFF1E1E1E),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 3,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '🚌 到站時間',
                                          style: TextStyle(
                                            // color: Color(0xFFF7A925),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ..._etaData.where((eta) {
                                          final matches =
                                              eta.seq == _selectedStationSeq;
                                          // print('ETA Seq: ${eta.seq}, Selected Station Seq: $_selectedStationSeq, Matches: $matches');
                                          return matches;
                                        }) // Filter by sequence matching selected station sequence
                                            .map((eta) {
                                          int displaySeq = eta.etaSeq;
                                          if (displaySeq > 3) {
                                            displaySeq -= 3;
                                          }
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFF323232),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '第 $displaySeq 班',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF323232),
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      eta.arrivalTimeString,
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xFF323232),
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ],
                                // Loading indicator for ETA
                                if (isSelected && _isLoadingETA)
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      // color: const Color(0xFF1E1E1E),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Colors.black,
                                          strokeWidth: 2,
                                        ),
                                        SizedBox(width: 16),
                                        Text(
                                          '載入中...',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                ),
    );
  }
}
