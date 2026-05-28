import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/letter/letter_body_card.dart';

class ContentDetailsLetterBody extends StatelessWidget {
  final ContentDisplayItem item;

  const ContentDetailsLetterBody({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LetterBodyCard(
      body: item.body,
      accentColor: item.typeColor,
      accentLightColor: item.typeLightColor,
      accentIcon: item.typeIcon,
      authorName: item.authorName,
      authorInitials: item.authorInitials,
      authorSubtitle: item.contextLabel != null
          ? '${item.contextLabel} · ${item.formattedDate}'
          : item.formattedDate,
      isFromAdmin: item.isFromAdmin,
    );
  }
}
