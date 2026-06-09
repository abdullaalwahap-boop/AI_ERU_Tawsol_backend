import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/add/priority/add_announ_priority_card.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/shared/section_header.dart';

class AddAnnounPrioritySelector extends StatelessWidget {
  final AnnouncementPriority selected;
  final void Function(AnnouncementPriority) onSelected;

  const AddAnnounPrioritySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final priorities = AnnouncementPriority.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: AppLocalizations.of(context).priority),
        const SizedBox(height: 14),
        Row(
          children: priorities
              .map(
                (priority) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: priority != priorities.last ? 10 : 0),
                    child: AddAnnounPriorityCard(
                      priority: priority,
                      isSelected: selected == priority,
                      onTap: () => onSelected(priority),
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
