import 'package:ai_eru_tawasol/features/chat/data/utils/link_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LinkUtils.containsUrl', () {
    test('returns true for http URL', () {
      expect(LinkUtils.containsUrl('check this http://example.com'), true);
    });

    test('returns true for https URL', () {
      expect(LinkUtils.containsUrl('https://example.com/path?q=1'), true);
    });

    test('returns false for plain text', () {
      expect(LinkUtils.containsUrl('Hello World'), false);
    });

    test('returns false for empty string', () {
      expect(LinkUtils.containsUrl(''), false);
    });

    test('returns false for email address', () {
      expect(LinkUtils.containsUrl('user@example.com'), false);
    });

    test('returns true when URL is embedded in sentence', () {
      expect(
        LinkUtils.containsUrl('Visit https://google.com for more info'),
        true,
      );
    });
  });

  group('LinkUtils.firstUrl', () {
    test('extracts http URL', () {
      expect(
        LinkUtils.firstUrl('see http://example.com please'),
        'http://example.com',
      );
    });

    test('extracts https URL', () {
      expect(
        LinkUtils.firstUrl('link: https://example.com/page'),
        'https://example.com/page',
      );
    });

    test('returns null for plain text', () {
      expect(LinkUtils.firstUrl('no links here'), isNull);
    });

    test('returns first URL when multiple exist', () {
      final result = LinkUtils.firstUrl(
        'see https://first.com and https://second.com',
      );
      expect(result, 'https://first.com');
    });

    test('returns null for empty string', () {
      expect(LinkUtils.firstUrl(''), isNull);
    });

    test('handles URL with query params', () {
      final url = 'https://example.com/search?q=flutter&page=1';
      expect(LinkUtils.firstUrl(url), url);
    });
  });
}
