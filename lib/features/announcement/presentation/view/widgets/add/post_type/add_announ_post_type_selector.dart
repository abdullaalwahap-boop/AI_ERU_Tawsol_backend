import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/post_type/add_announ_post_type_card.dart';

class AddAnnounPostTypeSelector extends StatelessWidget {
  final AnnouncementType selected;
  final void Function(AnnouncementType) onSelected;

  const AddAnnounPostTypeSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Post Type',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: 0.1,
          ),
        ),
        AppSpacing.h10,
        Row(
          children: AnnouncementType.values
              .map(
                (type) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: type != AnnouncementType.assignment ? 10 : 0,
                    ),
                    child: AddAnnounPostTypeCard(
                      type: type,
                      isSelected: selected == type,
                      onTap: () => onSelected(type),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
