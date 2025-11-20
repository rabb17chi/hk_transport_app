import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
// import '../scripts/locale/locale_service.dart';
import '../../scripts/utils/startup_service.dart';
import '../../scripts/utils/first_time_service.dart';
import '../first_time/first_time_to_app.dart';

class SplashScreen extends StatefulWidget {
  final bool allowAnimation;
  const SplashScreen({super.key, this.allowAnimation = true});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Simulate/perform initialization: load last-used platform
    final start = DateTime.now();
    final isMTR = await StartupService.loadInitialPlatformIsMTR();
    await StartupService.initializeApp();
    // Check if user has completed first-time flow
    final isFirstTime = await FirstTimeService.isFirstTime();

    // Ensure splash shows at least 2 seconds
    final elapsed = DateTime.now().difference(start);
    final minDuration =
        widget.allowAnimation ? const Duration(seconds: 2) : Duration.zero;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }

    if (!mounted) return;
    final target =
        isFirstTime ? const FirstTimeToApp() : MyHomePage(initialIsMTR: isMTR);
    _navigateTo(target, widget.allowAnimation);
  }

  void _navigateTo(Widget page, bool allowAnimation) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: allowAnimation
            ? const Duration(milliseconds: 350)
            : Duration.zero,
        reverseTransitionDuration: allowAnimation
            ? const Duration(milliseconds: 350)
            : Duration.zero,
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          if (!allowAnimation) {
            return child;
          }
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_transit, size: 72, color: Colors.black54),
            SizedBox(height: 16),
            Text(
              'HK Transport',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
