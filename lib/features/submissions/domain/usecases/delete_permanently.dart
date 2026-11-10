import '../repositories/submission_repository.dart';

class DeletePermanently {
  const DeletePermanently(this._repository);

  final SubmissionRepository _repository;

  Future<void> call(String id) => _repository.delete(id);
}
