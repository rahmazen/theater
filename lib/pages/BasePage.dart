import 'package:flutter/material.dart';
import 'package:theater/pages/ContentPage.dart';
import 'package:theater/pages/TheaterHomePage.dart';
import 'package:theater/pages/TicketHistoryPage.dart';
import 'package:theater/pages/profile_page.dart';
import 'package:theater/pages/settings_page.dart';
import '../crystal_navigation_bar/crystal_navigation_bar.dart';

// Import your individual pages here


class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _currentIndex = 0;

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    TheaterHomePage(),
     ContentPage(),
     TicketHistoryPage(),
     ProfilePage(),
  ];

  // Navigation bar items
  final List<CrystalNavigationBarItem> _navBarItems = [
    CrystalNavigationBarItem(
      icon: Icons.home_rounded,
      unselectedIcon: Icons.home_rounded,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: Icons.movie_creation_rounded,
      unselectedIcon: Icons.movie_outlined,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: Icons.confirmation_num,
      unselectedIcon: Icons.confirmation_num_outlined,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
    ),
    CrystalNavigationBarItem(
      icon: Icons.person,
      unselectedIcon: Icons.person_outline,
      selectedColor: Colors.red,
      unselectedColor: Colors.white,
      badge: const Badge(
        label: Text('3'),
        backgroundColor: Colors.amber,
      ),
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pages take full screen
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          // Navigation bar as overlay at the bottom
          Positioned(
            bottom: -30,
            left: 0,
            right: 0,
            child: CrystalNavigationBar(
              items: _navBarItems,
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: Colors.red,
              unselectedItemColor: Colors.white,
              backgroundColor: Colors.black.withOpacity(0.3),
              outlineBorderColor: Colors.white.withOpacity(0.2),
              borderWidth: 1.0,
              borderRadius: 25,
              height: 80,
              marginR: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              paddingR: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              enableFloatingNavBar: true,
              indicatorColor: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
