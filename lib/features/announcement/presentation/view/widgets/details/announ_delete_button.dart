import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';

class AnnounDeleteButton extends StatelessWidget {
  final Announcement announcement;
  const AnnounDeleteButton({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete_rounded, color: Colors.white),
      tooltip: AppLocalizations.of(context).delete,
      onPressed: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(AppLocalizations.of(context).deleteAnnouncement),
            content: Text(
                AppLocalizations.of(context).deleteAnnouncementConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  AppLocalizations.of(context).delete,
                  style: const TextStyle(color: Colors.red),
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
