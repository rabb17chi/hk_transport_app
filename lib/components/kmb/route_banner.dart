import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../scripts/kmb/kmb_api_service.dart';
import '../../theme/app_color_scheme.dart';
import '../ui/transport_route_banner.dart';

/// Route Banner Component
///
/// A banner-style display similar to bus destination displays
/// Shows destination in Chinese (top) and English (bottom) on the left,
/// and route number on the right
class RouteBanner extends StatelessWidget {
  final KMBRoute route;
  final bool isSelected;
  final VoidCallback? onTap;

  const RouteBanner({
    super.key,
    required this.route,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMainService = route.serviceType == '1';
    return TransportRouteBanner(
      titleTop: isMainService ? route.destTc : '${route.destTc} (特)',
      titleBottom: route.destEn,
      routeNumber: route.route,
      backgroundColor: isMainService
          ? AppColorScheme.kmbBannerBackgroundColor
          : AppColorScheme.specialRouteBackgroundColor,
      textColor: AppColorScheme.kmbBannerTextColor,
      borderColor: AppColorScheme.specialRouteBorderColor,
      shadowColor: isMainService
          ? AppColorScheme.shadowColorDark
          : AppColorScheme.specialRouteShadowColor,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
    );
  }
}
