import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/app_bar_icon_button.dart';
import 'package:ai_eru_tawasol/features/chat/presentation/view/chat_view.dart';

class AnnounAppBarTrailing extends StatelessWidget {
  final AnnounRole role;

  const AnnounAppBarTrailing({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case AnnounRole.admin:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBarIconButton(
              icon: Icons.add_rounded,
              onTap: () => _openCreate(context, AnnounRole.admin),
            ),
            const SizedBox(width: 8),
            AppBarIconButton(
              icon: Icons.chat_bubble_rounded,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChatView()),
              ),
            ),
            const SizedBox(width: 8),
            AppBarIconButton(
              icon: Icons.person_rounded,
              onTap: () => context.push(AppRouter.kProfileView),
            ),
          ],
        );
      case AnnounRole.student:
        return AppBarIconButton(
          icon: Icons.qr_code_scanner_rounded,
          onTap: () {},
        );
      case AnnounRole.doctor:
        return AppBarIconButton(
          icon: Icons.add_rounded,
          onTap: () => _openCreate(context, AnnounRole.doctor),
        );
    }
  }

  Future<void> _openCreate(BuildContext context, AnnounRole role) async {
    final session = context.read<SessionCubit>().state;
    if (session is! SessionAuthenticated) return;

    final result = await context.push<Object?>(
      AppRouter.kAddAnnouncementView,
      extra: AddAnnounArgs(role: role, userId: session.userId),
    );

    if (!context.mounted) return;
    if (result is Announcement) {
      context.read<AnnounCubit>().prependAnnouncement(result);
    } else if (result == true) {
      // Assignment posted — reload to fetch it from the server
      context.read<AnnounCubit>().loadForRole(role);
    }
  }
}
