import 'package:flutter/material.dart';

/// Scaling strategy for responsive sizing
enum ScalingStrategy {
  /// Scale from normal screen (recommended)
  /// Small screens get smaller, large screens get larger
  normalScreenBased,

  /// Scale from large screen
  /// All screens scale down from large screen baseline
  largeScreenBased,

  /// Scale from small screen
  /// All screens scale up from small screen baseline
  smallScreenBased,
}

/// Responsive Utils
///
/// Utility class for creating responsive UI elements that scale
/// appropriately across different device pixel ratios and screen sizes
class ResponsiveUtils {
  // Private constructor to prevent instantiation
  ResponsiveUtils._();

  /// Reference scale where base sizes look good
  /// This is the device pixel ratio where the base sizes are optimized
  static const double referenceScale = 2.5;

  /// Maximum device pixel ratio to consider for scaling
  /// Devices with higher ratios will be treated as this value
  static const double maxScale = 2.5;

  /// Minimum scale factor to apply
  /// Prevents text from becoming too small
  static const double minScale = 0.9;

  /// Default scaling strategy
  static const ScalingStrategy defaultStrategy =
      ScalingStrategy.normalScreenBased;

  /// Calculate responsive size based on device pixel ratio
  ///
  /// [baseSize] - The base size that looks good at referenceScale
  /// [context] - BuildContext to access MediaQuery
  /// [strategy] - Scaling strategy to use
  /// [considerTextScale] - Whether to consider system text scale factor
  /// Returns a scaled size appropriate for the current device
  static double getResponsiveSize(
    BuildContext context,
    double baseSize, {
    ScalingStrategy strategy = defaultStrategy,
    bool considerTextScale = true,
  }) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    double scaleFactor;

    switch (strategy) {
      case ScalingStrategy.normalScreenBased:
        // 2.5x is the reference scale, for every < 2.5x, multiply by 1.x
        if (devicePixelRatio >= referenceScale) {
          // 2.5x and larger devices: use reference size
          scaleFactor = 1.0;
        } else {
          // Smaller devices: scale up by 1.x
          scaleFactor = referenceScale / devicePixelRatio;
          // Apply minimum scale limit
          scaleFactor = scaleFactor.clamp(minScale, 2.5);
        }
        break;

      case ScalingStrategy.largeScreenBased:
        // 以大螢幕為基準，其他螢幕縮小
        final largeScreenRatio = 2.0; // 假設大螢幕是 2.0x
        scaleFactor = devicePixelRatio >= largeScreenRatio
            ? 1.0
            : devicePixelRatio / largeScreenRatio;
        break;

      case ScalingStrategy.smallScreenBased:
        // 以小螢幕為基準，其他螢幕放大
        final smallScreenRatio = 1.0; // 假設小螢幕是 1.0x
        scaleFactor = devicePixelRatio <= smallScreenRatio
            ? 1.0
            : devicePixelRatio / smallScreenRatio;
        break;
    }

    // 考慮系統文字縮放設置
    if (considerTextScale) {
      // 當文字縮放過大時，減少響應式縮放以避免溢出
      if (textScaleFactor > 1.3) {
        // 文字縮放過大時，使用較保守的縮放
        scaleFactor = scaleFactor * (1.0 / textScaleFactor);
      }
    }

    return baseSize * scaleFactor;
  }

  /// Calculate responsive font size
  ///
  /// [baseFontSize] - The base font size that looks good at referenceScale
  /// [context] - BuildContext to access MediaQuery
  /// [strategy] - Scaling strategy to use
  /// [considerTextScale] - Whether to consider system text scale factor
  /// Returns a scaled font size appropriate for the current device
  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize, {
    ScalingStrategy strategy = defaultStrategy,
    bool considerTextScale = true,
  }) {
    return getResponsiveSize(context, baseFontSize,
        strategy: strategy, considerTextScale: considerTextScale);
  }

  /// Calculate responsive icon size
  ///
  /// [baseIconSize] - The base icon size that looks good at referenceScale
  /// [context] - BuildContext to access MediaQuery
  /// [strategy] - Scaling strategy to use
  /// Returns a scaled icon size appropriate for the current device
  static double getResponsiveIconSize(
    BuildContext context,
    double baseIconSize, {
    ScalingStrategy strategy = defaultStrategy,
  }) {
    return getResponsiveSize(context, baseIconSize, strategy: strategy);
  }

  /// Calculate responsive padding
  ///
  /// [basePadding] - The base padding that looks good at referenceScale
  /// [context] - BuildContext to access MediaQuery
  /// [strategy] - Scaling strategy to use
  /// Returns a scaled padding appropriate for the current device
  static EdgeInsets getResponsivePadding(
    BuildContext context,
    double basePadding, {
    ScalingStrategy strategy = defaultStrategy,
  }) {
    final scaledPadding =
        getResponsiveSize(context, basePadding, strategy: strategy);
    return EdgeInsets.all(scaledPadding);
  }

  /// Calculate responsive border radius
  ///
  /// [baseRadius] - The base border radius that looks good at referenceScale
  /// [context] - BuildContext to access MediaQuery
  /// [strategy] - Scaling strategy to use
  /// Returns a scaled border radius appropriate for the current device
  static double getResponsiveBorderRadius(
    BuildContext context,
    double baseRadius, {
    ScalingStrategy strategy = defaultStrategy,
  }) {
    return getResponsiveSize(context, baseRadius, strategy: strategy);
  }

  /// Get device pixel ratio for debugging
  static double getDevicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Check if device has high density display
  static bool isHighDensityDisplay(BuildContext context) {
    return getDevicePixelRatio(context) > 2.0;
  }

  /// Check if device has low density display
  static bool isLowDensityDisplay(BuildContext context) {
    return getDevicePixelRatio(context) < 1.5;
  }

  /// Get recommended scaling strategy based on device characteristics
  ///
  /// This method analyzes the device and recommends the best scaling strategy
  /// for optimal user experience
  static ScalingStrategy getRecommendedStrategy(BuildContext context) {
    final devicePixelRatio = getDevicePixelRatio(context);
    final screenSize = MediaQuery.of(context).size;
    final screenArea = screenSize.width * screenSize.height;

    // 小螢幕設備：建議使用 normalScreenBased 或 smallScreenBased
    if (screenArea < 200000) {
      // 小於約 447x447 像素
      return ScalingStrategy.normalScreenBased;
    }

    // 高密度大螢幕：建議使用 largeScreenBased
    if (devicePixelRatio >= 2.5 && screenArea > 500000) {
      return ScalingStrategy.largeScreenBased;
    }

    // 預設使用 normalScreenBased
    return ScalingStrategy.normalScreenBased;
  }

  /// Get scaling factor for current device
  ///
  /// Returns the actual scaling factor being applied
  static double getCurrentScalingFactor(
    BuildContext context, {
    ScalingStrategy strategy = defaultStrategy,
  }) {
    final devicePixelRatio = getDevicePixelRatio(context);

    switch (strategy) {
      case ScalingStrategy.normalScreenBased:
        return devicePixelRatio / referenceScale;

      case ScalingStrategy.largeScreenBased:
        final largeScreenRatio = 2.0;
        return devicePixelRatio >= largeScreenRatio
            ? 1.0
            : devicePixelRatio / largeScreenRatio;

      case ScalingStrategy.smallScreenBased:
        final smallScreenRatio = 1.0;
        return devicePixelRatio <= smallScreenRatio
            ? 1.0
            : devicePixelRatio / smallScreenRatio;
    }
  }

  /// Calculate safe font size that prevents overflow
  ///
  /// This method calculates a font size that considers both device pixel ratio
  /// and system text scale factor to prevent UI overflow
  static double getSafeFontSize(
    BuildContext context,
    double baseFontSize, {
    ScalingStrategy strategy = defaultStrategy,
    double maxScaleFactor = 1.5, // 最大縮放倍數
  }) {
    final devicePixelRatio = getDevicePixelRatio(context);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // 計算基礎縮放
    double baseScale;
    switch (strategy) {
      case ScalingStrategy.normalScreenBased:
        baseScale = devicePixelRatio / referenceScale;
        break;
      case ScalingStrategy.largeScreenBased:
        final largeScreenRatio = 2.0;
        baseScale = devicePixelRatio >= largeScreenRatio
            ? 1.0
            : devicePixelRatio / largeScreenRatio;
        break;
      case ScalingStrategy.smallScreenBased:
        final smallScreenRatio = 1.0;
        baseScale = devicePixelRatio <= smallScreenRatio
            ? 1.0
            : devicePixelRatio / smallScreenRatio;
        break;
    }

    // 考慮文字縮放，但限制最大縮放倍數
    double finalScale = baseScale;
    if (textScaleFactor > 1.0) {
      // 當系統文字縮放過大時，使用較保守的縮放
      finalScale = baseScale * (1.0 / textScaleFactor);
    }

    // 限制最大縮放倍數
    finalScale = finalScale.clamp(0.5, maxScaleFactor);

    return baseFontSize * finalScale;
  }

  /// Check if current text scale factor might cause overflow
  static bool isTextScaleTooLarge(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return textScaleFactor > 1.3;
  }

  /// Get recommended font size for current device to prevent overflow
  static double getOverflowSafeFontSize(
    BuildContext context,
    double baseFontSize, {
    ScalingStrategy strategy = defaultStrategy,
  }) {
    final devicePixelRatio = getDevicePixelRatio(context);
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // 2.5x is the reference scale, for every < 2.5x, multiply by 1.x
    double scaleFactor;
    if (devicePixelRatio >= referenceScale) {
      // 2.5x and larger devices: use reference size
      scaleFactor = 1.0;
    } else {
      // Smaller devices: scale up by 1.x
      scaleFactor = referenceScale / devicePixelRatio;
      // Apply minimum scale limit
      scaleFactor = scaleFactor.clamp(minScale, 2.5);
    }

    // Apply text scale factor adjustment if needed
    if (textScaleFactor > 1.3) {
      scaleFactor = scaleFactor * (1.0 / textScaleFactor);
    }

    // Calculate final font size
    double finalSize = baseFontSize * scaleFactor;

    // Ensure minimum readability
    return finalSize.clamp(6.0, baseFontSize);
  }
}
