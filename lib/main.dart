import 'package:flutter/material.dart';
import 'components/kmb/kmb_screen_refactored.dart';
import 'components/menu.dart';
import 'components/bottom_nav_bar.dart';
import 'components/mtr/mtr_list_screen.dart';
import 'components/bookmarks/bookmark_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HK Transport App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _isMTRMode = true;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const BookmarkPage(),
      _isMTRMode ? const MTRListScreen() : const KMBTestScreenRefactored(),
      const MenuScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        isMTRMode: _isMTRMode,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        onModeToggle: () {
          setState(() {
            _isMTRMode = !_isMTRMode;
            // After changing mode, stay on current tab but update the content
            // The content will automatically update based on _isMTRMode
          });
        },
      ),
    );
  }
}
