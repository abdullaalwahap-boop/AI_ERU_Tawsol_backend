import 'package:ai_eru_tawasol/features/announcement/data/models/assignment_model.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _baseJson() => {
      'assignment_id': 5,
      'material_id': 'CS301',
      'author_id': 10,
      'announcement_id': 20,
      'title': 'Lab Report 1',
      'description': 'Write a lab report',
      'deadline': '2099-12-31T23:59:00',
      'file_type': 'pdf',
      'file_path': '/uploads/lab.pdf',
      'link_url': null,
      'text_content': 'Submit via LMS',
      'created_at': '2025-06-01T10:00:00',
      'updated_at': null,
    };

void main() {
  group('Assignment.fromJson', () {
    test('parses all fields correctly', () {
      final a = Assignment.fromJson(_baseJson());

      expect(a.id, 5);
      expect(a.materialId, 'CS301');
      expect(a.authorId, 10);
      expect(a.announcementId, 20);
      expect(a.title, 'Lab Report 1');
      expect(a.description, 'Write a lab report');
      expect(a.fileType, 'pdf');
      expect(a.filePath, '/uploads/lab.pdf');
      expect(a.linkUrl, isNull);
      expect(a.textContent, 'Submit via LMS');
      expect(a.updatedAt, isNull);
    });

    test('parses deadline as DateTime', () {
      final a = Assignment.fromJson(_baseJson());
      expect(a.deadline.year, 2099);
      expect(a.deadline.month, 12);
    });

    test('parses createdAt as DateTime', () {
      final a = Assignment.fromJson(_baseJson());
      expect(a.createdAt.year, 2025);
      expect(a.createdAt.month, 6);
    });

    test('parses updatedAt when present', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['updated_at'] = '2025-06-10T08:00:00';
      final a = Assignment.fromJson(json);
      expect(a.updatedAt, isNotNull);
      expect(a.updatedAt!.year, 2025);
    });

    test('handles null optional fields', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['announcement_id'] = null
        ..['description'] = null
        ..['file_type'] = null
        ..['file_path'] = null
        ..['text_content'] = null;
      final a = Assignment.fromJson(json);
      expect(a.announcementId, isNull);
      expect(a.description, isNull);
      expect(a.fileType, isNull);
      expect(a.filePath, isNull);
      expect(a.textContent, isNull);
    });
  });

  group('Assignment display helpers', () {
    test('isOverdue returns false for future deadline', () {
      final a = Assignment.fromJson(_baseJson());
      expect(a.isOverdue, false);
    });

    test('isOverdue returns true for past deadline', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['deadline'] = '2000-01-01T00:00:00';
      final a = Assignment.fromJson(json);
      expect(a.isOverdue, true);
    });

    test('deadlineFormatted returns readable string', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['deadline'] = '2025-07-15T14:30:00';
      final a = Assignment.fromJson(json);
      expect(a.deadlineFormatted, contains('Jul'));
      expect(a.deadlineFormatted, contains('15'));
      expect(a.deadlineFormatted, contains('2025'));
    });

    test('timeUntilDeadline returns Overdue for past deadline', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['deadline'] = '2000-01-01T00:00:00';
      final a = Assignment.fromJson(json);
      expect(a.timeUntilDeadline, 'Overdue');
    });

    test('timeUntilDeadline returns days left for far future', () {
      final json = Map<String, dynamic>.from(_baseJson())
        ..['deadline'] = '2099-12-31T23:59:00';
      final a = Assignment.fromJson(json);
      expect(a.timeUntilDeadline, contains('days left'));
    });
  });

  group('Assignment.copyWith', () {
    final original = Assignment.fromJson(_baseJson());

    test('updates title only', () {
      final updated = original.copyWith(title: 'New Title');
      expect(updated.title, 'New Title');
      expect(updated.id, original.id);
      expect(updated.materialId, original.materialId);
    });

    test('updates description only', () {
      final updated = original.copyWith(description: 'New desc');
      expect(updated.description, 'New desc');
      expect(updated.title, original.title);
    });

    test('no-arg copyWith preserves all values', () {
      final copy = original.copyWith();
      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.deadline, original.deadline);
    });

    test('announcementId is preserved through copyWith', () {
      final updated = original.copyWith(title: 'x');
      expect(updated.announcementId, original.announcementId);
    });
  });
}
