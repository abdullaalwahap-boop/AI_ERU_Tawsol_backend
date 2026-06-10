import 'package:ai_eru_tawasol/features/chat/utils/chat_time_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatTimeFormatter.formatMessageTime', () {
    test('midnight → 12:00 AM', () {
      final dt = DateTime(2025, 6, 1, 0, 0);
      expect(ChatTimeFormatter.formatMessageTime(dt), '12:00 AM');
    });

    test('noon → 12:00 PM', () {
      final dt = DateTime(2025, 6, 1, 12, 0);
      expect(ChatTimeFormatter.formatMessageTime(dt), '12:00 PM');
    });

    test('1 AM → 1:00 AM', () {
      final dt = DateTime(2025, 6, 1, 1, 0);
      expect(ChatTimeFormatter.formatMessageTime(dt), '1:00 AM');
    });

    test('13:30 → 1:30 PM', () {
      final dt = DateTime(2025, 6, 1, 13, 30);
      expect(ChatTimeFormatter.formatMessageTime(dt), '1:30 PM');
    });

    test('23:59 → 11:59 PM', () {
      final dt = DateTime(2025, 6, 1, 23, 59);
      expect(ChatTimeFormatter.formatMessageTime(dt), '11:59 PM');
    });

    test('minutes are zero-padded', () {
      final dt = DateTime(2025, 6, 1, 9, 5);
      expect(ChatTimeFormatter.formatMessageTime(dt), '9:05 AM');
    });
  });

  group('ChatTimeFormatter.formatConversationTime', () {
    final now = DateTime.now();

    test('today → returns time string (h:mm AM/PM)', () {
      final today = DateTime(now.year, now.month, now.day, 9, 30);
      final result = ChatTimeFormatter.formatConversationTime(today);
      expect(result, matches(RegExp(r'^\d+:\d{2} (AM|PM)$')));
    });

    test('yesterday → returns "Yesterday"', () {
      final yesterday = now.subtract(const Duration(days: 1));
      final dt = DateTime(yesterday.year, yesterday.month, yesterday.day, 10);
      expect(ChatTimeFormatter.formatConversationTime(dt), 'Yesterday');
    });

    test('3 days ago → returns day name abbreviation', () {
      final threeDaysAgo = now.subtract(const Duration(days: 3));
      final result = ChatTimeFormatter.formatConversationTime(threeDaysAgo);
      const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      expect(dayNames, contains(result));
    });

    test('exactly 7 days ago → returns date format d/m/yy', () {
      final sevenDaysAgo = now.subtract(const Duration(days: 7));
      final result = ChatTimeFormatter.formatConversationTime(sevenDaysAgo);
      // Should match d/m/yy pattern
      expect(result, matches(RegExp(r'^\d+/\d+/\d{2}$')));
    });

    test('old date → returns d/m/yy format', () {
      final old = DateTime(2024, 1, 5);
      final result = ChatTimeFormatter.formatConversationTime(old);
      expect(result, '5/1/24');
    });
  });
}
