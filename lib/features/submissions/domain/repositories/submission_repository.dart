import '../entities/submission.dart';

abstract class SubmissionRepository {
  Future<List<Submission>> getAll();

  Future<Submission?> getById(String id);

  Future<void> save(Submission submission);

  Future<void> delete(String id);
}
