import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_option_chip.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/audience/add_announ_required_badge.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';
import 'package:flutter/material.dart';

/// Doctor-only subject selector — single-select chip list.
///
/// Replaces the full audience type + options flow with a focused,
/// clean subject picker. Only one subject can be active at a time.
class AddAnnounSubjectSelector extends StatelessWidget {
  final List<String> subjects;
  final Set<String> selected;
  final void Function(String) onSelect;

  const AddAnnounSubjectSelector({
    super.key,
    required this.subjects,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Subject',
          trailing: const AddAnnounRequiredBadge(),
        ),
        AppSpacing.h14,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: subjects
              .map(
                (subject) => AddAnnounOptionChip(
                  label: subject,
                  isSelected: selected.contains(subject),
                  onTap: () => onSelect(subject),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
