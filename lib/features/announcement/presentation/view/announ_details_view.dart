import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_delete_button.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_app_bar.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_attachments.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_header.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_details_letter_body.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/details/announ_edit_button.dart';

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
                      AnnounEditButton(
                          announcement: announcement, role: role),
                      AnnounDeleteButton(announcement: announcement),
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
