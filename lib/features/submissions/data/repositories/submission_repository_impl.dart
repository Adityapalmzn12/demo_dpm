import '../../domain/entities/submission.dart';
import '../../domain/repositories/submission_repository.dart';
import '../datasources/hive_submission_datasource.dart';
import '../models/submission_dto.dart';

class SubmissionRepositoryImpl implements SubmissionRepository {
  const SubmissionRepositoryImpl(this._datasource);

  final HiveSubmissionDatasource _datasource;

  @override
  Future<List<Submission>> getAll() async {
    return _datasource.getAll().map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Submission?> getById(String id) async {
    return _datasource.getById(id)?.toEntity();
  }

  @override
  Future<void> save(Submission submission) {
    return _datasource.save(SubmissionDto.fromEntity(submission));
  }

  @override
  Future<void> delete(String id) => _datasource.delete(id);
}
