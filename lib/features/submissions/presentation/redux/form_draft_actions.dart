import '../../../schema_form/domain/entities/form_schema.dart';

class SchemaLoadRequestedAction {
  const SchemaLoadRequestedAction();
}

class SchemaLoadedAction {
  const SchemaLoadedAction(this.schema);

  final FormSchema schema;
}

class SchemaLoadFailedAction {
  const SchemaLoadFailedAction(this.message);

  final String message;
}

class UpdateFieldValueAction {
  const UpdateFieldValueAction(this.fieldId, this.value);

  final String fieldId;
  final dynamic value;
}

class SetFieldErrorsAction {
  const SetFieldErrorsAction(this.errors);

  final Map<String, String> errors;
}

class ClearFormDraftAction {
  const ClearFormDraftAction();
}

class LoadDraftForEditAction {
  const LoadDraftForEditAction({
    required this.submissionId,
    required this.values,
  });

  final String submissionId;
  final Map<String, dynamic> values;
}

class SubmitFormRequestedAction {
  const SubmitFormRequestedAction();
}

class SubmitFormSucceededAction {
  const SubmitFormSucceededAction();
}

class ClearSubmitSucceededAction {
  const ClearSubmitSucceededAction();
}

class SubmitFormFailedAction {
  const SubmitFormFailedAction(this.message);

  final String message;
}

class SaveDraftRequestedAction {
  const SaveDraftRequestedAction();
}

class SaveDraftSucceededAction {
  const SaveDraftSucceededAction();
}

class ClearDraftSavedSucceededAction {
  const ClearDraftSavedSucceededAction();
}

class SaveDraftFailedAction {
  const SaveDraftFailedAction(this.message);

  final String message;
}
