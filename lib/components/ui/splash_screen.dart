import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
// import '../scripts/locale/locale_service.dart';
import '../../scripts/utils/startup_service.dart';
import '../../scripts/utils/first_time_service.dart';
import '../first_time/first_time_to_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
    const minDuration = Duration(seconds: 2);
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }

    if (!mounted) return;
    if (isFirstTime) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, __, ___) => const FirstTimeToApp(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (_, __, ___) => MyHomePage(initialIsMTR: isMTR),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    }
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
