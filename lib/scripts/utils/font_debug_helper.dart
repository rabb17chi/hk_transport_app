import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// Font Debug Helper
///
/// 幫助調試字體縮放和溢出問題的工具類
class FontDebugHelper {
  // Private constructor to prevent instantiation
  FontDebugHelper._();

  /// 顯示當前設備的字體縮放信息
  static Widget buildDebugInfo(BuildContext context) {
    final devicePixelRatio = ResponsiveUtils.getDevicePixelRatio(context);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenSize = MediaQuery.of(context).size;

    // 計算各種縮放策略的結果
    final baseFontSize = 12.0;
    final normalScale = ResponsiveUtils.getCurrentScalingFactor(
      context,
      strategy: ScalingStrategy.normalScreenBased,
    );
    final safeFontSize =
        ResponsiveUtils.getOverflowSafeFontSize(context, baseFontSize);
    final responsiveFontSize =
        ResponsiveUtils.getResponsiveFontSize(context, baseFontSize);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '字體縮放調試信息',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('設備像素密度', '${devicePixelRatio.toStringAsFixed(2)}x'),
            _buildInfoRow('系統文字縮放', '${textScaleFactor.toStringAsFixed(2)}x'),
            _buildInfoRow('螢幕尺寸',
                '${screenSize.width.toInt()} x ${screenSize.height.toInt()}'),
            _buildInfoRow('螢幕面積',
                '${(screenSize.width * screenSize.height).toInt()} px²'),
            const Divider(),
            Text(
              '縮放計算結果',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('基準字體大小', '${baseFontSize.toInt()}px'),
            _buildInfoRow('響應式縮放倍數', '${normalScale.toStringAsFixed(2)}x'),
            _buildInfoRow(
                '響應式字體大小', '${responsiveFontSize.toStringAsFixed(1)}px'),
            _buildInfoRow('溢出安全字體大小', '${safeFontSize.toStringAsFixed(1)}px'),
            const Divider(),
            Text(
              '建議設置',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange[700],
              ),
            ),
            const SizedBox(height: 8),
            _buildRecommendation(context),
          ],
        ),
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'monospace',
              color: Colors.blue[700],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildRecommendation(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final isOverflowRisk = ResponsiveUtils.isTextScaleTooLarge(context);

    if (isOverflowRisk) {
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.red[50],
          border: Border.all(color: Colors.red[200]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Text(
                  '溢出風險警告',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '系統文字縮放 ${textScaleFactor.toStringAsFixed(1)}x 過大，建議：',
              style: TextStyle(color: Colors.red[600]),
            ),
            const SizedBox(height: 4),
            Text('• 使用 getOverflowSafeFontSize() 方法'),
            Text('• 考慮減少基準字體大小'),
            Text('• 檢查 UI 布局是否足夠靈活'),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.green[50],
          border: Border.all(color: Colors.green[200]!),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 20),
            const SizedBox(width: 8),
            Text(
              '字體縮放正常，無溢出風險',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
      );
    }
  }

  /// 在控制台輸出調試信息
  static void printDebugInfo(BuildContext context) {
    final devicePixelRatio = ResponsiveUtils.getDevicePixelRatio(context);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenSize = MediaQuery.of(context).size;

    print('=== 字體縮放調試信息 ===');
    print('設備像素密度: ${devicePixelRatio.toStringAsFixed(2)}x');
    print('系統文字縮放: ${textScaleFactor.toStringAsFixed(2)}x');
    print('螢幕尺寸: ${screenSize.width.toInt()} x ${screenSize.height.toInt()}');
    print('螢幕面積: ${(screenSize.width * screenSize.height).toInt()} px²');
    print('是否溢出風險: ${ResponsiveUtils.isTextScaleTooLarge(context)}');
    print('========================');
  }
}
