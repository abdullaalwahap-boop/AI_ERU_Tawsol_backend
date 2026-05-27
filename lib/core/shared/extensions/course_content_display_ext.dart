import 'package:ai_eru_tawasol/core/shared/models/content_display_item.dart';
import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:ai_eru_tawasol/features/course/presentation/extensions/content_file_type_ui_ext.dart';
import 'package:ai_eru_tawasol/features/course/presentation/extensions/content_type_ui_ext.dart';

extension CourseContentDisplayExt on CourseContent {
  ContentDisplayItem toDisplayItem(Course course) {
    return ContentDisplayItem(
      id: id,
      title: title,
      body: body,
      authorName: authorName,
      authorInitials: authorInitials,
      typeLabel: type.label,
      typeColor: type.color,
      typeLightColor: type.lightColor,
      typeIcon: type.icon,
      formattedDate: formattedDate,
      formattedTime: formattedTime,
      timeAgo: timeAgo,
      contextLabel: course.name,
      contextCode: course.code,
      attachments: attachments
          .map(
            (a) => ContentDisplayAttachment(
              name: a.name,
              sizeLabel: a.sizeLabel,
              icon: a.fileType.icon,
              iconColor: a.fileType.color,
              url: a.url,
              isImage: a.isImage,
            ),
          )
          .toList(),
      accentColor: course.accentColor,
      isFromAdmin: isFromAdmin,
      deadline: deadline,
    );
  }
}
