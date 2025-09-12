import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.train),
          label: '港鐵',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bus),
          label: '巴士',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: '設定',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
