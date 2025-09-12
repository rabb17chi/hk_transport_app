import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../scripts/kmb_api_service.dart';

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
    return GestureDetector(
      onTap: () {
        // Add haptic feedback when route is selected
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF323232),
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: Colors.red, width: 3)
              : Border.all(color: Colors.grey[600]!, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Left side - Destination text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Traditional Chinese (top)
                    Text(
                      route.destTc,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF7A925), // rgb(247,169,37)
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    // English (bottom)
                    Text(
                      route.destEn,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFF7A925), // rgb(247,169,37)
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Right side - Route number
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    route.route,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF7A925), // rgb(247,169,37)
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
