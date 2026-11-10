enum SubmissionStatus {
  active,
  draft,
  trashed;

  String get label {
    switch (this) {
      case SubmissionStatus.active:
        return 'Active';
      case SubmissionStatus.draft:
        return 'Draft';
      case SubmissionStatus.trashed:
        return 'Trashed';
    }
  }

  static SubmissionStatus fromString(String value) {
    return SubmissionStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SubmissionStatus.active,
    );
  }
}
