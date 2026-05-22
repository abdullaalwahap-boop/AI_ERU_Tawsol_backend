import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/announ_view.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_bottom_navigation_bar.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_floating_action_button.dart.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/pages.dart';
import 'package:flutter/material.dart';

// TODO: Replace with real role from auth state
const kHomeRole = AnnounRole.doctor;

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int _currentIndex = 0;

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  // Doctor FAB only on Home tab (index 0); admin always shows FAB
  bool get _showFab =>
      (kHomeRole == AnnounRole.doctor && _currentIndex == 0) ||
      kHomeRole == AnnounRole.admin;

  @override
  Widget build(BuildContext context) {
    // Admin: no BNB — clean dashboard with full-screen feed + FAB
    if (kHomeRole == AnnounRole.admin) {
      return Scaffold(
        body: const AnnounView(role: AnnounRole.admin),
        floatingActionButton:
            const HomeFloatingActionButton(role: AnnounRole.admin),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }

    // Student & Doctor: 4-tab BNB
    final pages = buildPages(kHomeRole);
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: HomeBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
      floatingActionButton:
          _showFab ? HomeFloatingActionButton(role: kHomeRole) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
