import 'package:uuid/uuid.dart';

import '../../../schema_form/domain/entities/form_schema.dart';
import '../entities/submission.dart';
import '../entities/submission_status.dart';
import '../repositories/submission_repository.dart';

class CreateSubmission {
  CreateSubmission(this._repository, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final SubmissionRepository _repository;
  final Uuid _uuid;

  Future<Submission> call({
    required FormSchema schema,
    required Map<String, dynamic> values,
  }) async {
    final now = DateTime.now().toUtc();
    final submission = Submission(
      id: _uuid.v4(),
      formId: schema.formId,
      schemaVersion: schema.version,
      values: Map<String, dynamic>.from(values),
      status: SubmissionStatus.active,
      createdAt: now,
      updatedAt: now,
    );
    await _repository.save(submission);
    return submission;
  }
}
