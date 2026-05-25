abstract class ChatTimeFormatter {
  /// Returns `h:mm AM/PM` — used inside message bubbles.
  static String formatMessageTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  /// Returns today→`h:mm AM/PM`, yesterday→`Yesterday`,
  /// within 7 days→day name, older→`d/m/yy`.
  static String formatConversationTime(DateTime dt) {
    final now = DateTime.now();

    final isSameDay =
        now.year == dt.year && now.month == dt.month && now.day == dt.day;
    if (isSameDay) return formatMessageTime(dt);

    final yesterday = now.subtract(const Duration(days: 1));
    final isYesterday = yesterday.year == dt.year &&
        yesterday.month == dt.month &&
        yesterday.day == dt.day;
    if (isYesterday) return 'Yesterday';

    if (now.difference(dt).inDays < 7) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[dt.weekday - 1];
    }

    return '${dt.day}/${dt.month}/${dt.year % 100}';
  }
}
