import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/announ_view.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_bottom_navigation_bar.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_floating_action_button.dart.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int _currentIndex = 0;

  void _onTabTapped(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, sessionState) {
        final role = sessionState is SessionAuthenticated
            ? sessionState.role
            : AppRole.student;

        // Admin: no BNB — full-screen feed + FAB
        if (role.isAdmin) {
          return Scaffold(
            body: AnnounView(role: role.toAnnounRole),
            floatingActionButton:
                HomeFloatingActionButton(role: role.toAnnounRole),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        }

        // Doctor/TA: FAB only on Home tab (index 0)
        final showFab = role.canPostAnnouncements && _currentIndex == 0;

        final pages = buildPages(role);
        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: HomeBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
          floatingActionButton: showFab
              ? HomeFloatingActionButton(role: role.toAnnounRole)
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
