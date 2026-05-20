import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/design/app_spacing.dart';
import 'package:ai_eru_tawasol/core/shared/widgets/badges/content_type_badge.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/extensions/content_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/course/presentation/view/widgets/details/content_card/course_content_card_author.dart';

class CourseContentCardTopRow extends StatelessWidget {
  final CourseContent content;

  const CourseContentCardTopRow({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CourseContentCardAuthor(content: content),
        AppSpacing.w10,
        const Spacer(),
        ContentTypeBadge(
          label: content.type.label,
          icon: content.type.icon,
          color: content.type.color,
          lightColor: content.type.lightColor,
        ),
      ],
    );
  }
}
