import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_shadows.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';
import 'package:ai_eru_tawasol/core/shared/views/content_details/widgets/content_details_author_avatar.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/badges/content_priority_badge.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/badges/content_type_badge.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/meta/feature_meta_row.dart';

class ContentDetailsHeaderCard extends StatelessWidget {
  final ContentDisplayItem item;

  const ContentDetailsHeaderCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.large,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContentDetailsAuthorAvatar(item: item),
              AppSpacing.w14,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ContentTypeBadge(
                          label: item.typeLabel,
                          icon: item.typeIcon,
                          color: item.typeColor,
                          lightColor: item.typeLightColor,
                        ),
                        if (item.priorityLabel != null) ...[
                          AppSpacing.w6,
                          ContentPriorityBadge(
                            label: item.priorityLabel!,
                            color: item.priorityColor!,
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.h8,
                    Text(
                      item.title,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: const Color(0xff1E293B),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.h16,
          const Divider(color: Color(0xffE2E8F0), height: 1),
          AppSpacing.h14,
          if (item.contextLabel != null) ...[
            FeatureMetaRow(
              icon: Icons.menu_book_rounded,
              label: 'Subject / Course',
              value: item.contextCode != null
                  ? '${item.contextCode} · ${item.contextLabel}'
                  : item.contextLabel!,
              iconColor: item.typeColor,
            ),
            AppSpacing.h10,
          ],
          FeatureMetaRow(
            icon: Icons.person_rounded,
            label: 'Posted by',
            value: item.authorName,
            iconColor: const Color(0xff64748B),
          ),
          AppSpacing.h10,
          FeatureMetaRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: item.formattedDate,
            iconColor: const Color(0xff64748B),
          ),
          AppSpacing.h10,
          FeatureMetaRow(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: item.formattedTime,
            iconColor: const Color(0xff64748B),
          ),
          if (item.deadline != null) ...[
            AppSpacing.h10,
            FeatureMetaRow(
              icon: Icons.timer_outlined,
              label: 'Deadline',
              value: _formatDeadline(item.deadline!),
              iconColor: const Color(0xffDC2626),
            ),
          ],
        ],
      ),
    );
  }

  static String _formatDeadline(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final date = '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
    final h = dt.hour;
    final hour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    return '$date  ·  $hour:$minute $period';
  }
}
