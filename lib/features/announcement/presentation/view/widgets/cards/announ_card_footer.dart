import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_attachment_chip.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card_read_more_button.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_priority_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_type_badge.dart';

class AnnounCardFooter extends StatelessWidget {
  final Announcement announcement;

  const AnnounCardFooter({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final hasPriority = announcement.priority != AnnouncementPriority.normal;

    return Row(
      children: [
        AnnounTypeBadge(type: announcement.type),
        if (hasPriority) ...[
          AppSpacing.w6,
          AnnounPriorityBadge(priority: announcement.priority),
        ],
        if (announcement.attachments.isNotEmpty) ...[
          AppSpacing.w6,
          AnnounCardAttachmentChip(count: announcement.attachments.length),
        ],
        const Spacer(),
        AnnounCardReadMoreButton(announcement: announcement),
      ],
    );
  }
}
