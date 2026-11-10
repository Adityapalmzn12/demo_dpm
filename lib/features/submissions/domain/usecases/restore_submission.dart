import '../entities/submission.dart';
import '../entities/submission_status.dart';
import '../repositories/submission_repository.dart';

class RestoreSubmission {
  const RestoreSubmission(this._repository);

  final SubmissionRepository _repository;

  Future<Submission> call(String id) async {
    final existing = await _repository.getById(id);
    if (existing == null) {
      throw StateError('Submission not found: $id');
    }
    final updated = existing.copyWith(
      status: SubmissionStatus.active,
      updatedAt: DateTime.now().toUtc(),
      clearDeletedAt: true,
    );
    await _repository.save(updated);
    return updated;
  }
}
