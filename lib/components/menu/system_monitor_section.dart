import 'package:flutter/material.dart';
import '../../main.dart';
import '../../theme/app_color_scheme.dart';
import '../../l10n/app_localizations.dart';

/// System Monitor Section
///
/// Displays system scaling and device information
class SystemMonitorSection extends StatelessWidget {
  const SystemMonitorSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ExpansionTileTheme(
      data: const ExpansionTileThemeData(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
        ),
        collapsedShape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.transparent, width: 0),
        ),
      ),
      child: ExpansionTile(
        leading: const Icon(Icons.monitor),
        title: Text(loc.systemMonitorTitle),
        subtitle: Text(loc.systemMonitorSubtitle),
        trailing: const SizedBox.shrink(),
        children: [
          if (SystemInfo.hasLogged) ...[
            _buildInfoCard(
              loc.systemMonitorScreenScaling,
              [
                _buildInfoRow(loc.systemMonitorTextScaling,
                    '${SystemInfo.textScaleFactor?.toStringAsFixed(2) ?? 'N/A'}x'),
                _buildInfoRow(loc.systemMonitorPixelDensity,
                    '${SystemInfo.devicePixelRatio?.toStringAsFixed(2) ?? 'N/A'}x'),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              loc.systemMonitorScreenSize,
              [
                _buildInfoRow(loc.systemMonitorWidth,
                    '${SystemInfo.screenSize?.width.toStringAsFixed(1) ?? 'N/A'}px'),
                _buildInfoRow(loc.systemMonitorHeight,
                    '${SystemInfo.screenSize?.height.toStringAsFixed(1) ?? 'N/A'}px'),
                _buildInfoRow(loc.systemMonitorAvailableHeight, '${_getAvailableHeight()}px'),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              loc.systemMonitorSystemInfo,
              [
                _buildInfoRow(loc.systemMonitorThemeMode, _getBrightnessText(context)),
                _buildInfoRow(loc.systemMonitorStatusBar,
                    '${SystemInfo.padding?.top.toStringAsFixed(1) ?? 'N/A'}px'),
                _buildInfoRow(loc.systemMonitorBottomSafeArea,
                    '${SystemInfo.padding?.bottom.toStringAsFixed(1) ?? 'N/A'}px'),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              loc.systemMonitorScalingStatus,
              [
                _buildInfoRow(loc.systemMonitorTextScaleStatus, _getTextScaleStatus(context)),
                _buildInfoRow(loc.systemMonitorRecommendation, _getRecommendation(context)),
              ],
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  loc.systemMonitorLoading,
                  style: const TextStyle(color: AppColorScheme.grey500),
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getAvailableHeight() {
    if (SystemInfo.screenSize == null || SystemInfo.padding == null) {
      return 'N/A';
    }
    final availableHeight = SystemInfo.screenSize!.height -
        SystemInfo.padding!.top -
        SystemInfo.padding!.bottom;
    return availableHeight.toStringAsFixed(1);
  }

  String _getBrightnessText(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    switch (SystemInfo.platformBrightness) {
      case Brightness.light:
        return loc.systemMonitorLightMode;
      case Brightness.dark:
        return loc.systemMonitorDarkMode;
      default:
        return loc.systemMonitorUnknown;
    }
  }

  String _getTextScaleStatus(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final scale = SystemInfo.textScaleFactor ?? 1.0;
    final scaleStr = scale.toStringAsFixed(1);
    if (scale <= 1.0) {
      return loc.systemMonitorNormal(scaleStr);
    } else if (scale <= 1.3) {
      return loc.systemMonitorSlightZoom(scaleStr);
    } else if (scale <= 1.5) {
      return loc.systemMonitorMediumZoom(scaleStr);
    } else {
      return loc.systemMonitorHighZoom(scaleStr);
    }
  }

  String _getRecommendation(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final scale = SystemInfo.textScaleFactor ?? 1.0;
    if (scale <= 1.0) {
      return loc.systemMonitorUINormal;
    } else if (scale <= 1.3) {
      return loc.systemMonitorUISlightImpact;
    } else if (scale <= 1.5) {
      return loc.systemMonitorUICheckLayout;
    } else {
      return loc.systemMonitorUIOptimize;
    }
  }
}
