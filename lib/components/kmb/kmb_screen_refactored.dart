import 'package:flutter/material.dart';
import 'package:hk_transport_app/components/kmb/input_keyboard.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../scripts/ctb/ctb_api_service.dart';
import 'package:hk_transport_app/l10n/app_localizations.dart';
import '../../scripts/utils/settings_service.dart';
import '../../theme/app_color_scheme.dart';
import 'route_banner.dart';
import 'route_stations_screen.dart';
import '../ui/transport_route_banner.dart';

class KMBTestScreenRefactored extends StatefulWidget {
  const KMBTestScreenRefactored({super.key});

  @override
  State<KMBTestScreenRefactored> createState() =>
      _KMBTestScreenRefactoredState();
}

// Unified item to merge KMB and CTB for rendering and sorting
enum _Operator { kmb, ctb }

class _UnifiedRoute {
  final _Operator operatorType;
  final String routeNo;
  final KMBRoute? kmb;
  final CTBRoute? ctb;
  _UnifiedRoute.kmb(this.kmb)
      : operatorType = _Operator.kmb,
        routeNo = kmb!.route,
        ctb = null;
  _UnifiedRoute.ctb(this.ctb)
      : operatorType = _Operator.ctb,
        routeNo = ctb!.route,
        kmb = null;
}

class _KMBTestScreenRefactoredState extends State<KMBTestScreenRefactored> {
  List<KMBRoute> _routes = [];
  List<KMBStop> _stops = [];
  List<CTBRoute> _ctbRoutes = [];
  List<_UnifiedRoute> _unifiedFilteredRoutes = [];

  bool _isLoading = false;
  String _errorMessage = '';
  String _selectedRouteKey = ''; // Changed to store routeKey (route + bound)

  // Text controller for keyboard communication
  final TextEditingController _searchController = TextEditingController();
  List<KMBRoute> _filteredRoutes = [];
  List<CTBRoute> _filteredCtbRoutes = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _searchController.addListener(_filterRoutes);
    // Listen to special routes changes
    SettingsService.showSpecialRoutesNotifier
        .addListener(_onSpecialRoutesChanged);
  }

  @override
  void dispose() {
    SettingsService.showSpecialRoutesNotifier
        .removeListener(_onSpecialRoutesChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSpecialRoutesChanged() {
    if (mounted) {
      setState(() {
        _filteredRoutes = _applyServiceTypeFilter(_routes);
      });
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final routes = await KMBApiService.getAllRoutes();
      final stops = await KMBApiService.getAllStops();
      // Load CTB routes (from cache if available)
      List<CTBRoute> ctbRoutes = [];
      try {
        ctbRoutes = await CTBApiService.getAllRoutes();
      } catch (_) {}

      setState(() {
        _routes = routes; // keep all service types
        _stops = stops;
        _filteredRoutes = _applyServiceTypeFilter(routes);
        _ctbRoutes = ctbRoutes;
        _filteredCtbRoutes =
            ctbRoutes; // initial (empty query shows none later)
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
        _filteredCtbRoutes = <CTBRoute>[]; // hide CTB list when no query
        _unifiedFilteredRoutes = <_UnifiedRoute>[];
      } else {
        _filteredRoutes = _applyServiceTypeFilter(_routes)
            .where((route) =>
                route.route.toUpperCase().startsWith(query) ||
                route.route.toUpperCase() == query)
            .toList();
        _filteredCtbRoutes = _ctbRoutes
            .where((r) =>
                r.route.toUpperCase().startsWith(query) ||
                r.route.toUpperCase() == query)
            .toList();

        // Merge and sort
        _unifiedFilteredRoutes = <_UnifiedRoute>[
          ..._filteredRoutes.map((r) => _UnifiedRoute.kmb(r)),
          ..._filteredCtbRoutes.map((r) => _UnifiedRoute.ctb(r)),
        ];
        _unifiedFilteredRoutes.sort((a, b) =>
            a.routeNo.toUpperCase().compareTo(b.routeNo.toUpperCase()));
      }
    });
  }

  List<KMBRoute> _applyServiceTypeFilter(List<KMBRoute> src) {
    if (SettingsService.showSpecialRoutesNotifier.value) {
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

    // Consider both KMB and CTB route numbers when suggesting next characters
    final allRouteStrings = <String>[
      ..._routes.map((r) => r.route.toUpperCase()),
      ..._ctbRoutes.map((r) => r.route.toUpperCase()),
    ];

    final prefix = currentInput.toUpperCase();
    for (final routeStr in allRouteStrings) {
      if (routeStr.startsWith(prefix) &&
          routeStr.length > currentInput.length) {
        final nextChar = routeStr[currentInput.length];
        availableChars.add(nextChar);
      }
    }

    // Debug: Print available characters for debugging
    if (currentInput.isNotEmpty) {
      print('Input: "$currentInput" -> Available next chars: $availableChars');
      final matches = [
        ..._routes
            .where((route) => route.route.toUpperCase().startsWith(prefix))
            .map((r) => 'KMB:${r.route}(${r.serviceType})'),
        ..._ctbRoutes
            .where((route) => route.route.toUpperCase().startsWith(prefix))
            .map((r) => 'CTB:${r.route}')
      ];
      print('Matching routes: $matches');
    }

    return availableChars;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String hintRouteText = l10n.kmbSearchHint;
    final String noMatchTitle = l10n.kmbNoMatchTitle;
    final String noMatchSubtitle = l10n.kmbNoMatchSubtitle;
    final String emptyTitle = l10n.kmbEmptyTitle;
    final String emptySubtitle = l10n.kmbEmptySubtitle;
    return Scaffold(
      body: SafeArea(
        child: _isLoading && _routes.isEmpty && _stops.isEmpty
            ? const Center(child: CircularProgressIndicator())
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
                                  decoration: InputDecoration(
                                    hintText: hintRouteText,
                                    counterText: "",
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.search),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  readOnly: true, // Disable virtual keyboard
                                  maxLength: 4,
                                ),
                                const SizedBox(height: 8),
                                if (_searchController.text.isNotEmpty) ...[
                                  if (_unifiedFilteredRoutes.isNotEmpty) ...[
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            _unifiedFilteredRoutes.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              _unifiedFilteredRoutes[index];
                                          if (item.operatorType ==
                                              _Operator.kmb) {
                                            final route = item.kmb!;
                                            final routeKey =
                                                '${route.route}_${route.bound}';
                                            final isSelected =
                                                _selectedRouteKey == routeKey;
                                            return RouteBanner(
                                              route: route,
                                              isSelected: isSelected,
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RouteStationsScreen(
                                                      routeKey: routeKey,
                                                      routeNumber: route.route,
                                                      bound: route.bound,
                                                      serviceType:
                                                          route.serviceType,
                                                      destinationTc:
                                                          route.destTc,
                                                      destinationEn:
                                                          route.destEn,
                                                    ),
                                                  ),
                                                );
                                                _onRouteSelected(routeKey);
                                              },
                                            );
                                          } else {
                                            final ctb = item.ctb!;
                                            return Column(
                                              children: [
                                                TransportRouteBanner(
                                                  titleTop: ctb.destTc,
                                                  titleBottom: ctb.destEn,
                                                  routeNumber: ctb.route,
                                                  backgroundColor: AppColorScheme
                                                      .ctbBannerBackgroundColor,
                                                  textColor: AppColorScheme
                                                      .ctbBannerTextColor,
                                                  onTap: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RouteStationsScreen(
                                                          routeKey:
                                                              '${ctb.route}_O',
                                                          routeNumber:
                                                              ctb.route,
                                                          bound: 'O',
                                                          destinationTc:
                                                              ctb.destTc,
                                                          destinationEn:
                                                              ctb.destEn,
                                                          isCTB: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                TransportRouteBanner(
                                                  titleTop: ctb.origTc,
                                                  titleBottom: ctb.origEn,
                                                  routeNumber: ctb.route,
                                                  backgroundColor: AppColorScheme
                                                      .ctbBannerBackgroundColor,
                                                  textColor: AppColorScheme
                                                      .ctbBannerTextColor,
                                                  onTap: () async {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RouteStationsScreen(
                                                          routeKey:
                                                              '${ctb.route}_I',
                                                          routeNumber:
                                                              ctb.route,
                                                          bound: 'I',
                                                          destinationTc:
                                                              ctb.origTc,
                                                          destinationEn:
                                                              ctb.origEn,
                                                          isCTB: true,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ] else ...[
                                    const SizedBox(height: 16),
                                    Center(
                                      child: Column(
                                        children: [
                                          const Icon(Icons.search_off,
                                              size: 48,
                                              color: AppColorScheme
                                                  .searchIconColor),
                                          const SizedBox(height: 8),
                                          Text(
                                            noMatchTitle,
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            noMatchSubtitle,
                                            style: const TextStyle(
                                                color: AppColorScheme
                                                    .searchTextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ] else ...[
                                  const SizedBox(height: 16),
                                  Center(
                                    child: Column(
                                      children: [
                                        const Icon(Icons.search,
                                            size: 48,
                                            color:
                                                AppColorScheme.searchIconColor),
                                        const SizedBox(height: 8),
                                        Text(
                                          emptyTitle,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          emptySubtitle,
                                          style: const TextStyle(
                                              color: AppColorScheme
                                                  .exampleTextColor),
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
                      // Custom Keyboard - Fixed at bottom
                      const Spacer(),
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
      ),
    );
  }
}
