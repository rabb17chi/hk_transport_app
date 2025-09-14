import 'package:flutter/material.dart';
import '../scripts/vibration_helper.dart';

class AppBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isMTRMode;
  final VoidCallback? onModeToggle;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.isMTRMode = true,
    this.onModeToggle,
  });

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  void _handleModeToggleTap() {
    // Single tap - navigate to current mode
    widget.onTap(1);
  }

  void _handleModeToggleLongPress() async {
    // Long press - change mode
    widget.onModeToggle?.call();

    // Provide heavy vibration feedback for mode change
    await VibrationHelper.strongVibrate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor ??
            Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.bookmark,
                label: '收藏',
                index: 0,
                isSelected: widget.currentIndex == 0,
              ),
              _buildModeToggleButton(),
              _buildNavItem(
                context,
                icon: Icons.menu,
                label: '設定',
                index: 2,
                isSelected: widget.currentIndex == 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: isSelected ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
              size: isSelected ? 26 : 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
                fontSize: isSelected ? 13 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeToggleButton() {
    final isSelected = widget.currentIndex == 1;

    return GestureDetector(
      onTap: _handleModeToggleTap,
      onLongPress: _handleModeToggleLongPress,
      behavior: HitTestBehavior.opaque, // Make the entire area tappable
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: isSelected ? 8 : 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isSelected ? 10 : 8),
              decoration: BoxDecoration(
                color: widget.isMTRMode ? Colors.blue : Colors.orange,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    widget.isMTRMode ? Icons.train : Icons.directions_bus,
                    color: Colors.white,
                    size: isSelected ? 24 : 20,
                  ),
                  // Small indicator for hold-tap functionality
                  Positioned(
                    top: 1,
                    right: 1,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.isMTRMode ? '港鐵' : '巴士',
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
                fontSize: isSelected ? 13 : 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
