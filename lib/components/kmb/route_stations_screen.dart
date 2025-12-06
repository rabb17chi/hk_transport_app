import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../scripts/ctb/ctb_route_stops_service.dart';
import '../../scripts/bookmarks/bookmarks_service.dart';
import '../../scripts/utils/vibration_helper.dart';
import '../../scripts/utils/responsive_utils.dart';
import '../../scripts/utils/locale_utils.dart';
import '../../scripts/bookmarks/bookmark_toggle_service.dart';
import '../../scripts/utils/settings_service.dart';
import '../ui/station_item_widget.dart';
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

  // Helper classes for cleaner code
  static const _RouteColors _colors = _RouteColors();
  static const _RouteStyles _styles = _RouteStyles();

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print('DEBUG: initState - _selectedStopId = "$_selectedStopId"');
    }
    _loadRouteStops();
    _findAvailableBounds();
  }

  /// Build API review URL for current selection and open in external browser
  Future<void> _openApiReview() async {
    final stopId = _selectedStopId;
    if (stopId == null || stopId.isEmpty) return;

    late final Uri uri;
    if (widget.isCTB) {
      final url =
          '${CTBRouteStopsService.baseUrl}/eta/ctb/$stopId/${widget.routeNumber}';
      uri = Uri.parse(url);
    } else {
      final serviceType = widget.serviceType ?? '1';
      final url =
          '${KMBApiService.baseUrl}/eta/$stopId/${widget.routeNumber}/$serviceType';
      uri = Uri.parse(url);
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<CTBStopInfo> _getCtbStopInfo(String stopId) async {
    // Check memory cache first
    final cached = _ctbStopInfoCache[stopId];
    if (cached != null) return cached;

    // Use persistent cache service (fetches from API if not cached)
    final info = await CTBRouteStopsService.getStopInfoCached(stopId);
    _ctbStopInfoCache[stopId] = info;
    return info;
  }

  /// Find other bounds available for this route
  Future<void> _findAvailableBounds() async {
    try {
      final allRoutes = await KMBApiService.getAllRoutes(context);
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
          routeKey:
              '${otherBound.route}_${otherBound.bound}_${otherBound.serviceType}',
          routeNumber: otherBound.route,
          bound: otherBound.bound,
          serviceType: otherBound.serviceType,
          destinationTc: otherBound.destTc,
          destinationEn: otherBound.destEn,
        ),
      ),
    );
  }

  Future<void> _loadRouteStops() async {
    await _setLoadingState();

    try {
      final routeStops = widget.isCTB
          ? await _loadCTBRouteStops()
          : await _loadKMBRouteStops();

      await _setRouteStops(routeStops);
    } catch (e) {
      await _setErrorState('Error loading stations: $e');
    }
  }

  Future<List<CTBRouteStop>> _loadCTBRouteStops() async {
    final dir = widget.bound == 'I' ? 'inbound' : 'outbound';
    final routeStops = await CTBRouteStopsService.getRouteStops(
      route: widget.routeNumber,
      bound: dir,
    );

    // Cache all stop info after loading route stops
    // This ensures stop names are available even when offline
    if (routeStops.isNotEmpty) {
      final stopIds = routeStops.map((stop) => stop.stop).toList();
      // Use ensureStopsCached to fetch and cache missing stop info
      await CTBRouteStopsService.ensureStopsCached(stopIds);
    }

    return routeStops;
  }

  Future<List<KMBRouteStop>> _loadKMBRouteStops() async {
    return await KMBApiService.getRouteStops(
      widget.routeNumber,
      widget.bound,
      widget.serviceType ?? '1',
    );
  }

  Future<void> _loadETA(String stopId, int stationSeq) async {
    await _setETALoadingState(stopId, stationSeq);

    try {
      final etaData = widget.isCTB
          ? await _loadCTBETAData(stopId)
          : await _loadKMBETAData(stopId);

      _debugPrintETA(etaData);
      await _setETAData(etaData);
    } catch (e) {
      if (kDebugMode) {
        print('=== ETA Error ===');
        print('Error: $e');
        print('================');
      }
      await _setErrorState('Error loading ETA: $e');
    }
  }

  Future<List<CTBETA>> _loadCTBETAData(String stopId) async {
    final etaData = await CTBRouteStopsService.getETA(
      stopId: stopId,
      route: widget.routeNumber,
    );

    // Filter by current screen bound (I/O) and sort by eta_seq
    final currentDir = widget.bound.toUpperCase();
    return etaData.where((e) => e.dir.toUpperCase() == currentDir).toList()
      ..sort((a, b) => a.etaSeq.compareTo(b.etaSeq));
  }

  Future<List<KMBETA>> _loadKMBETAData(String stopId) async {
    return await KMBApiService.getETA(
        stopId, widget.routeNumber, widget.serviceType ?? '1');
  }

  // === Reusable ETA widgets ===
  Widget _buildEtaBlock(List<Widget> rows) {
    final noData = rows.isEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: _styles.getETABlockDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🚌 ${AppLocalizations.of(context)?.etaTitle ?? '到站時間'}',
            style: _styles.getETATitleStyle(context),
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
                style: TextStyle(
                  fontSize:
                      ResponsiveUtils.getOverflowSafeFontSize(context, 20.0),
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
              fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 20.0),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            rightLabel,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : const Color(0xFF323232),
              fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 32.0),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColorScheme.loadingIconColor,
            strokeWidth: 2,
          ),
          SizedBox(width: 8),
          Text(
            '載入中...',
            style: TextStyle(
              fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 14.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom header bar
            Container(
              color: _colors.getBackgroundColor(widget.isCTB),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: _colors.getForegroundColor(widget.isCTB),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      _appBarTitle,
                      style: _styles.getTitleStyle(context).copyWith(
                            color: _colors.getForegroundColor(widget.isCTB),
                          ),
                    ),
                  ),
                  if (_availableBounds.length > 1 && widget.serviceType == '1')
                    IconButton(
                      icon: const Icon(Icons.swap_horiz),
                      color: _colors.getForegroundColor(widget.isCTB),
                      onPressed: _switchToOtherBound,
                      tooltip: 'Switch to other bound',
                    ),
                ],
              ),
            ),
            // Body content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: _RouteColors.loadingIndicator,
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
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveUtils.getOverflowSafeFontSize(
                                          context, 16.0),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadRouteStops,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF7A925),
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(
                                  'Retry',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveUtils.getOverflowSafeFontSize(
                                            context, 14.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : (widget.isCTB
                              ? _ctbRouteStops.isEmpty
                              : _routeStops.isEmpty)
                          ? Center(
                              child: Text(
                                'No stations found',
                                style: TextStyle(
                                  fontSize:
                                      ResponsiveUtils.getOverflowSafeFontSize(
                                          context, 18.0),
                                ),
                              ),
                            )
                          : Column(children: [
                              Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: widget.isCTB
                                        ? _ctbRouteStops.length
                                        : _routeStops.length,
                                    itemBuilder: (context, index) {
                                      final isChinese =
                                          LocaleUtils.isChinese(context);
                                      if (widget.isCTB) {
                                        final stop = _ctbRouteStops[index];
                                        final isSelected =
                                            _selectedStopId == stop.stop &&
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

                                        return FutureBuilder<CTBStopInfo>(
                                          future: _getCtbStopInfo(stop.stop),
                                          builder: (context, snap) {
                                            final info = snap.data;
                                            final nameTc =
                                                info?.nameTc ?? stop.stop;
                                            final nameEn =
                                                info?.nameEn ?? stop.stop;

                                            return ValueListenableBuilder<bool>(
                                              valueListenable: SettingsService
                                                  .showSubtitleNotifier,
                                              builder:
                                                  (context, showSubtitle, _) =>
                                                      StationItemWidget(
                                                index: index,
                                                isSelected: isSelected,
                                                nameTc: nameTc,
                                                nameEn: nameEn,
                                                isChinese: isChinese,
                                                showSubtitle: showSubtitle,
                                                onTap: () async {
                                                  HapticFeedback.lightImpact();
                                                  await _loadETA(
                                                      stop.stop, stop.seq);
                                                },
                                                onLongPress: () async {
                                                  HapticFeedback.mediumImpact();
                                                  final item = BookmarkItem(
                                                    operator: 'CTB',
                                                    route: widget.routeNumber,
                                                    bound: widget.bound,
                                                    stopId: stop.stop,
                                                    stopNameTc: nameTc,
                                                    stopNameEn: nameEn,
                                                    serviceType: '1',
                                                    destTc:
                                                        widget.destinationTc,
                                                    destEn:
                                                        widget.destinationEn,
                                                  );
                                                  await BookmarkToggleService
                                                      .toggleBookmark(
                                                    context,
                                                    item,
                                                    () => setState(() {}),
                                                  );
                                                },
                                                isBookmarkedFuture: () =>
                                                    BookmarksService
                                                        .isBookmarked(
                                                            bookmarkItem),
                                                additionalContent: Column(
                                                  children: [
                                                    if (isSelected &&
                                                        _isLoadingETA)
                                                      _buildEtaLoading(),
                                                    if (isSelected &&
                                                        !_isLoadingETA)
                                                      _buildEtaBlock(
                                                        _ctbEtaData.map((eta) {
                                                          final label = isChinese
                                                              ? eta
                                                                  .arrivalTimeStringZh
                                                              : eta
                                                                  .arrivalTimeStringEn;
                                                          int displaySeq =
                                                              eta.etaSeq;
                                                          if (displaySeq > 3)
                                                            displaySeq -= 3;
                                                          return _buildEtaRow(
                                                              '$displaySeq',
                                                              label);
                                                        }).toList(),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      final stop = _routeStops[index];
                                      final isSelected =
                                          _selectedStopId == stop.stop &&
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

                                      return ValueListenableBuilder<bool>(
                                        valueListenable: SettingsService
                                            .showSubtitleNotifier,
                                        builder: (context, showSubtitle, _) =>
                                            StationItemWidget(
                                          index: index,
                                          isSelected: isSelected,
                                          nameTc: stop.stopNameTc,
                                          nameEn: stop.stopNameEn,
                                          isChinese: isChinese,
                                          showSubtitle: showSubtitle,
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
                                              serviceType:
                                                  widget.serviceType ?? '1',
                                              destTc: widget.destinationTc,
                                              destEn: widget.destinationEn,
                                            );
                                            await BookmarkToggleService
                                                .toggleBookmark(
                                              context,
                                              item,
                                              () => setState(() {}),
                                            );
                                          },
                                          isBookmarkedFuture: () =>
                                              BookmarksService.isBookmarked(
                                                  bookmarkItem),
                                          additionalContent: Column(
                                            children: [
                                              // ETA Display Section - Only show under selected station
                                              if (isSelected &&
                                                  _etaData.isNotEmpty &&
                                                  _etaData.any((eta) =>
                                                      eta.seq ==
                                                      _selectedStationSeq)) ...[
                                                _buildEtaBlock(
                                                  _etaData
                                                      .where((eta) =>
                                                          eta.seq ==
                                                          _selectedStationSeq)
                                                      .map((eta) {
                                                    int displaySeq = eta.etaSeq;
                                                    if (displaySeq > 3)
                                                      displaySeq -= 3;
                                                    return _buildEtaRow(
                                                        '$displaySeq',
                                                        eta.getArrivalTimeString(
                                                            context));
                                                  }).toList(),
                                                ),
                                              ],
                                              // Loading indicator for ETA
                                              if (isSelected && _isLoadingETA)
                                                _buildEtaLoading(),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                              // API-Review button right under the ListView
                              // Debug: Show current state
                              if (_selectedStopId != null) ...[
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: _openApiReview,
                                          icon: const Icon(Icons.open_in_new),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .apiReview),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                _colors.getBackgroundColor(
                                                    widget.isCTB),
                                            foregroundColor:
                                                _colors.getForegroundColor(
                                                    widget.isCTB),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ]),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for cleaner code
  Future<void> _setLoadingState() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
  }

  Future<void> _setETALoadingState(String stopId, int stationSeq) async {
    if (!mounted) return;
    setState(() {
      _isLoadingETA = true;
      _selectedStopId = stopId;
      _selectedStationSeq = stationSeq;
      _etaData = [];
      _ctbEtaData = [];
    });
  }

  Future<void> _setETAData(dynamic etaData) async {
    if (!mounted) return;
    setState(() {
      if (widget.isCTB) {
        _ctbEtaData = etaData;
      } else {
        _etaData = etaData;
      }
      _isLoadingETA = false;
    });
  }

  Future<void> _setRouteStops(dynamic routeStops) async {
    if (!mounted) return;
    setState(() {
      if (widget.isCTB) {
        _ctbRouteStops = routeStops;
      } else {
        _routeStops = routeStops;
      }
      _isLoading = false;
    });
  }

  Future<void> _setErrorState(String error) async {
    if (!mounted) return;
    setState(() {
      _errorMessage = error;
      _isLoading = false;
      _isLoadingETA = false;
    });
  }

  void _debugPrintETA(List<dynamic> etaData) {
    if (kDebugMode && etaData.isNotEmpty) {
      final eta = etaData.first;
      print(
          'RouteData: ${eta.route} | ${eta.dir} | ${eta.serviceType} | by ${eta.co}');
      print('========================');
    }
  }

  String get _appBarTitle {
    final destination = Localizations.localeOf(context).languageCode == 'zh'
        ? widget.destinationTc
        : widget.destinationEn;

    final specialIndicator = widget.isCTB || widget.serviceType == '1'
        ? ''
        : ' | ${AppLocalizations.of(context)?.routeTitleSpecial ?? 'Special'}';

    return '${widget.routeNumber} >> $destination$specialIndicator';
  }
}

// Helper classes for cleaner code organization
class _RouteColors {
  const _RouteColors();

  static const Color ctbBackground = Color(0xFF0055B8);
  static const Color ctbForeground = Color(0xFFFFDD00);
  static const Color kmbBackground = Color(0xFF323232);
  static const Color kmbForeground = Color(0xFFF7A925);
  static const Color loadingIndicator = Color(0xFFF7A925);

  Color getBackgroundColor(bool isCTB) => isCTB ? ctbBackground : kmbBackground;

  Color getForegroundColor(bool isCTB) => isCTB ? ctbForeground : kmbForeground;
}

class _RouteStyles {
  const _RouteStyles();

  TextStyle getTitleStyle(BuildContext context) => TextStyle(
        fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 20.0),
      );

  TextStyle getETATitleStyle(BuildContext context) => TextStyle(
        fontSize: ResponsiveUtils.getOverflowSafeFontSize(context, 20.0),
        fontWeight: FontWeight.bold,
      );

  BoxDecoration getETABlockDecoration(BuildContext context) => BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        border: Border.all(
          color: AppColorScheme.successBorderColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(12),
      );
}
