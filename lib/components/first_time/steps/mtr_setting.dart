import 'dart:async';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../scripts/utils/settings_service.dart';
import '../../../scripts/mtr/mtr_data.dart';
import '../../../l10n/locale_utils.dart';
import '../../../theme/app_color_scheme.dart';

class MTRSettingStep extends StatefulWidget {
  const MTRSettingStep({super.key});

  @override
  State<MTRSettingStep> createState() => _MTRSettingStepState();
}

class _MTRSettingStepState extends State<MTRSettingStep> {
  late bool _reverseStations;
  late bool _autoRefresh;
  Timer? _autoRefreshTimer;
  bool _timeToggle = false; // false => 5 min, true => 4 min

  @override
  void initState() {
    super.initState();
    _reverseStations = SettingsService.mtrReverseStationsNotifier.value;
    _autoRefresh = SettingsService.mtrAutoRefreshNotifier.value;
    SettingsService.mtrReverseStationsNotifier.addListener(_onReverseChanged);
    SettingsService.mtrAutoRefreshNotifier.addListener(_onAutoRefreshChanged);
    _setupAutoRefreshTimer();
  }

  @override
  void dispose() {
    SettingsService.mtrReverseStationsNotifier
        .removeListener(_onReverseChanged);
    SettingsService.mtrAutoRefreshNotifier
        .removeListener(_onAutoRefreshChanged);
    _cancelAutoRefreshTimer();
    super.dispose();
  }

  void _onReverseChanged() {
    setState(() =>
        _reverseStations = SettingsService.mtrReverseStationsNotifier.value);
  }

  void _onAutoRefreshChanged() {
    setState(() => _autoRefresh = SettingsService.mtrAutoRefreshNotifier.value);
    _setupAutoRefreshTimer();
  }

  Future<void> _toggleReverse(bool v) async {
    await SettingsService.setMtrReverseStations(v);
  }

  Future<void> _toggleAutoRefresh(bool v) async {
    await SettingsService.setMtrAutoRefresh(v);
  }

  void _setupAutoRefreshTimer() {
    _cancelAutoRefreshTimer();
    if (_autoRefresh) {
      // Reset to 5 min on enable
      _timeToggle = false;
      _autoRefreshTimer = Timer.periodic(const Duration(seconds: 15), (_) {
        if (!mounted) return;
        setState(() {
          // Toggle between 5min and 4min every 15s to simulate refresh
          _timeToggle = !_timeToggle;
        });
      });
    }
  }

  void _cancelAutoRefreshTimer() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Reverse station order
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
                          loc.dataOpsMtrReverse,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: _reverseStations,
                        onChanged: _toggleReverse,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildReverseDemo(context),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Auto refresh
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
                          loc.dataOpsMtrAutoRefresh,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: _autoRefresh,
                        onChanged: _toggleAutoRefresh,
                      ),
                    ],
                  ),
                  _autoRefresh
                      ? Text(
                          'Extra API-network will be used.',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 8),
                  _buildAutoRefreshDemo(context),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Center(child: Text(loc.firstTimeSettingsStored)),
          ],
        ),
      ),
    );
  }

  Widget _buildReverseDemo(BuildContext context) {
    // Airport Express (AEL) example: HOK -> KOW -> TSY -> AIR -> AWE
    const List<String> stationsNormal = ['HOK', 'KOW', 'TSY', 'AIR', 'AWE'];
    final List<String> stationsReversed = stationsNormal.reversed.toList();
    final List<String> items =
        _reverseStations ? stationsReversed : stationsNormal;
    final Color lineColor = MTRData.getLineColor('AEL');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((code) {
          final station = MTRData.getStationData(code);
          final isChinese = LocaleUtils.isChinese(context);
          final displayName = station == null
              ? code
              : (isChinese
                  ? (station['nameTc'] as String)
                  : (station['fullName'] as String));
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: lineColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              displayName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAutoRefreshDemo(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_autoRefresh ? Icons.autorenew : Icons.autorenew_outlined,
                  color: _autoRefresh ? Colors.green : Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Auto-refresh is ${_autoRefresh ? 'ON' : 'OFF'}.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          if (_autoRefresh) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColorScheme.chipBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _timeToggle ? '4 min' : '5 min',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColorScheme.textDarkColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
