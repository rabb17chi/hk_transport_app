import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../scripts/utils/settings_service.dart';
import '../../../scripts/utils/text_utils.dart';
import '../../../scripts/utils/responsive_utils.dart';
import '../../../l10n/locale_utils.dart';
import '../../../theme/app_color_scheme.dart';
import '../../ui/transport_route_banner.dart';

class BusSettingStep extends StatefulWidget {
  const BusSettingStep({super.key});

  @override
  State<BusSettingStep> createState() => _BusSettingStepState();
}

class _BusSettingStepState extends State<BusSettingStep> {
  late bool _showSpecial;
  late bool _displayFull;

  @override
  void initState() {
    super.initState();
    _showSpecial = SettingsService.showSpecialRoutesNotifier.value;
    _displayFull = SettingsService.displayBusFullNameNotifier.value;
    SettingsService.showSpecialRoutesNotifier.addListener(_onSpecialChanged);
    SettingsService.displayBusFullNameNotifier.addListener(_onFullChanged);
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
                border: Border.all(color: AppColorScheme.grey300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.dataOpsSpecialToggle,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                    context, 18.0),
                              ),
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
                border: Border.all(color: AppColorScheme.grey300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          loc.dataOpsDisplayBusFullName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                fontSize: ResponsiveUtils.getResponsiveFontSize(
                                    context, 18.0),
                              ),
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
            Center(
              child: Text(
                loc.firstTimeSettingsStored,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize:
                          ResponsiveUtils.getResponsiveFontSize(context, 16.0),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialDemo(BuildContext context) {
    final isChinese = LocaleUtils.isChinese(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Normal route banner
          AbsorbPointer(
            absorbing: true,
            child: TransportRouteBanner(
              titleTop: isChinese ? '青衣碼頭' : 'TSING YI FERRY',
              titleBottom: isChinese ? 'TSING YI FERRY' : '青衣碼頭',
              routeNumber: '49X',
              backgroundColor: AppColorScheme.kmbBannerBackgroundColor,
              textColor: AppColorScheme.kmbBannerTextColor,
              borderColor: AppColorScheme.kmbBannerBorderColor,
              shadowColor: AppColorScheme.shadowColorDark,
            ),
          ),
          // Special route banner (only shown when toggle is on)
          if (_showSpecial) ...[
            const SizedBox(height: 8),
            AbsorbPointer(
              absorbing: true,
              child: TransportRouteBanner(
                titleTop: isChinese ? '青衣碼頭(特)' : 'TSING YI FERRY (Sp)',
                titleBottom: isChinese ? 'TSING YI FERRY (Sp)' : '青衣碼頭(特)',
                routeNumber: '49X',
                backgroundColor: AppColorScheme.specialRouteBackgroundColor,
                textColor: AppColorScheme.kmbBannerTextColor,
                borderColor: AppColorScheme.specialRouteBorderColor,
                shadowColor: AppColorScheme.specialRouteShadowColor,
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
        title: Text(
          cleaned,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
              ),
        ),
        subtitle: Text(
          sub,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14.0),
              ),
        ),
      ),
    );
  }
}
