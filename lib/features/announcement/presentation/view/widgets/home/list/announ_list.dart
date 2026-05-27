import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/cards/announ_card.dart';
import 'package:ai_eru_tawasol/features/announcement/presentation/view/widgets/states/announ_empty_state.dart';

class AnnounList extends StatelessWidget {
  final List<Announcement> announcements;

  const AnnounList({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    if (announcements.isEmpty) return const AnnounEmptyState();

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 6, bottom: 20),
      itemCount: announcements.length,
      itemBuilder: (context, index) => AnnounCard(
        key: ValueKey(announcements[index].id),
        announcement: announcements[index],
        index: index,
      ),
    );
  }
}
