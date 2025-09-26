import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../scripts/utils/settings_service.dart';
import '../../../scripts/utils/text_utils.dart';
import '../../../l10n/locale_utils.dart';
import '../../../scripts/kmb/kmb_cache_service.dart';
import '../../../scripts/kmb/kmb_api_service.dart';
import '../../kmb/route_banner.dart';

class BusSettingStep extends StatefulWidget {
  const BusSettingStep({super.key});

  @override
  State<BusSettingStep> createState() => _BusSettingStepState();
}

class _BusSettingStepState extends State<BusSettingStep> {
  late bool _showSpecial;
  late bool _displayFull;
  List<KMBRoute> _routes49x = const [];

  @override
  void initState() {
    super.initState();
    _showSpecial = SettingsService.showSpecialRoutesNotifier.value;
    _displayFull = SettingsService.displayBusFullNameNotifier.value;
    SettingsService.showSpecialRoutesNotifier.addListener(_onSpecialChanged);
    SettingsService.displayBusFullNameNotifier.addListener(_onFullChanged);
    _load49xRoutes();
  }

  Future<void> _load49xRoutes() async {
    try {
      // Try cache first
      List<KMBRoute>? cached = await KMBCacheService.getCachedRoutes();
      List<KMBRoute> routes;
      if (cached == null || cached.isEmpty) {
        debugPrint(
            '[BusSettingStep] No cached routes found. Fetching from API...');
        routes = await KMBApiService.getAllRoutes();
      } else {
        routes = cached;
      }
      final variants =
          routes.where((r) => r.route.toUpperCase() == '49X').toList();
      setState(() => _routes49x = variants);
      debugPrint('[BusSettingStep] 49X variants: ${variants.length}');
      for (final r in variants) {
        debugPrint(
            '[BusSettingStep] 49X: bound=${r.bound}, serviceType=${r.serviceType}, destTc=${r.destTc}, destEn=${r.destEn}');
        // Try fetch route stops for each variant (bound/serviceType)
        try {
          final stops = await KMBApiService.getRouteStops(
              r.route, r.bound, r.serviceType);
          debugPrint(
              '[BusSettingStep] 49X ${r.bound}/${r.serviceType} stops: ${stops.length}');
          if (stops.isNotEmpty) {
            debugPrint(
                '[BusSettingStep] First stop: ${stops.first.stopNameTc} (${stops.first.stopNameEn})');
          }
        } catch (e) {
          debugPrint(
              '[BusSettingStep] Error fetching 49X stops for ${r.bound}/${r.serviceType}: $e');
        }
      }
    } catch (e) {
      debugPrint('[BusSettingStep] Error loading 49X routes: $e');
    }
  }

  @override
  void dispose() {
    SettingsService.showSpecialRoutesNotifier.removeListener(_onSpecialChanged);
    SettingsService.displayBusFullNameNotifier.removeListener(_onFullChanged);
    super.dispose();
  }

  void _onSpecialChanged() {
    setState(
        () => _showSpecial = SettingsService.showSpecialRoutesNotifier.value);
  }

  void _onFullChanged() {
    setState(
        () => _displayFull = SettingsService.displayBusFullNameNotifier.value);
  }

  Future<void> _toggleSpecial(bool v) async {
    await SettingsService.setShowSpecialRoutes(v);
  }

  Future<void> _toggleDisplayFull(bool v) async {
    await SettingsService.setDisplayBusFullName(v);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isChinese = LocaleUtils.isChinese(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Special Routes Toggle Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.dataOpsSpecialToggle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: _showSpecial,
                        onChanged: _toggleSpecial,
                      ),
                    ],
                  ),
                  _buildSpecialDemo(context),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Display Full Stop Name Toggle Section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.dataOpsDisplayBusFullName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: _displayFull,
                        onChanged: _toggleDisplayFull,
                      ),
                    ],
                  ),
                  _buildStopNameDemo(context, isChinese),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(child: Text(loc.firstTimeSettingsStored)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialDemo(BuildContext context) {
    // Choose main outbound (serviceType == '1')
    final mainOutbound = _routes49x.firstWhere(
      (r) => r.bound.toUpperCase() == 'O' && r.serviceType == '1',
      orElse: () => _routes49x.isNotEmpty
          ? _routes49x.first
          : KMBRoute(
              route: '49X',
              bound: 'O',
              serviceType: '1',
              origEn: '',
              origTc: '',
              origSc: '',
              destEn: '',
              destTc: '',
              destSc: '',
            ),
    );

    // Optional special outbound (serviceType != '1')
    final specialOutbound = _showSpecial
        ? _routes49x.firstWhere(
            (r) => r.bound.toUpperCase() == 'O' && r.serviceType != '1',
            orElse: () => KMBRoute(
              route: '49X',
              bound: 'O',
              serviceType: '2',
              origEn: '',
              origTc: '',
              origSc: '',
              destEn: '',
              destTc: '',
              destSc: '',
            ),
          )
        : null;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbsorbPointer(
            absorbing: true,
            child: RouteBanner(
              route: mainOutbound,
              isSelected: false,
              onTap: () {},
            ),
          ),
          if (specialOutbound != null) ...[
            const SizedBox(height: 8),
            AbsorbPointer(
              absorbing: true,
              child: RouteBanner(
                route: specialOutbound,
                isSelected: false,
                onTap: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStopNameDemo(BuildContext context, bool isChinese) {
    // Example stop names
    const en = 'Nathan Road, Tsim Sha Tsui';
    const zh = '尖沙咀 彌敦道';
    const codeSuffix = ' (HK123)';

    final main = isChinese ? zh : en;
    final sub = isChinese ? en : zh;

    final fullName = '$main$codeSuffix';
    final cleaned =
        TextUtils.cleanupStopDisplayName(fullName, displayFull: _displayFull);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.place),
        title: Text(cleaned, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(sub, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
