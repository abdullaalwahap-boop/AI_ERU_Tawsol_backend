import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ai_eru_tawasol/core/events/announcement_change_notifier.dart';
import 'package:ai_eru_tawasol/core/services/service_locator.dart';
import 'package:ai_eru_tawasol/core/session/session_cubit.dart';
import 'package:ai_eru_tawasol/core/shared/extensions/announcement_display_ext.dart';
import 'package:ai_eru_tawasol/core/utils/app_router.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/announ_cubit/announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_actions_sheet.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_footer.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_preview.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_title.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_top_row.dart';

class AnnounCardContent extends StatelessWidget {
  final Announcement announcement;
  final void Function(Announcement updated)? onReplaced;
  final Future<bool> Function(int id)? onDeleteConfirmed;
  final VoidCallback? onQuizTap;

  const AnnounCardContent({
    super.key,
    required this.announcement,
    this.onReplaced,
    this.onDeleteConfirmed,
    this.onQuizTap,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = announcement.type.color;
    final barColor = typeColor;
    final session = context.watch<SessionCubit>().state;
    final isOwner = session is SessionAuthenticated &&
        session.userId == announcement.authorId;

    return GestureDetector(
      onTap: () => context.push(
        AppRouter.kContentDetailsView,
        extra: announcement.toDisplayItem(),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: context.colorSurface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            ...AppShadows.card,
            BoxShadow(
              color: barColor.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4, color: barColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AnnounCardTopRow(
                                  announcement: announcement),
                            ),
                            if (isOwner) ...[
                              AppSpacing.w4,
                              _ActionsButton(
                                onTap: () => _showActionsSheet(context),
                              ),
                            ],
                          ],
                        ),
                        AppSpacing.h10,
                        AnnounCardTitle(title: announcement.title),
                        AppSpacing.h6,
                        AnnounCardPreview(body: announcement.body),
                        AppSpacing.h12,
                        if (onQuizTap != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: onQuizTap,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        AppColors.accent
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.auto_awesome_rounded,
                                          size: 13, color: Colors.white),
                                      const SizedBox(width: 4),
                                      Text(
                                        AppLocalizations.of(context).generateQuiz,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        AnnounCardFooter(announcement: announcement),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showActionsSheet(BuildContext context) async {
    final action = await showModalBottomSheet<AnnounCardAction>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          AnnounCardActionsSheet(announcementTitle: announcement.title),
    );
    if (action == null || !context.mounted) return;

    if (action == AnnounCardAction.edit) {
      await _handleEdit(context);
    } else {
      await _handleDelete(context);
    }
  }

  Future<void> _handleEdit(BuildContext context) async {
    final session = context.read<SessionCubit>().state;
    if (session is! SessionAuthenticated) return;

    final result = await context.push<Announcement?>(
      AppRouter.kAddAnnouncementView,
      extra: AddAnnounArgs(
        role: session.role.toAnnounRole,
        userId: session.userId,
        announcementToEdit: announcement,
      ),
    );

    if (result == null || !context.mounted) return;

    if (onReplaced != null) {
      onReplaced!(result);
    } else {
      context.read<AnnounCubit>().replaceAnnouncement(result);
    }
    getIt<AnnouncementChangeNotifier>().notifyReplace(result);
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.xlarge),
        title: Text(AppLocalizations.of(context).deleteAnnouncement),
        content: Text(AppLocalizations.of(context).deleteAnnouncementPermanent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
                foregroundColor: const Color(0xffDC2626)),
            child: Text(AppLocalizations.of(context).delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final bool success;
    if (onDeleteConfirmed != null) {
      success = await onDeleteConfirmed!(int.parse(announcement.id));
    } else {
      success = await context
          .read<AnnounCubit>()
          .deleteAnnouncement(int.parse(announcement.id));
    }

    if (success) {
      getIt<AnnouncementChangeNotifier>().notifyDelete(announcement.id);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).failedToDeleteAnnouncement)),
      );
    }
  }
}

class _ActionsButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ActionsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 20,
          color: context.colorTextHint,
        ),
      ),
    );
  }
}
