enum IssueType {
  technical,
  course,
  account,
  general;

  String get label {
    switch (this) {
      case IssueType.technical:
        return 'Technical';
      case IssueType.course:
        return 'Course';
      case IssueType.account:
        return 'Account';
      case IssueType.general:
        return 'General';
    }
  }
}

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
