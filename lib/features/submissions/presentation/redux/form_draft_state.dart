import 'package:equatable/equatable.dart';

import '../../../schema_form/domain/entities/form_schema.dart';

class FormDraftState extends Equatable {
  const FormDraftState({
    this.schema,
    this.values = const {},
    this.fieldErrors = const {},
    this.isLoadingSchema = false,
    this.isSubmitting = false,
    this.schemaError,
    this.submitError,
    this.submitSucceeded = false,
    this.draftSavedSucceeded = false,
    this.editingSubmissionId,
  });

  final FormSchema? schema;
  final Map<String, dynamic> values;
  final Map<String, String> fieldErrors;
  final bool isLoadingSchema;
  final bool isSubmitting;
  final String? schemaError;
  final String? submitError;
  final bool submitSucceeded;
  final bool draftSavedSucceeded;
  final String? editingSubmissionId;

  bool get isEditingDraft => editingSubmissionId != null;

  FormDraftState copyWith({
    FormSchema? schema,
    Map<String, dynamic>? values,
    Map<String, String>? fieldErrors,
    bool? isLoadingSchema,
    bool? isSubmitting,
    String? schemaError,
    bool clearSchemaError = false,
    String? submitError,
    bool clearSubmitError = false,
    bool? submitSucceeded,
    bool? draftSavedSucceeded,
    String? editingSubmissionId,
    bool clearEditingSubmissionId = false,
  }) {
    return FormDraftState(
      schema: schema ?? this.schema,
      values: values ?? this.values,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      isLoadingSchema: isLoadingSchema ?? this.isLoadingSchema,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      schemaError: clearSchemaError ? null : (schemaError ?? this.schemaError),
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      submitSucceeded: submitSucceeded ?? this.submitSucceeded,
      draftSavedSucceeded: draftSavedSucceeded ?? this.draftSavedSucceeded,
      editingSubmissionId: clearEditingSubmissionId
          ? null
          : (editingSubmissionId ?? this.editingSubmissionId),
    );
  }

  @override
  List<Object?> get props => [
        schema,
        values,
        fieldErrors,
        isLoadingSchema,
        isSubmitting,
        schemaError,
        submitError,
        submitSucceeded,
        draftSavedSucceeded,
        editingSubmissionId,
      ];
}
