import 'package:flutter/material.dart';
import '../../scripts/utils/first_time_service.dart';
import '../ui/splash_screen.dart';
import 'steps/project_intro.dart';
import 'steps/bus_setting.dart';
import '../../l10n/app_localizations.dart';
import 'steps/mtr_setting.dart';
import 'steps/final_dive_into_app.dart';

class FirstTimeToApp extends StatefulWidget {
  const FirstTimeToApp({super.key});

  @override
  State<FirstTimeToApp> createState() => _FirstTimeToAppState();
}

class _FirstTimeToAppState extends State<FirstTimeToApp> {
  static const int _totalSteps = 4;
  final PageController _pageController = PageController();
  int _currentStep = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get _progress => _currentStep / (_totalSteps - 1);

  Future<void> _goNext() async {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
    } else {
      await _finishIntro();
    }
  }

  Future<void> _finishIntro() async {
    await FirstTimeService.setCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => const SplashScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  String _titleForStep(int index) {
    final loc = AppLocalizations.of(context)!;
    switch (index) {
      case 0:
        return loc.firstTimeTitleWelcome;
      case 1:
        return '${loc.firstTimeTitleSetup} - 巴士';
      case 2:
        return '${loc.firstTimeTitleSetup} - 港鐵';
      case 3:
        return loc.firstTimeTitleTips;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color filledColor = Colors.green;
    final Color emptyColor = Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForStep(_currentStep)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ClipRRect(
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: _progress),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  builder: (context, animatedValue, _) {
                    return LinearProgressIndicator(
                      value: animatedValue,
                      minHeight: 20,
                      backgroundColor: emptyColor,
                      valueColor: AlwaysStoppedAnimation<Color>(filledColor),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _goNext,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _totalSteps,
                    onPageChanged: (i) => setState(() => _currentStep = i),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const ProjectIntroStep();
                      }
                      if (index == 1) {
                        return const BusSettingStep();
                      }
                      if (index == 2) {
                        return const MTRSettingStep();
                      }
                      return const FinalDiveIntoAppStep();
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  'Tap to ' +
                      (_currentStep == _totalSteps - 1 ? 'finish' : 'continue'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
