import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/filter/feature_filter_chip.dart';
import 'package:ai_eru_tawasol/features/course/presentation/extensions/content_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';

class CourseContentFilterRow extends StatelessWidget {
  final ContentType? activeFilter;
  final void Function(ContentType?) onFilterChanged;

  const CourseContentFilterRow({
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
          FeatureFilterChip(
            label: AppLocalizations.of(context).all,
            icon: Icons.apps_rounded,
            isSelected: activeFilter == null,
            color: AppColors.primary,
            onTap: () => onFilterChanged(null),
          ),
          AppSpacing.w8,
          ...ContentType.values.map(
            (type) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FeatureFilterChip(
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
