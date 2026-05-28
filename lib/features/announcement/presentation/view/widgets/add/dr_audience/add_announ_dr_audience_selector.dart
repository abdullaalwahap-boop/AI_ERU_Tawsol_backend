import 'package:ai_eru_tawasol/core/design/app_radius.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/manager/add_announ_cubit/add_announ_cubit.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/admin_audience/add_announ_recipient_search.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_required_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';
import 'package:flutter/material.dart';

class AddAnnounDrAudienceSelector extends StatelessWidget {
  final AddAnnounState state;
  final void Function(DrAudienceType) onTypeSelected;
  final void Function(String) onSelectCourse;
  final void Function(String) onToggleCourseFilter;
  final void Function(String) onSearchRecipients;
  final void Function(int) onToggleRecipient;

  const AddAnnounDrAudienceSelector({
    super.key,
    required this.state,
    required this.onTypeSelected,
    required this.onSelectCourse,
    required this.onToggleCourseFilter,
    required this.onSearchRecipients,
    required this.onToggleRecipient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Target Audience',
          trailing: const AddAnnounRequiredBadge(),
        ),
        AppSpacing.h14,
        // ── Type cards row ──────────────────────────────────────────────────
        Row(
          children: DrAudienceType.values.map((type) {
            final isLast = type == DrAudienceType.values.last;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : 12),
                child: _DrTypeCard(
                  type: type,
                  isSelected: state.drAudienceType == type,
                  onTap: () => onTypeSelected(type),
                ),
              ),
            );
          }).toList(),
        ),
        // ── Content based on selected type ──────────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.lg),
            child: state.drAudienceType == DrAudienceType.specificStudents
                ? _SpecificStudentsContent(
                    state: state,
                    onToggleCourseFilter: onToggleCourseFilter,
                    onSearch: onSearchRecipients,
                    onToggle: onToggleRecipient,
                  )
                : _CourseContent(
                    courses: state.courses,
                    selected: state.selectedOptions,
                    onSelect: onSelectCourse,
                  ),
          ),
        ),
      ],
    );
  }
}

// ── Course mode content ───────────────────────────────────────────────────────

class _CourseContent extends StatelessWidget {
  final List<CourseOption> courses;
  final Set<String> selected;
  final void Function(String) onSelect;

  const _CourseContent({
    required this.courses,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.inputBgLight,
          borderRadius: AppRadius.medium,
          border: Border.all(color: AppColors.dividerLight),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            AppSpacing.w10,
            Text(
              'Loading your courses…',
              style:
                  AppTextStyles.labelMedium.copyWith(color: AppColors.textHint),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Subject',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.h10,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: courses
              .map((c) => _CourseChip(
                    course: c,
                    isSelected: selected.contains(c.id),
                    onTap: () => onSelect(c.id),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ── Specific students mode content ────────────────────────────────────────────

class _SpecificStudentsContent extends StatelessWidget {
  final AddAnnounState state;
  final void Function(String) onToggleCourseFilter;
  final void Function(String) onSearch;
  final void Function(int) onToggle;

  const _SpecificStudentsContent({
    required this.state,
    required this.onToggleCourseFilter,
    required this.onSearch,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Optional course filter
        if (state.courses.length > 1) ...[
          Row(
            children: [
              Text(
                'Filter by course',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppSpacing.w6,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.dividerLight,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'optional',
                  style: AppTextStyles.overline.copyWith(
                    color: AppColors.textHint,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.h8,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: state.courses
                .map((c) => _CourseChip(
                      course: c,
                      isSelected: state.selectedCourseId == c.id,
                      onTap: () => onToggleCourseFilter(c.id),
                    ))
                .toList(),
          ),
          AppSpacing.h16,
        ],
        // Recipient search
        AddAnnounRecipientSearch(
          recipients: state.recipients,
          isLoading: state.isLoadingRecipients,
          selectedIds: state.selectedRecipientIds,
          onSearch: onSearch,
          onToggle: onToggle,
        ),
      ],
    );
  }
}

// ── Shared course chip ────────────────────────────────────────────────────────

class _CourseChip extends StatelessWidget {
  final CourseOption course;
  final bool isSelected;
  final VoidCallback onTap;

  const _CourseChip({
    required this.course,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.inputBgLight,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.6)
                : AppColors.dividerLight,
            width: isSelected ? 1.5 : 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              course.id,
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.w800,
                color:
                    isSelected ? AppColors.primary : AppColors.textSecondary,
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              course.name,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Audience type card ────────────────────────────────────────────────────────

class _DrTypeCard extends StatelessWidget {
  final DrAudienceType type;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        height: 76,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : AppColors.inputBgLight,
          borderRadius: AppRadius.large,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.dividerLight,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.dividerLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        type.icon,
                        size: 15,
                        color: isSelected ? Colors.white : AppColors.textHint,
                      ),
                    ),
                    AppSpacing.h4,
                    Text(
                      type.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.overline.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 8,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
