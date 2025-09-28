import 'package:flutter/material.dart';

/// Utility class for locale-related operations
class LocaleUtils {
  /// Check if the current locale is Chinese
  static bool isChinese(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'zh';
  }

  /// Get the appropriate name based on locale
  static String getLocalizedName(
    BuildContext context,
    String nameTc,
    String nameEn,
  ) {
    return isChinese(context) ? nameTc : nameEn;
  }

  /// Get the subtitle name based on locale (opposite of main name)
  static String getSubtitleName(
    BuildContext context,
    String nameTc,
    String nameEn,
  ) {
    return isChinese(context) ? nameEn : nameTc;
  }
}
