import '../entities/submission.dart';
import '../entities/submission_status.dart';

class FilterSubmissions {
  const FilterSubmissions();

  /// Responses list: submitted + drafts (excludes trash).
  List<Submission> listVisible(List<Submission> all) => all
      .where(
        (s) =>
            s.status == SubmissionStatus.active ||
            s.status == SubmissionStatus.draft,
      )
      .toList();

  List<Submission> active(List<Submission> all) =>
      all.where((s) => s.status == SubmissionStatus.active).toList();

  List<Submission> drafts(List<Submission> all) =>
      all.where((s) => s.status == SubmissionStatus.draft).toList();

  List<Submission> trashed(List<Submission> all) =>
      all.where((s) => s.status == SubmissionStatus.trashed).toList();

  List<Submission> search(List<Submission> source, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return List<Submission>.from(source);

    return source.where((s) {
      if (s.status.label.toLowerCase().contains(q)) return true;
      if (s.createdAt.toIso8601String().toLowerCase().contains(q)) return true;
      if (s.primaryPreview.toLowerCase().contains(q)) return true;
      for (final entry in s.values.entries) {
        if (entry.key.toLowerCase().contains(q)) return true;
        if (entry.value.toString().toLowerCase().contains(q)) return true;
      }
      return false;
    }).toList();
  }
}
