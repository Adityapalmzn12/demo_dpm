import 'package:uuid/uuid.dart';

import '../../../schema_form/domain/entities/form_schema.dart';
import '../entities/submission.dart';
import '../entities/submission_status.dart';
import '../repositories/submission_repository.dart';

class UpsertSubmission {
  UpsertSubmission(this._repository, {Uuid? uuid})
      : _uuid = uuid ?? const Uuid();

  final SubmissionRepository _repository;
  final Uuid _uuid;

  Future<Submission> call({
    required FormSchema schema,
    required Map<String, dynamic> values,
    required SubmissionStatus status,
    String? id,
  }) async {
    final now = DateTime.now().toUtc();

    if (id != null) {
      final existing = await _repository.getById(id);
      if (existing != null) {
        final updated = existing.copyWith(
          formId: schema.formId,
          schemaVersion: schema.version,
          values: Map<String, dynamic>.from(values),
          status: status,
          updatedAt: now,
          clearDeletedAt: status != SubmissionStatus.trashed,
        );
        await _repository.save(updated);
        return updated;
      }
    }

    final created = Submission(
      id: _uuid.v4(),
      formId: schema.formId,
      schemaVersion: schema.version,
      values: Map<String, dynamic>.from(values),
      status: status,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.save(created);
    return created;
  }
}
