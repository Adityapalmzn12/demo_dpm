import '../entities/submission.dart';
import '../repositories/submission_repository.dart';

class LoadSubmissions {
  const LoadSubmissions(this._repository);

  final SubmissionRepository _repository;

  Future<List<Submission>> call() => _repository.getAll();
}
