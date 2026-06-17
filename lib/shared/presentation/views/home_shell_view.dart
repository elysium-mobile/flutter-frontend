import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/app_colors.dart';
import '../design/app_typography.dart';
import '../i18n/app_strings.dart';

/// Persistent multi-tab container of the authenticated shell.
///
/// Renders the four-destination bottom navigation bar (Menu, Profile, Alerts,
/// Reports) and hosts the active branch through the provided
/// [StatefulNavigationShell]. As the core multi-tab infrastructure has no
/// dedicated home context, it lives in the shared bounded context.
class HomeShellView extends StatelessWidget {
  /// Creates a [HomeShellView] wrapping the branch [navigationShell].
  const HomeShellView({super.key, required this.navigationShell});

  /// The go_router shell driving indexed-stack branch switching.
  final StatefulNavigationShell navigationShell;

  /// Switches to the branch at [index], popping to its root when re-tapped.
  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: _onDestinationSelected,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primaryNavy,
        unselectedItemColor: AppColors.dark.withValues(alpha: 0.5),
        selectedLabelStyle: AppTypography.caption,
        unselectedLabelStyle: AppTypography.caption,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard_rounded),
            label: AppStrings.menuTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline_rounded),
            activeIcon: const Icon(Icons.person_rounded),
            label: AppStrings.profileTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_outlined),
            activeIcon: const Icon(Icons.notifications_rounded),
            label: AppStrings.alertsTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart_rounded),
            label: AppStrings.reportsTab,
          ),
        ],
      ),
    );
  }
}
