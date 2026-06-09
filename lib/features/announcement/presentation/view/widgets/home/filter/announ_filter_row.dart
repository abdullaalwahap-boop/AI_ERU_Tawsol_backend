import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/extensions/announcement_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/home/filter/announ_filter_chip.dart';

class AnnounFilterRow extends StatelessWidget {
  final AnnouncementType? activeFilter;
  final void Function(AnnouncementType?) onFilterChanged;

  const AnnounFilterRow({
    super.key,
    required this.activeFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          AnnounFilterChip(
            label: AppLocalizations.of(context).all,
            icon: Icons.apps_rounded,
            isSelected: activeFilter == null,
            color: AppColors.primary,
            onTap: () => onFilterChanged(null),
          ),
          AppSpacing.w8,
          ...AnnouncementType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: AnnounFilterChip(
                label: type.labelOf(context),
                icon: type.icon,
                isSelected: activeFilter == type,
                color: type.color,
                onTap: () =>
                    onFilterChanged(activeFilter == type ? null : type),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
