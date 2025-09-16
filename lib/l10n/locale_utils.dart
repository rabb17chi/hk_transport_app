import 'package:flutter/widgets.dart';

class LocaleUtils {
  const LocaleUtils._();

  static bool isChinese(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    return code == 'zh';
  }
}
