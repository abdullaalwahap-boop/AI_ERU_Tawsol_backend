import 'package:ai_eru_tawasol/features/course/data/models/course_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── ContentFileType ───────────────────────────────────────────────────────

  group('ContentFileType.fromString', () {
    test('parses "pdf"', () {
      expect(ContentFileType.fromString('pdf'), ContentFileType.pdf);
    });
    test('parses "image"', () {
      expect(ContentFileType.fromString('image'), ContentFileType.image);
    });
    test('parses "word"', () {
      expect(ContentFileType.fromString('word'), ContentFileType.doc);
    });
    test('parses "ppt"', () {
      expect(ContentFileType.fromString('ppt'), ContentFileType.doc);
    });
    test('parses "python"', () {
      expect(ContentFileType.fromString('python'), ContentFileType.doc);
    });
    test('parses "jupyter"', () {
      expect(ContentFileType.fromString('jupyter'), ContentFileType.doc);
    });
    test('defaults to other for unknown', () {
      expect(ContentFileType.fromString('mp4'), ContentFileType.other);
    });
    test('handles null', () {
      expect(ContentFileType.fromString(null), ContentFileType.other);
    });
    test('is case-insensitive', () {
      expect(ContentFileType.fromString('PDF'), ContentFileType.pdf);
    });
  });

  // ── Course ────────────────────────────────────────────────────────────────

  group('Course.fromJson', () {
    final json = {
      'material_id': 'CS301',
      'name': 'Algorithms',
      'teacher_name': 'Dr. Waleed',
      'description': 'An intro to algorithms',
      'student_count': 40,
      'content_count': 15,
      'duration': 16,
    };

    test('parses all fields correctly', () {
      final course = Course.fromJson(json);
      expect(course.id, 'CS301');
      expect(course.code, 'CS301');
      expect(course.name, 'Algorithms');
      expect(course.doctorName, 'Dr. Waleed');
      expect(course.description, 'An intro to algorithms');
      expect(course.studentCount, 40);
      expect(course.contentCount, 15);
      expect(course.duration, 16);
    });

    test('defaults optional fields to empty/zero', () {
      final minimal = {'material_id': 'CS101', 'name': 'Intro'};
      final course = Course.fromJson(minimal);
      expect(course.doctorName, '');
      expect(course.description, '');
      expect(course.studentCount, 0);
      expect(course.contentCount, 0);
      expect(course.duration, 0);
    });

    test('accentColor is deterministic for same id', () {
      final c1 = Course.fromJson(json);
      final c2 = Course.fromJson(json);
      expect(c1.accentColor, c2.accentColor);
    });

    test('different ids can produce different colors', () {
      final c1 = Course.fromJson({'material_id': 'CS301', 'name': 'A'});
      final c2 = Course.fromJson({'material_id': 'CS999', 'name': 'B'});
      // Not guaranteed to differ but ids are different — just ensure no crash
      expect(c1.accentColor, isNotNull);
      expect(c2.accentColor, isNotNull);
    });
  });

  group('Course.initials', () {
    test('two-word name → first letters', () {
      final course = Course.fromJson({'material_id': 'X1', 'name': 'Computer Science'});
      expect(course.initials, 'CS');
    });

    test('single-word long name → first two letters', () {
      final course = Course.fromJson({'material_id': 'X1', 'name': 'Algorithms'});
      expect(course.initials, 'AL');
    });

    test('single uppercase letter name → returns it', () {
      final course = Course.fromJson({'material_id': 'X1', 'name': 'A'});
      expect(course.initials, 'A');
    });
  });

  // ── CourseContent factories ────────────────────────────────────────────────

  group('CourseContent.fromAssignment', () {
    final assignmentJson = {
      'assignment_id': 5,
      'title': 'Lab 1',
      'description': 'Write a lab report',
      'text_content': null,
      'deadline': '2099-12-31T23:59:00',
      'created_at': '2025-06-01T10:00:00',
      'author_name': 'Dr. Waleed',
      'file_type': null,
      'file_path': null,
      'link_url': null,
      'attachments': <dynamic>[],
    };

    test('parses assignment content correctly', () {
      final content = CourseContent.fromAssignment(assignmentJson);
      expect(content.id, '5');
      expect(content.title, 'Lab 1');
      expect(content.type, ContentType.assignment);
      expect(content.authorName, 'Dr. Waleed');
      expect(content.deadline, isNotNull);
    });

    test('body includes description', () {
      final content = CourseContent.fromAssignment(assignmentJson);
      expect(content.body, contains('Write a lab report'));
    });

    test('body includes deadline', () {
      final content = CourseContent.fromAssignment(assignmentJson);
      expect(content.body, contains('Deadline'));
    });

    test('builds link attachment from link_url', () {
      final json = Map<String, dynamic>.from(assignmentJson)
        ..['link_url'] = 'https://example.com';
      final content = CourseContent.fromAssignment(json);
      expect(content.attachments.length, 1);
      expect(content.attachments.first.url, 'https://example.com');
    });
  });

  group('CourseContent.fromFile', () {
    final fileJson = {
      'file_id': 7,
      'title': 'Lecture 1 Slides',
      'description': 'Intro lecture',
      'file_type': 'pdf',
      'file_path': '/uploads/lec1.pdf',
      'file_size': 2097152,
      'created_at': '2025-06-01T10:00:00',
      'author_type_code': 'DR',
    };

    test('parses file content correctly', () {
      final content = CourseContent.fromFile(fileJson);
      expect(content.id, '7');
      expect(content.title, 'Lecture 1 Slides');
      expect(content.type, ContentType.material);
      expect(content.fileIdInt, 7);
      expect(content.authorTypeCode, 'DR');
    });

    test('isQuizEligible for DR-uploaded pdf', () {
      final content = CourseContent.fromFile(fileJson);
      expect(content.isQuizEligible, true);
    });

    test('isQuizEligible is false for image type', () {
      final json = Map<String, dynamic>.from(fileJson)
        ..['file_type'] = 'image';
      final content = CourseContent.fromFile(json);
      expect(content.isQuizEligible, false);
    });
  });
}
