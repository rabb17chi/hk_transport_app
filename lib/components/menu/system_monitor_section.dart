import 'package:flutter/material.dart';
import '../../main.dart';

/// System Monitor Section
///
/// Displays system scaling and device information
class SystemMonitorSection extends StatelessWidget {
  const SystemMonitorSection({super.key});

  @override
  Widget build(BuildContext context) {
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
        title: const Text('系統監控'),
        subtitle: const Text('設備縮放與屏幕信息'),
        trailing: const SizedBox.shrink(),
        children: [
          if (SystemInfo.hasLogged) ...[
            _buildInfoCard(
              '屏幕縮放',
              [
                _buildInfoRow('文字縮放',
                    '${SystemInfo.textScaleFactor?.toStringAsFixed(2) ?? 'N/A'}x'),
                _buildInfoRow('像素密度',
                    '${SystemInfo.devicePixelRatio?.toStringAsFixed(2) ?? 'N/A'}x'),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              '屏幕尺寸',
              [
                _buildInfoRow('寬度',
                    '${SystemInfo.screenSize?.width.toStringAsFixed(1) ?? 'N/A'}px'),
                _buildInfoRow('高度',
                    '${SystemInfo.screenSize?.height.toStringAsFixed(1) ?? 'N/A'}px'),
                _buildInfoRow('可用高度', '${_getAvailableHeight()}px'),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              '系統信息',
              [
                _buildInfoRow('主題模式', _getBrightnessText()),
                _buildInfoRow('狀態欄',
                    '${SystemInfo.padding?.top.toStringAsFixed(1) ?? 'N/A'}px'),
                _buildInfoRow('底部安全區',
                    '${SystemInfo.padding?.bottom.toStringAsFixed(1) ?? 'N/A'}px'),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoCard(
              '縮放狀態',
              [
                _buildInfoRow('文字縮放狀態', _getTextScaleStatus()),
                _buildInfoRow('建議', _getRecommendation()),
              ],
            ),
          ] else ...[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  '系統信息載入中...',
                  style: TextStyle(color: Colors.grey),
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

  String _getBrightnessText() {
    switch (SystemInfo.platformBrightness) {
      case Brightness.light:
        return '淺色模式';
      case Brightness.dark:
        return '深色模式';
      default:
        return '未知';
    }
  }

  String _getTextScaleStatus() {
    final scale = SystemInfo.textScaleFactor ?? 1.0;
    if (scale <= 1.0) {
      return '正常 (${scale.toStringAsFixed(1)}x)';
    } else if (scale <= 1.3) {
      return '輕微放大 (${scale.toStringAsFixed(1)}x)';
    } else if (scale <= 1.5) {
      return '中等放大 (${scale.toStringAsFixed(1)}x)';
    } else {
      return '高度放大 (${scale.toStringAsFixed(1)}x)';
    }
  }

  String _getRecommendation() {
    final scale = SystemInfo.textScaleFactor ?? 1.0;
    if (scale <= 1.0) {
      return 'UI 顯示正常';
    } else if (scale <= 1.3) {
      return 'UI 可能略有影響';
    } else if (scale <= 1.5) {
      return '建議檢查 UI 佈局';
    } else {
      return '需要優化 UI 響應式設計';
    }
  }
}
