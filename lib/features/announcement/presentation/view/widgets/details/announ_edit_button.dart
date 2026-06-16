import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';

class AnnounEditButton extends StatelessWidget {
  final Announcement announcement;
  final AnnounRole role;
  const AnnounEditButton(
      {super.key, required this.announcement, required this.role});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit_rounded, color: Colors.white),
      tooltip: AppLocalizations.of(context).edit,
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
