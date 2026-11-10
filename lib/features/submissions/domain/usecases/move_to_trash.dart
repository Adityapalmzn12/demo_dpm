import '../entities/submission.dart';
import '../entities/submission_status.dart';
import '../repositories/submission_repository.dart';

class MoveToTrash {
  const MoveToTrash(this._repository);

  final SubmissionRepository _repository;

  Future<Submission> call(String id) async {
    final existing = await _repository.getById(id);
    if (existing == null) {
      throw StateError('Submission not found: $id');
    }
    final now = DateTime.now().toUtc();
    final updated = existing.copyWith(
      status: SubmissionStatus.trashed,
      updatedAt: now,
      deletedAt: now,
    );
    await _repository.save(updated);
    return updated;
  }
}
