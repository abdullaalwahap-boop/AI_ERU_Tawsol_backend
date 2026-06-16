import 'package:flutter/material.dart';
import 'package:ai_eru_tawasol/core/theme/app_colors.dart';

enum AttachmentOption { camera, gallery, document, audio, link }

extension AttachmentOptionExt on AttachmentOption {
  String get label {
    switch (this) {
      case AttachmentOption.camera:
        return 'Camera';
      case AttachmentOption.gallery:
        return 'Gallery';
      case AttachmentOption.document:
        return 'Document';
      case AttachmentOption.audio:
        return 'Audio';
      case AttachmentOption.link:
        return 'Link';
    }
  }

  IconData get icon {
    switch (this) {
      case AttachmentOption.camera:
        return Icons.camera_alt_rounded;
      case AttachmentOption.gallery:
        return Icons.photo_library_rounded;
      case AttachmentOption.document:
        return Icons.picture_as_pdf_rounded;
      case AttachmentOption.audio:
        return Icons.audiotrack_rounded;
      case AttachmentOption.link:
        return Icons.link_rounded;
    }
  }

  Color get color {
    switch (this) {
      case AttachmentOption.camera:
        return AppColors.roleStudent;
      case AttachmentOption.gallery:
        return AppColors.contentPurple;
      case AttachmentOption.document:
        return AppColors.roleAdmin;
      case AttachmentOption.audio:
        return AppColors.contentGreen;
      case AttachmentOption.link:
        return AppColors.contentTeal;
    }
  }
}
