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
