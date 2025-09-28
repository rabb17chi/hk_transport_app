import 'package:flutter/material.dart';
import 'responsive_utils.dart';

/// Example usage of ResponsiveUtils with different scaling strategies
///
/// This file demonstrates how to use different scaling strategies
/// for various UI components
class ResponsiveExample {
  /// Example 1: Normal screen-based scaling (recommended)
  /// 以正常螢幕為基準，大螢幕放大，小螢幕縮小
  static Widget buildNormalScreenExample(BuildContext context) {
    return Text(
      'Normal Screen Based',
      style: TextStyle(
        fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
        // 使用預設策略：normalScreenBased
      ),
    );
  }

  /// Example 2: Large screen-based scaling
  /// 以大螢幕為基準，其他螢幕縮小
  static Widget buildLargeScreenExample(BuildContext context) {
    return Text(
      'Large Screen Based',
      style: TextStyle(
        fontSize: ResponsiveUtils.getResponsiveFontSize(
          context,
          16.0,
          strategy: ScalingStrategy.largeScreenBased,
        ),
      ),
    );
  }

  /// Example 3: Small screen-based scaling
  /// 以小螢幕為基準，其他螢幕放大
  static Widget buildSmallScreenExample(BuildContext context) {
    return Text(
      'Small Screen Based',
      style: TextStyle(
        fontSize: ResponsiveUtils.getResponsiveFontSize(
          context,
          16.0,
          strategy: ScalingStrategy.smallScreenBased,
        ),
      ),
    );
  }

  /// Example 4: Auto-recommended strategy
  /// 根據設備特性自動選擇最佳策略
  static Widget buildAutoRecommendedExample(BuildContext context) {
    final recommendedStrategy = ResponsiveUtils.getRecommendedStrategy(context);

    return Column(
      children: [
        Text(
          'Auto Recommended',
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(
              context,
              16.0,
              strategy: recommendedStrategy,
            ),
          ),
        ),
        Text(
          'Strategy: ${recommendedStrategy.name}',
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12.0),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// Example 5: Debug information
  /// 顯示當前設備的縮放信息
  static Widget buildDebugInfo(BuildContext context) {
    final devicePixelRatio = ResponsiveUtils.getDevicePixelRatio(context);
    final normalScale = ResponsiveUtils.getCurrentScalingFactor(
      context,
      strategy: ScalingStrategy.normalScreenBased,
    );
    final largeScale = ResponsiveUtils.getCurrentScalingFactor(
      context,
      strategy: ScalingStrategy.largeScreenBased,
    );
    final smallScale = ResponsiveUtils.getCurrentScalingFactor(
      context,
      strategy: ScalingStrategy.smallScreenBased,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Info:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Pixel Ratio: ${devicePixelRatio.toStringAsFixed(2)}'),
            Text('Normal Scale: ${normalScale.toStringAsFixed(2)}'),
            Text('Large Scale: ${largeScale.toStringAsFixed(2)}'),
            Text('Small Scale: ${smallScale.toStringAsFixed(2)}'),
            Text(
                'Is High Density: ${ResponsiveUtils.isHighDensityDisplay(context)}'),
            Text(
                'Is Low Density: ${ResponsiveUtils.isLowDensityDisplay(context)}'),
          ],
        ),
      ),
    );
  }
}
