import 'package:equatable/equatable.dart';

import 'submission_status.dart';

class Submission extends Equatable {
  const Submission({
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
  final SubmissionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isTrashed => status == SubmissionStatus.trashed;

  String get primaryPreview {
    final name = values['name'];
    if (name != null && name.toString().trim().isNotEmpty) {
      return name.toString();
    }
    if (values.isNotEmpty) {
      return values.values.first.toString();
    }
    return 'Untitled response';
  }

  Submission copyWith({
    String? id,
    String? formId,
    int? schemaVersion,
    Map<String, dynamic>? values,
    SubmissionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    bool clearDeletedAt = false,
  }) {
    return Submission(
      id: id ?? this.id,
      formId: formId ?? this.formId,
      schemaVersion: schemaVersion ?? this.schemaVersion,
      values: values ?? this.values,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: clearDeletedAt ? null : (deletedAt ?? this.deletedAt),
    );
  }

  @override
  List<Object?> get props => [
        id,
        formId,
        schemaVersion,
        values,
        status,
        createdAt,
        updatedAt,
        deletedAt,
      ];
}
