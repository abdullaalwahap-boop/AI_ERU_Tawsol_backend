import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/localization/app_localizations.dart';
import 'package:ai_eru_tawasol/core/theme/app_text_styles.dart';
import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';

class ContentDetailsAppBar extends StatelessWidget {
  final ContentDisplayItem item;

  const ContentDetailsAppBar({super.key, required this.item});

  Color _darken(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();
  }

  String _title(AppLocalizations l10n) {
    return switch (item.typeLabel.toLowerCase()) {
      'announcement' => l10n.announcementDetailsTitle,
      'material' => l10n.materialDetailsTitle,
      'assignment' => l10n.assignmentDetailsTitle,
      _ => item.typeLabel,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      elevation: 0,
      backgroundColor: item.accentColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded,
            color: Colors.white, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(56, 0, 16, 14),
        title: Text(
          _title(l10n),
          style: AppTextStyles.titleMedium.copyWith(color: Colors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_darken(item.accentColor), item.accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 40),
              child: Opacity(
                opacity: 0.1,
                child: Icon(item.typeIcon, size: 80, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
