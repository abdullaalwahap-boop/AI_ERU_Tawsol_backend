class QuizOption {
  final String a;
  final String b;
  final String c;
  final String d;

  const QuizOption({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) => QuizOption(
        a: json['A'] as String,
        b: json['B'] as String,
        c: json['C'] as String,
        d: json['D'] as String,
      );

  String operator [](String key) {
    switch (key.toUpperCase()) {
      case 'A':
        return a;
      case 'B':
        return b;
      case 'C':
        return c;
      case 'D':
        return d;
      default:
        return '';
    }
  }
}
