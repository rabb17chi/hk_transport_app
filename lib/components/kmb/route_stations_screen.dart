import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../scripts/ctb/ctb_route_stops_service.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/utils/vibration_helper.dart';
import '../../theme/app_color_scheme.dart';

/// Route Stations Screen
///
/// Displays all stations for a selected route and bound
class RouteStationsScreen extends StatefulWidget {
  final String routeKey; // Format: "route_bound" (e.g., "13_I")
  final String routeNumber;
  final String bound;
  final String?
      serviceType; // pass through actual service type (defaults to '1')
  final String destinationTc;
  final String destinationEn;
  final bool isCTB;

  const RouteStationsScreen({
    super.key,
    required this.routeKey,
    required this.routeNumber,
    required this.bound,
    this.serviceType,
    required this.destinationTc,
    required this.destinationEn,
    this.isCTB = false,
  });

  @override
  State<RouteStationsScreen> createState() => _RouteStationsScreenState();
}

class _RouteStationsScreenState extends State<RouteStationsScreen> {
  List<KMBRouteStop> _routeStops = [];
  List<CTBRouteStop> _ctbRouteStops = [];
  final Map<String, CTBStopInfo> _ctbStopInfoCache = {};
  bool _isLoading = true;
  String _errorMessage = '';
  List<KMBETA> _etaData = [];
  List<CTBETA> _ctbEtaData = [];
  bool _isLoadingETA = false;
  String? _selectedStopId; // Track which station is selected
  int? _selectedStationSeq; // Track the sequence number of selected station
  List<KMBRoute> _availableBounds = []; // Available bounds for this route

  String _cleanStopName(String name) {
    // Remove trailing code like " (XX123)" or similar alnum code in parentheses
    final regex = RegExp(r"\s*\([A-Za-z]{2}\d{3}\)");
    return name.replaceAll(regex, "");
  }

  @override
  void initState() {
    super.initState();
    _loadRouteStops();
    _findAvailableBounds();
  }

  Future<CTBStopInfo> _getCtbStopInfo(String stopId) async {
    final cached = _ctbStopInfoCache[stopId];
    if (cached != null) return cached;
    final info = await CTBRouteStopsService.getStopInfo(stopId);
    _ctbStopInfoCache[stopId] = info;
    return info;
  }

  /// Find other bounds available for this route
  Future<void> _findAvailableBounds() async {
    try {
      final allRoutes = await KMBApiService.getAllRoutes();
      final sameRouteRoutes = allRoutes
          .where((route) => route.route == widget.routeNumber)
          .toList();

      setState(() {
        _availableBounds = sameRouteRoutes;
      });
    } catch (e) {
      print('Error finding available bounds: $e');
    }
  }

  /// Switch to another bound of the same route
  void _switchToOtherBound() async {
    if (_availableBounds.length <= 1) return;

    // Provide vibration feedback
    await VibrationHelper.lightVibrate();

    if (!mounted) return;

    // Find the other bound (not the current one)
    final otherBound = _availableBounds.firstWhere(
      (route) => route.bound != widget.bound,
      orElse: () => _availableBounds.first,
    );

    // Navigate to the other bound
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RouteStationsScreen(
          routeKey: '${otherBound.route}_${otherBound.bound}',
          routeNumber: otherBound.route,
          bound: otherBound.bound,
          destinationTc: otherBound.destTc,
          destinationEn: otherBound.destEn,
        ),
      ),
    );
  }

  Future<void> _loadRouteStops() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      if (widget.isCTB) {
        final dir = widget.bound == 'I' ? 'inbound' : 'outbound';
        final routeStops = await CTBRouteStopsService.getRouteStops(
          route: widget.routeNumber,
          bound: dir,
        );
        setState(() {
          _ctbRouteStops = routeStops;
          _isLoading = false;
        });
      } else {
        final routeStops = await KMBApiService.getRouteStops(
          widget.routeNumber,
          widget.bound,
          widget.serviceType ?? '1',
        );
        setState(() {
          _routeStops = routeStops;
          _isLoading = false;
        });
      }
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

      final etaData = await KMBApiService.getETA(
          stopId, widget.routeNumber, widget.serviceType ?? '1');

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

  Future<void> _loadCTBETA(String stopId, int stationSeq) async {
    try {
      setState(() {
        _isLoadingETA = true;
        _selectedStopId = stopId;
        _selectedStationSeq = stationSeq;
        _ctbEtaData = [];
      });

      final etaData = await CTBRouteStopsService.getETA(
        stopId: stopId,
        route: widget.routeNumber,
      );

      // Filter by current screen bound (I/O) and sort by eta_seq
      final currentDir = widget.bound.toUpperCase();
      final filtered = etaData
          .where((e) => e.dir.toUpperCase() == currentDir)
          .toList()
        ..sort((a, b) => a.etaSeq.compareTo(b.etaSeq));

      // Debug logs for CTB ETA
      try {
        print('=== CTB ETA Debug ===');
        print('Route: ${widget.routeNumber}, Stop: $stopId, Dir: $currentDir');
        for (int i = 0; i < filtered.length && i < 3; i++) {
          final e = filtered[i];
          print(
              'ETA #${e.etaSeq}: route=${e.route}, dir=${e.dir}, seq=${e.seq}, stop=${e.stop}, eta=${e.eta}, minutes=${e.minutesUntilArrival}');
        }
        print('Total ETAs after filter: ${filtered.length}');
        print('======================');
      } catch (_) {}

      setState(() {
        _ctbEtaData = filtered;
        _isLoadingETA = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading ETA: $e';
        _isLoadingETA = false;
      });
    }
  }

  // === Reusable ETA widgets ===
  Widget _buildEtaBlock(List<Widget> rows) {
    final noData = rows.isEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        border: Border.all(
          color: AppColorScheme.successBorderColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🚌 到站時間',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (noData) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColorScheme.unselectedBorderColor,
                  width: 2,
                ),
              ),
              alignment: Alignment.centerRight,
              child: Text(
                AppLocalizations.of(context)?.etaEmpty ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            ...rows,
          ],
        ],
      ),
    );
  }

  Widget _buildEtaRow(String leftLabel, String rightLabel) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFF323232),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftLabel,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF323232),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            rightLabel,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF323232),
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtaLoading() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColorScheme.unselectedBorderColor,
          width: 2,
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColorScheme.loadingIconColor,
            strokeWidth: 2,
          ),
          SizedBox(width: 16),
          Text('載入中...'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.routeNumber} 往 ${widget.destinationTc} ${widget.isCTB ? '' : widget.serviceType == '1' ? '' : '| 特別班次'}'),
        backgroundColor:
            widget.isCTB ? const Color(0xFF0055B8) : const Color(0xFF323232),
        foregroundColor:
            widget.isCTB ? const Color(0xFFFFDD00) : const Color(0xFFF7A925),
        actions: _availableBounds.length > 1 && widget.serviceType == '1'
            ? [
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: _switchToOtherBound,
                  tooltip: 'Switch to other bound',
                ),
              ]
            : null,
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
                        color: AppColorScheme.errorIconColor,
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
                  child: (widget.isCTB
                          ? _ctbRouteStops.isEmpty
                          : _routeStops.isEmpty)
                      ? const Center(
                          child: Text(
                            'No stations found',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: widget.isCTB
                              ? _ctbRouteStops.length
                              : _routeStops.length,
                          itemBuilder: (context, index) {
                            if (widget.isCTB) {
                              final stop = _ctbRouteStops[index];
                              final isSelected = _selectedStopId == stop.stop &&
                                  _selectedStationSeq == stop.seq;
                              final bookmarkItem = BookmarkItem(
                                operator: 'CTB',
                                route: widget.routeNumber,
                                bound: widget.bound,
                                stopId: stop.stop,
                                stopNameTc: '',
                                stopNameEn: '',
                                serviceType: '1',
                                destTc: widget.destinationTc,
                                destEn: widget.destinationEn,
                              );

                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      HapticFeedback.lightImpact();
                                      await _loadCTBETA(stop.stop, stop.seq);
                                    },
                                    onLongPress: () async {
                                      HapticFeedback.mediumImpact();
                                      // Fetch stop info to store names with the bookmark
                                      CTBStopInfo? info;
                                      try {
                                        info = await _getCtbStopInfo(stop.stop);
                                      } catch (_) {}
                                      final item = BookmarkItem(
                                        operator: 'CTB',
                                        route: widget.routeNumber,
                                        bound: widget.bound,
                                        stopId: stop.stop,
                                        stopNameTc: info?.nameTc ?? '',
                                        stopNameEn: info?.nameEn ?? '',
                                        serviceType: '1',
                                        destTc: widget.destinationTc,
                                        destEn: widget.destinationEn,
                                      );
                                      final already =
                                          await BookmarksService.isBookmarked(
                                              item);
                                      if (already) {
                                        await BookmarksService.removeBookmark(
                                            item);
                                        if (!mounted) return;
                                      } else {
                                        await BookmarksService.addBookmark(
                                            item);
                                        if (!mounted) return;
                                      }
                                      if (mounted) setState(() {});
                                    },
                                    child: FutureBuilder<bool>(
                                      future: BookmarksService.isBookmarked(
                                          bookmarkItem),
                                      builder: (context, snap) {
                                        final bookmarked = snap.data == true;
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 8),
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: bookmarked
                                                ? AppColorScheme.bookmarkedColor
                                                    .withOpacity(Theme.of(
                                                                    context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? 0.85
                                                        : 0.35)
                                                : Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.grey[900]
                                                    : Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColorScheme
                                                      .selectedBorderColor
                                                  : Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                              width: isSelected ? 3 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFFF7A925),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    FutureBuilder<CTBStopInfo>(
                                                      future: _getCtbStopInfo(
                                                          stop.stop),
                                                      builder: (context, snap) {
                                                        final info = snap.data;
                                                        final isChinese =
                                                            Localizations.localeOf(
                                                                        context)
                                                                    .languageCode ==
                                                                'zh';
                                                        final displayTopBase =
                                                            info == null
                                                                ? stop.stop
                                                                : (isChinese
                                                                    ? info
                                                                        .nameTc
                                                                    : info
                                                                        .nameEn);
                                                        final displayTop =
                                                            '$displayTopBase (${stop.stop})';
                                                        final displayBottom =
                                                            info == null
                                                                ? ''
                                                                : (isChinese
                                                                    ? info
                                                                        .nameEn
                                                                    : info
                                                                        .nameTc);
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              displayTop,
                                                              style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            Text(
                                                              displayBottom,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Theme.of(context)
                                                                            .brightness ==
                                                                        Brightness
                                                                            .dark
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if (isSelected && _isLoadingETA)
                                    _buildEtaLoading(),
                                  if (isSelected && !_isLoadingETA)
                                    _buildEtaBlock(
                                      _ctbEtaData.map((eta) {
                                        final isChinese =
                                            Localizations.localeOf(context)
                                                    .languageCode ==
                                                'zh';
                                        final label = isChinese
                                            ? eta.arrivalTimeStringZh
                                            : eta.arrivalTimeStringEn;
                                        int displaySeq = eta.etaSeq;
                                        if (displaySeq > 3) displaySeq -= 3;
                                        return _buildEtaRow(
                                            '第 $displaySeq 班', label);
                                      }).toList(),
                                    ),
                                ],
                              );
                            }

                            final stop = _routeStops[index];
                            final isSelected = _selectedStopId == stop.stop &&
                                _selectedStationSeq == stop.seq;
                            final bookmarkItem = BookmarkItem(
                              route: widget.routeNumber,
                              bound: widget.bound,
                              stopId: stop.stop,
                              stopNameTc: stop.stopNameTc,
                              stopNameEn: stop.stopNameEn,
                              serviceType: widget.serviceType ?? '1',
                              destTc: widget.destinationTc,
                              destEn: widget.destinationEn,
                            );

                            return Column(
                              children: [
                                // Station Item
                                GestureDetector(
                                  onTap: () async {
                                    HapticFeedback.lightImpact();
                                    _loadETA(stop.stop, stop.seq);
                                  },
                                  onLongPress: () async {
                                    HapticFeedback.mediumImpact();
                                    final item = BookmarkItem(
                                      route: widget.routeNumber,
                                      bound: widget.bound,
                                      stopId: stop.stop,
                                      stopNameTc: stop.stopNameTc,
                                      stopNameEn: stop.stopNameEn,
                                      serviceType: widget.serviceType ?? '1',
                                      destTc: widget.destinationTc,
                                      destEn: widget.destinationEn,
                                    );
                                    final already =
                                        await BookmarksService.isBookmarked(
                                            item);
                                    if (already) {
                                      await BookmarksService.removeBookmark(
                                          item);
                                      if (!mounted) return;
                                    } else {
                                      await BookmarksService.addBookmark(item);
                                      if (!mounted) return;
                                    }
                                    if (mounted) setState(() {});
                                  },
                                  child: FutureBuilder<bool>(
                                    future: BookmarksService.isBookmarked(
                                        bookmarkItem),
                                    builder: (context, snap) {
                                      final bookmarked = snap.data == true;
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: bookmarked
                                              ? AppColorScheme.bookmarkedColor
                                                  .withOpacity(Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? 0.85
                                                      : 0.35)
                                              : Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.grey[900]
                                                  : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColorScheme
                                                    .selectedBorderColor
                                                : Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
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
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.black,
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
                                                    _cleanStopName(
                                                        stop.stopNameTc),
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors
                                                              .black, // Black text
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    _cleanStopName(
                                                        stop.stopNameEn),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : AppColorScheme
                                                              .textMediumColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // ETA Display Section - Only show under selected station
                                if (isSelected &&
                                    _etaData.isNotEmpty &&
                                    _etaData.any((eta) =>
                                        eta.seq == _selectedStationSeq)) ...[
                                  _buildEtaBlock(
                                    _etaData
                                        .where((eta) =>
                                            eta.seq == _selectedStationSeq)
                                        .map((eta) {
                                      int displaySeq = eta.etaSeq;
                                      if (displaySeq > 3) displaySeq -= 3;
                                      return _buildEtaRow('第 $displaySeq 班',
                                          eta.arrivalTimeString);
                                    }).toList(),
                                  ),
                                ],
                                // Loading indicator for ETA
                                if (isSelected && _isLoadingETA)
                                  _buildEtaLoading(),
                              ],
                            );
                          },
                        ),
                ),
    );
  }
}
