import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_app_bar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_attachments.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_header.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_letter_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AnnounDetailsView extends StatelessWidget {
  final Announcement announcement;

  const AnnounDetailsView({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    final currentUserId =
        session is SessionAuthenticated ? session.userId : null;
    final isAuthor =
        currentUserId != null && announcement.authorId == currentUserId;
    final role = session is SessionAuthenticated
        ? session.role.toAnnounRole
        : AnnounRole.student;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: context.colorBackground,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            AnnounDetailsAppBar(
              announcement: announcement,
              actions: isAuthor
                  ? [
                      _EditButton(announcement: announcement, role: role),
                      _DeleteButton(announcement: announcement),
                    ]
                  : null,
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnnounDetailsHeader(announcement: announcement),
                    AppSpacing.h20,
                    AnnounDetailsLetterBody(announcement: announcement),
                    if (announcement.attachments.isNotEmpty) ...[
                      AppSpacing.h20,
                      AnnounDetailsAttachments(
                          attachments: announcement.attachments),
                    ],
                    AppSpacing.h16,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final Announcement announcement;
  final AnnounRole role;
  const _EditButton({required this.announcement, required this.role});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit_rounded, color: Colors.white),
      tooltip: 'Edit',
      onPressed: () => context.push(
        AppRouter.kAddAnnouncementView,
        extra: AddAnnounArgs(
          role: role,
          userId: (context.read<SessionCubit>().state as SessionAuthenticated)
              .userId,
          announcementToEdit: announcement,
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final Announcement announcement;
  const _DeleteButton({required this.announcement});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_rounded, color: Colors.white),
      tooltip: 'Delete',
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Announcement'),
            content:
                const Text('Are you sure you want to delete this announcement?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
        if (confirmed == true && context.mounted) {
          final id = int.tryParse(announcement.id);
          if (id != null) {
            await context.read<AnnounCubit>().deleteAnnouncement(id);
          }
          if (context.mounted) context.pop();
        }
      },
    );
  }
}
