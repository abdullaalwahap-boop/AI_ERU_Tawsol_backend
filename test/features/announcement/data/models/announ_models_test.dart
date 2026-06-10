import 'package:ai_eru_tawasol/features/announcement/data/models/announ_models.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseJson() => {
      'announcement_id': 10,
      'title': 'Test Title',
      'content': 'Test body',
      'author_name': 'Dr. Waleed',
      'subject_name': 'Algorithms',
      'subject_code': 'CS301',
      'announcement_type': 'normal',
      'target_type': 'all',
      'priority': 'normal',
      'created_at': '2025-06-01T10:00:00',
      'is_read': false,
      'is_from_admin': false,
      'attachments': <dynamic>[],
      'author_id': 5,
    };

void main() {
  // ── AnnouncementPriority ───────────────────────────────────────────────────

  group('AnnouncementPriority.fromString', () {
    test('parses "important"', () {
      expect(AnnouncementPriority.fromString('important'),
          AnnouncementPriority.important);
    });
    test('parses "urgent"', () {
      expect(
          AnnouncementPriority.fromString('urgent'), AnnouncementPriority.urgent);
    });
    test('defaults to normal for unknown value', () {
      expect(AnnouncementPriority.fromString('random'),
          AnnouncementPriority.normal);
    });
  });

  group('AnnouncementPriority.toApiString', () {
    test('normal', () => expect(AnnouncementPriority.normal.toApiString, 'normal'));
    test('important',
        () => expect(AnnouncementPriority.important.toApiString, 'important'));
    test('urgent',
        () => expect(AnnouncementPriority.urgent.toApiString, 'urgent'));
  });

  // ── AnnouncementType ───────────────────────────────────────────────────────

  group('AnnouncementType.fromString', () {
    test('parses "material_file"', () {
      expect(AnnouncementType.fromString('material_file'),
          AnnouncementType.materialFile);
    });
    test('parses "assignment"', () {
      expect(AnnouncementType.fromString('assignment'),
          AnnouncementType.assignment);
    });
    test('defaults to normal for unknown', () {
      expect(AnnouncementType.fromString('xyz'), AnnouncementType.normal);
    });
  });

  group('AnnouncementType.toApiString', () {
    test('materialFile → "material_file"', () {
      expect(AnnouncementType.materialFile.toApiString, 'material_file');
    });
    test('assignment', () {
      expect(AnnouncementType.assignment.toApiString, 'assignment');
    });
    test('normal', () {
      expect(AnnouncementType.normal.toApiString, 'normal');
    });
  });

  // ── AnnouncementTarget ────────────────────────────────────────────────────

  group('AnnouncementTarget.fromString', () {
    final cases = {
      'course': AnnouncementTarget.course,
      'course_department': AnnouncementTarget.courseDepartment,
      'department': AnnouncementTarget.department,
      'level': AnnouncementTarget.level,
      'student': AnnouncementTarget.student,
      'users': AnnouncementTarget.users,
      'role': AnnouncementTarget.role,
      'all': AnnouncementTarget.all,
      'unknown': AnnouncementTarget.all,
    };
    cases.forEach((input, expected) {
      test('parses "$input"', () {
        expect(AnnouncementTarget.fromString(input), expected);
      });
    });
  });

  // ── AnnounAttachment ──────────────────────────────────────────────────────

  group('AnnounAttachment.fromJson', () {
    test('parses file_path correctly', () {
      final json = {
        'file_id': 1,
        'file_name': 'doc.pdf',
        'file_path': 'uploads/doc.pdf',
        'file_size': 2097152,
        'file_type': 'pdf',
      };
      final att = AnnounAttachment.fromJson(json);
      expect(att.name, 'doc.pdf');
      expect(att.fileType, AttachmentFileType.pdf);
      expect(att.sizeMB, greaterThan(0));
    });

    test('uses link_url when provided', () {
      final json = {
        'file_name': 'link',
        'link_url': 'https://example.com',
        'file_size': 0,
        'file_type': 'other',
      };
      final att = AnnounAttachment.fromJson(json);
      expect(att.url, 'https://example.com');
    });

    test('maps image type correctly', () {
      final json = {
        'file_name': 'photo.jpg',
        'file_path': '/uploads/photo.jpg',
        'file_size': 500,
        'file_type': 'image',
      };
      final att = AnnounAttachment.fromJson(json);
      expect(att.fileType, AttachmentFileType.image);
    });

    test('maps doc type correctly', () {
      final json = {
        'name': 'slide.pptx',
        'file_path': '/uploads/slide.pptx',
        'file_size': 1000,
        'file_type': 'pptx',
      };
      final att = AnnounAttachment.fromJson(json);
      expect(att.fileType, AttachmentFileType.doc);
    });

    test('converts large file_size bytes to MB', () {
      final json = {
        'file_name': 'big.pdf',
        'file_path': '/uploads/big.pdf',
        'file_size': 5242880,
        'file_type': 'pdf',
      };
      final att = AnnounAttachment.fromJson(json);
      expect(att.sizeMB, closeTo(5.0, 0.01));
    });
  });

  // ── Announcement ──────────────────────────────────────────────────────────

  group('Announcement.fromJson', () {
    test('parses full announcement correctly', () {
      final ann = Announcement.fromJson(_baseJson());
      expect(ann.id, '10');
      expect(ann.title, 'Test Title');
      expect(ann.body, 'Test body');
      expect(ann.doctorName, 'Dr. Waleed');
      expect(ann.subjectName, 'Algorithms');
      expect(ann.subjectCode, 'CS301');
      expect(ann.type, AnnouncementType.normal);
      expect(ann.target, AnnouncementTarget.all);
      expect(ann.priority, AnnouncementPriority.normal);
      expect(ann.isRead, false);
      expect(ann.isFromAdmin, false);
      expect(ann.attachments, isEmpty);
      expect(ann.authorId, 5);
    });

    test('handles missing optional fields gracefully', () {
      final json = {
        'announcement_id': 1,
        'created_at': '2025-06-01T10:00:00',
      };
      final ann = Announcement.fromJson(json);
      expect(ann.title, '');
      expect(ann.body, '');
      expect(ann.type, AnnouncementType.normal);
      expect(ann.priority, AnnouncementPriority.normal);
      expect(ann.target, AnnouncementTarget.all);
    });

    test('parses target_user_ids list', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['target_user_ids'] = [1, 2, 3];
      final ann = Announcement.fromJson(json);
      expect(ann.targetUserIds, [1, 2, 3]);
    });

    test('parses deadline field', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['deadline'] = '2025-07-01T23:59:00';
      final ann = Announcement.fromJson(json);
      expect(ann.deadline, isNotNull);
      expect(ann.deadline!.year, 2025);
      expect(ann.deadline!.month, 7);
    });
  });

  group('Announcement.toJson', () {
    test('serializes required fields', () {
      final ann = Announcement.fromJson(_baseJson());
      final json = ann.toJson();
      expect(json['title'], 'Test Title');
      expect(json['content'], 'Test body');
      expect(json['announcement_type'], 'normal');
      expect(json['priority'], 'normal');
      expect(json['target_type'], 'all');
    });

    test('omits null optional fields', () {
      final ann = Announcement.fromJson(_baseJson());
      final json = ann.toJson();
      expect(json.containsKey('target_course_id'), false);
      expect(json.containsKey('target_department'), false);
    });

    test('includes non-null optional fields', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['target_course_id'] = 'CS301'
        ..['target_year'] = 2;
      final ann = Announcement.fromJson(json);
      final result = ann.toJson();
      expect(result['target_course_id'], 'CS301');
      expect(result['target_year'], 2);
    });
  });

  group('Announcement.copyWith', () {
    test('updates isRead', () {
      final ann = Announcement.fromJson(_baseJson());
      final updated = ann.copyWith(isRead: true);
      expect(updated.isRead, true);
      expect(updated.title, ann.title);
    });

    test('updates title only', () {
      final ann = Announcement.fromJson(_baseJson());
      final updated = ann.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.body, ann.body);
    });
  });

  group('Announcement display helpers', () {
    test('doctorInitials returns first letters of two-word name', () {
      final ann = Announcement.fromJson(
        Map<String, dynamic>.from(_baseJson())..['author_name'] = 'Ahmed Waleed',
      );
      expect(ann.doctorInitials, 'AW');
    });

    test('doctorInitials returns single letter for single-word name', () {
      final ann = Announcement.fromJson(
        Map<String, dynamic>.from(_baseJson())..['author_name'] = 'Ahmed',
      );
      expect(ann.doctorInitials, 'A');
    });

    test('doctorInitials returns ? for empty name', () {
      final ann = Announcement.fromJson(
        Map<String, dynamic>.from(_baseJson())..['author_name'] = '',
      );
      expect(ann.doctorInitials, '?');
    });

    test('subjectInitials returns first letters', () {
      final ann = Announcement.fromJson(
        Map<String, dynamic>.from(_baseJson())
          ..['subject_name'] = 'Computer Science',
      );
      expect(ann.subjectInitials, 'CS');
    });

    test('formattedDate returns correct format', () {
      final ann = Announcement.fromJson(_baseJson());
      expect(ann.formattedDate, 'Jun 1, 2025');
    });
  });

  // ── CourseOption ──────────────────────────────────────────────────────────

  group('CourseOption.fromJson', () {
    test('parses all fields', () {
      final json = {
        'material_id': 'CS301',
        'name': 'Algorithms',
        'department_course': 'CS',
      };
      final opt = CourseOption.fromJson(json);
      expect(opt.id, 'CS301');
      expect(opt.name, 'Algorithms');
      expect(opt.departmentCourse, 'CS');
    });

    test('displayName includes name and id', () {
      final opt = CourseOption(id: 'CS301', name: 'Algorithms');
      expect(opt.displayName, 'Algorithms · CS301');
    });
  });
}
