// lib/crystal_navigation_bar/src/crystal_navigation_bar_item.dart
import 'package:flutter/material.dart';

/// A tab to display in a [CrystalNavigationBar]
class CrystalNavigationBarItem {
  /// An icon to display.
  final IconData icon;
  /// An icon to display when unselected.
  final IconData? unselectedIcon;
  /// Badge widget to display notifications
  final Badge? badge;
  /// A primary color to use for this tab.
  final Color? selectedColor;
  /// The color to display when this tab is not selected.
  final Color? unselectedColor;

  CrystalNavigationBarItem({
    required this.icon,
    this.unselectedIcon,
    this.selectedColor,
    this.unselectedColor,
    this.badge,
  });
}