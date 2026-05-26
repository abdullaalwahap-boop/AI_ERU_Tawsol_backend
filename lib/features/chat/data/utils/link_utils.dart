abstract class LinkUtils {
  static final _urlRegex = RegExp(
    r'https?://[^\s<>"{}|\\^`\[\]]+',
    caseSensitive: false,
  );

  /// Returns true if [text] contains at least one URL.
  static bool containsUrl(String text) => _urlRegex.hasMatch(text);

  /// Returns the first URL found in [text], or null.
  static String? firstUrl(String text) =>
      _urlRegex.firstMatch(text)?.group(0);
}
