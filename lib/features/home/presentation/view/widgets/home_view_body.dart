import 'dart:async';

import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/session/app_role.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/announcement/data/repos/announ_repo.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/announ_view.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_bottom_navigation_bar.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/home_floating_action_button.dart';
import 'package:ai_eru_tawasol/features/home/presentation/view/widgets/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  int _currentIndex = 0;
  int _announcementUnread = 0;
  Timer? _unreadTimer;

  @override
  void initState() {
    super.initState();
    _fetchUnread();
    _unreadTimer = Timer.periodic(const Duration(seconds: 30), (_) => _fetchUnread());
  }

  @override
  void dispose() {
    _unreadTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUnread() async {
    try {
      final count = await getIt<AnnounRepo>().getUnreadCount();
      if (mounted) setState(() => _announcementUnread = count);
    } catch (_) {}
  }

  void _onTabTapped(int index) {
    setState(() => _currentIndex = index);
    if (index == 0) _fetchUnread();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      listenWhen: (_, current) => current is SessionUnauthenticated,
      listener: (context, _) => context.go(AppRouter.kLoginView),
      builder: (context, sessionState) {
        final role = sessionState is SessionAuthenticated
            ? sessionState.role
            : AppRole.student;

        // Doctor/TA/Admin: FAB only on Home tab (index 0)
        final showFab = role.canPostAnnouncements && _currentIndex == 0;

        final pages = buildPages(role);
        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: HomeBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            announcementUnreadCount: _announcementUnread,
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
