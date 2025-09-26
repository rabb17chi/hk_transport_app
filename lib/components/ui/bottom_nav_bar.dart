import 'package:flutter/material.dart';
import '../../scripts/utils/vibration_helper.dart';
import '../../l10n/app_localizations.dart';
import '../../l10n/locale_utils.dart';
import '../../theme/app_color_scheme.dart';

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
  void _handleModeToggleTap() async {
    await VibrationHelper.lightVibrate();
    widget.onTap(1);
  }

  void _handleModeToggleLongPress() async {
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
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                icon: Icons.bookmark,
                label: AppLocalizations.of(context)!.navBookmarks,
                index: 0,
                isSelected: widget.currentIndex == 0,
              ),
              _buildModeToggleButton(),
              _buildNavItem(
                context,
                icon: Icons.menu,
                label: AppLocalizations.of(context)!.navSettings,
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
    final isChinese = LocaleUtils.isChinese(context);

    return GestureDetector(
      onTap: () async {
        await VibrationHelper.lightVibrate();
        widget.onTap(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isChinese ? 12 : 8,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : AppColorScheme.getUnselectedColor(context),
              size: 24,
            ),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : AppColorScheme.getUnselectedColor(context),
                fontSize: 16,
                fontWeight: isChinese
                    ? isSelected
                        ? FontWeight.w600
                        : FontWeight.normal
                    : FontWeight.normal,
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
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: widget.isMTRMode
                    ? isSelected
                        ? Colors.blue
                        : Colors.blue.withOpacity(0.2)
                    : isSelected
                        ? Colors.orange
                        : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    widget.isMTRMode ? Icons.train : Icons.directions_bus,
                    color: Colors.white,
                    size: 28,
                  ),
                  Text(
                    widget.isMTRMode ? 'MTR' : 'BUS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
