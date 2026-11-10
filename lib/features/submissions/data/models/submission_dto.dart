import '../../domain/entities/submission.dart';
import '../../domain/entities/submission_status.dart';

class SubmissionDto {
  const SubmissionDto({
    required this.id,
    required this.formId,
    required this.schemaVersion,
    required this.values,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String formId;
  final int schemaVersion;
  final Map<String, dynamic> values;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  factory SubmissionDto.fromEntity(Submission entity) {
    return SubmissionDto(
      id: entity.id,
      formId: entity.formId,
      schemaVersion: entity.schemaVersion,
      values: Map<String, dynamic>.from(entity.values),
      status: entity.status.name,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      deletedAt: entity.deletedAt?.toIso8601String(),
    );
  }

  factory SubmissionDto.fromJson(Map<dynamic, dynamic> json) {
    final valuesRaw = json['values'];
    final values = <String, dynamic>{};
    if (valuesRaw is Map) {
      valuesRaw.forEach((key, value) {
        values[key.toString()] = value;
      });
    }

    return SubmissionDto(
      id: json['id'] as String,
      formId: json['formId'] as String,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      values: values,
      status: json['status'] as String? ?? SubmissionStatus.active.name,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      deletedAt: json['deletedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'formId': formId,
        'schemaVersion': schemaVersion,
        'values': values,
        'status': status,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'deletedAt': deletedAt,
      };

  Submission toEntity() {
    return Submission(
      id: id,
      formId: formId,
      schemaVersion: schemaVersion,
      values: Map<String, dynamic>.from(values),
      status: SubmissionStatus.fromString(status),
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      deletedAt: deletedAt != null ? DateTime.parse(deletedAt!) : null,
    );
  }
}
