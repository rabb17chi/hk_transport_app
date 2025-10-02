import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../scripts/utils/responsive_utils.dart';

enum IntroMode { bus, mtr }

class ProjectIntroStep extends StatefulWidget {
  const ProjectIntroStep({super.key});

  @override
  State<ProjectIntroStep> createState() => _ProjectIntroStepState();
}

class _ProjectIntroStepState extends State<ProjectIntroStep> {
  IntroMode _mode = IntroMode.bus; // initial bus

  @override
  void initState() {
    super.initState();
    _persistPlatform(_mode);
  }

  Future<void> _persistPlatform(IntroMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'last_platform', mode == IntroMode.mtr ? 'MTR' : 'KMB');
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == IntroMode.bus ? IntroMode.mtr : IntroMode.bus;
    });
    _persistPlatform(_mode);
  }

  @override
  Widget build(BuildContext context) {
    final bool busSelected = _mode == IntroMode.bus;
    final bool mtrSelected = _mode == IntroMode.mtr;
    final loc = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            loc.introWelcomeTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize:
                      ResponsiveUtils.getResponsiveFontSize(context, 40.0),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            loc.introUseIt,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize:
                      ResponsiveUtils.getResponsiveFontSize(context, 24.0),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            loc.introHKTransportsETA,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize:
                      ResponsiveUtils.getResponsiveFontSize(context, 24.0),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            loc.introETAFull,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize:
                      ResponsiveUtils.getResponsiveFontSize(context, 24.0),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                loc.introIfChangeMode,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize:
                          ResponsiveUtils.getResponsiveFontSize(context, 24.0),
                    ),
              ),
              const SizedBox(height: 8),
              _ModeToggleRow(
                busSelected: busSelected,
                mtrSelected: mtrSelected,
                onLongPress: _toggleMode,
                holdLabel: loc.holdToChange,
                busLabel: loc.busLabel,
                mtrLabel: loc.mtrLabel,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            loc.introModeSet(_mode.name.toUpperCase()),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize:
                      ResponsiveUtils.getResponsiveFontSize(context, 32.0),
                ),
          ),
          const SizedBox(height: 40),
          Text(
            loc.introSetupPref,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize:
                      ResponsiveUtils.getResponsiveFontSize(context, 20.0),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ModeToggleRow extends StatelessWidget {
  final bool busSelected;
  final bool mtrSelected;
  final VoidCallback onLongPress;
  final String holdLabel;
  final String busLabel;
  final String mtrLabel;

  const _ModeToggleRow({
    required this.busSelected,
    required this.mtrSelected,
    required this.onLongPress,
    required this.holdLabel,
    required this.busLabel,
    required this.mtrLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.greenAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: busSelected ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: const Icon(
                    Icons.directions_bus,
                    size: 100,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  busLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context, 16.0),
                        fontWeight:
                            busSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.swap_horiz, size: 40, color: Colors.grey),
                Text(
                  holdLabel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context, 20.0),
                        color: Colors.grey[300],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  scale: mtrSelected ? 1.0 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: const Icon(
                    Icons.train,
                    size: 100,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mtrLabel,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context, 16.0),
                        fontWeight:
                            mtrSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
