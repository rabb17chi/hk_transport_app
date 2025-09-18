import 'package:flutter/material.dart';

class AppColorScheme {
  // Private constructor to prevent instantiation
  AppColorScheme._();

  // ============================================================================
  // BOOKMARK & SELECTION COLORS
  // ============================================================================

  static const Color bookmarkedColor = Color(0xFFF8BBD9);

  static const Color selectedColor = Color(0xFF2196F3);

  static const Color activeNavColor = Color(0xFF1976D2);

  static const Color inactiveColor = Color(0xFF9E9E9E);

  static const Color unSelectedColor = Color(0xFF9E9E9E);

  static const Color unSelectedColorDark = Color(0xFF757575);

  // ============================================================================
  // BUTTON & INTERACTION COLORS
  // ============================================================================

  static const Color buttonColor = Color(0xFF1976D2);

  static const Color buttonSecondaryColor = Color(0xFF757575);

  static const Color dangerColor = Color(0xFFD32F2F);

  static const Color successColor = Color(0xFF388E3C);

  static const Color warningColor = Color(0xFFF57C00);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  static const Color textMainColor = Color(0xFF212121);

  static const Color textSecondaryColor = Color(0xFF757575);

  static const Color textMutedColor = Color(0xFFA0A0A0);

  static const Color textOnLightColor = Color(0xFF424242);

  // ============================================================================
  // BACKGROUND COLORS
  // ============================================================================

  static const Color backgroundMainColor = Color(0xFFFFFFFF);

  static const Color backgroundSecondaryColor = Color(0xFFF5F5F5);

  static const Color backgroundSelectedColor = Color(0xFFE3F2FD);

  static const Color backgroundDisabledColor = Color(0xFFEEEEEE);

  // ============================================================================
  // TRANSPORT MODE COLORS
  // ============================================================================

  static const Color mtrColor = Color(0xFF1976D2);

  static const Color kmbColor = Color(0xFFFF9800);

  static const Color mtrModeColor = Color(0xFF1976D2);

  static const Color kmbModeColor = Color(0xFFFF9800);

  // ============================================================================
  // KMB SPECIFIC COLORS
  // ============================================================================

  static const Color kmbBannerBackgroundColor = Color(0xFF323232);

  static const Color kmbBannerTextColor = Color(0xFFF7A925);

  static const Color kmbBannerBorderColor = Color(0xFF757575);

  // ============================================================================
  // MTR LINE COLORS (from mtr_data.dart)
  // ============================================================================

  static const Color mtrIslandLineColor = Color(0xFF0066CC);

  static const Color mtrTsuenWanLineColor = Color(0xFFE2231A);

  static const Color mtrKwunTongLineColor = Color(0xFF00B04F);

  static const Color mtrTseungKwanOLineColor = Color(0xFF6B208B);

  static const Color mtrTungChungLineColor = Color(0xFFFE7F1D);

  static const Color mtrEastRailLineColor = Color(0xFF53B7E8);

  static const Color mtrTuenMaLineColor = Color(0xFF9A3B26);

  static const Color mtrSouthIslandLineColor = Color(0xFFB5BD00);

  static const Color mtrAirportExpressColor = Color(0xFF1C7670);

  // ============================================================================
  // STATUS & FEEDBACK COLORS
  // ============================================================================

  static const Color loadingColor = Color(0xFF1976D2);

  static const Color errorColor = Color(0xFFD32F2F);

  static const Color successStateColor = Color(0xFF4CAF50);

  static const Color infoColor = Color(0xFF2196F3);

  // ============================================================================
  // BORDER & DIVIDER COLORS
  // ============================================================================

  static const Color borderColor = Color(0xFFE0E0E0);

  static const Color dividerColor = Color(0xFFE0E0E0);

  static const Color focusBorderColor = Color(0xFF1976D2);

  // ============================================================================
  // SHADOW COLORS
  // ============================================================================

  static const Color shadowColor = Color(0x1A000000);

  static const Color shadowLightColor = Color(0x0D000000);

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  static Color getMTRLineColor(String lineCode) {
    switch (lineCode) {
      case 'ISL':
        return mtrIslandLineColor;
      case 'TWL':
        return mtrTsuenWanLineColor;
      case 'KTL':
        return mtrKwunTongLineColor;
      case 'TKL':
        return mtrTseungKwanOLineColor;
      case 'TCL':
        return mtrTungChungLineColor;
      case 'EAL':
        return mtrEastRailLineColor;
      case 'TML':
        return mtrTuenMaLineColor;
      case 'SIL':
        return mtrSouthIslandLineColor;
      case 'AEL':
        return mtrAirportExpressColor;
      default:
        return textMutedColor;
    }
  }

  static Color getTransportModeColor(bool isMTR) {
    return isMTR ? mtrColor : kmbColor;
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return successStateColor;
      case 'error':
        return errorColor;
      case 'warning':
        return warningColor;
      case 'info':
        return infoColor;
      default:
        return textMutedColor;
    }
  }

  static Color getUnselectedColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? unSelectedColorDark
        : unSelectedColor;
  }
}
