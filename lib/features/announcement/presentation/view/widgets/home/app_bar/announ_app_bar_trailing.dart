import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/qr_scanner_view.dart';
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
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QrScannerView()),
          ),
        );
      case AnnounRole.doctor:
        return const SizedBox.shrink();
    }
  }
}
