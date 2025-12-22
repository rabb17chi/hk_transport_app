import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_color_scheme.dart';

/// NoNetworkReturn Widget
///
/// A reusable widget to display when API calls fail due to network issues.
/// Shows a message prompting the user to check their device network status.
class NoNetworkReturn extends StatelessWidget {
  /// Optional callback when retry button is pressed
  final VoidCallback? onRetry;

  /// Optional custom message. If null, uses localized message from i18n
  final String? customMessage;

  const NoNetworkReturn({
    super.key,
    this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = customMessage ??
        (l10n?.noNetworkReturnMessage ??
            'Please check your device network status(mobile-data/wifi is on)');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Network Error Icon
            Icon(
              Icons.wifi_off,
              size: 64,
              color: AppColorScheme.errorIconColor,
            ),
            const SizedBox(height: 24),

            // Error Title
            Text(
              l10n?.noNetworkConnection ?? 'No Network Connection',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColorScheme.errorColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Error Message
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColorScheme.white70
                        : AppColorScheme.textMediumColor,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Retry Button (if callback provided)
            if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(l10n?.retry ?? 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorScheme.buttonColor,
                  foregroundColor: AppColorScheme.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
