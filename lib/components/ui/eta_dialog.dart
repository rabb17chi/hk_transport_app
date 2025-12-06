import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class EtaDialog {
  static Future<void> showWithPairs(
    BuildContext context, {
    required String title,
    required List<MapEntry<String, String>> rows,
    required String emptyText,
  }) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 260,
            child: rows.isEmpty
                ? Text(emptyText)
                : ListView(
                    shrinkWrap: true,
                    children: rows.take(6).map((pair) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(pair.key),
                            Text(
                              pair.value,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }
}
