import 'package:ai_eru_tawasol/features/profile/data/models/issue_type.dart';

class ContactRequest {
  const ContactRequest({
    required this.issueType,
    required this.subject,
    required this.message,
  });

  final IssueType issueType;
  final String subject;
  final String message;

  Map<String, dynamic> toJson() => {
        'issue_type': issueType.name,
        'subject': subject,
        'message': message,
      };
}
