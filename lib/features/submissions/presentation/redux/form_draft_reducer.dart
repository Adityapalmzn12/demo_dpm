import '../../../schema_form/domain/entities/field_type.dart';
import '../../../schema_form/domain/entities/form_schema.dart';
import 'form_draft_actions.dart';
import 'form_draft_state.dart';

Map<String, dynamic> _initialValuesForSchema(FormSchema? schema) {
  final initialValues = <String, dynamic>{};
  if (schema == null) return initialValues;
  for (final field in schema.fields) {
    if (field.type == FieldType.checkbox) {
      initialValues[field.id] = false;
    }
  }
  return initialValues;
}

FormDraftState formDraftReducer(FormDraftState state, dynamic action) {
  if (action is SchemaLoadRequestedAction) {
    return state.copyWith(isLoadingSchema: true, clearSchemaError: true);
  }

  if (action is SchemaLoadedAction) {
    final keepExistingValues = state.editingSubmissionId != null;
    return state.copyWith(
      schema: action.schema,
      values: keepExistingValues
          ? state.values
          : _initialValuesForSchema(action.schema),
      fieldErrors: keepExistingValues ? state.fieldErrors : const {},
      isLoadingSchema: false,
      clearSchemaError: true,
      clearSubmitError: true,
    );
  }

  if (action is SchemaLoadFailedAction) {
    return state.copyWith(
      isLoadingSchema: false,
      schemaError: action.message,
    );
  }

  if (action is UpdateFieldValueAction) {
    final nextValues = Map<String, dynamic>.from(state.values)
      ..[action.fieldId] = action.value;
    final nextErrors = Map<String, String>.from(state.fieldErrors)
      ..remove(action.fieldId);

    // Changing employment can invalidate/repair joinedOn cross-field rule.
    if (action.fieldId == 'employment') {
      nextErrors.remove('joinedOn');
    }

    return state.copyWith(values: nextValues, fieldErrors: nextErrors);
  }

  if (action is SetFieldErrorsAction) {
    return state.copyWith(fieldErrors: action.errors);
  }

  if (action is LoadDraftForEditAction) {
    return state.copyWith(
      editingSubmissionId: action.submissionId,
      values: Map<String, dynamic>.from(action.values),
      fieldErrors: const {},
      clearSubmitError: true,
      submitSucceeded: false,
      draftSavedSucceeded: false,
    );
  }

  if (action is ClearFormDraftAction) {
    final schema = state.schema;
    return FormDraftState(
      schema: schema,
      values: _initialValuesForSchema(schema),
    );
  }

  if (action is SubmitFormRequestedAction) {
    return state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      submitSucceeded: false,
      draftSavedSucceeded: false,
    );
  }

  if (action is SubmitFormSucceededAction) {
    final schema = state.schema;
    return FormDraftState(
      schema: schema,
      values: _initialValuesForSchema(schema),
      submitSucceeded: true,
    );
  }

  if (action is ClearSubmitSucceededAction) {
    return state.copyWith(submitSucceeded: false);
  }

  if (action is SubmitFormFailedAction) {
    return state.copyWith(
      isSubmitting: false,
      submitError: action.message,
      submitSucceeded: false,
    );
  }

  if (action is SaveDraftRequestedAction) {
    return state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      draftSavedSucceeded: false,
      submitSucceeded: false,
    );
  }

  if (action is SaveDraftSucceededAction) {
    final schema = state.schema;
    return FormDraftState(
      schema: schema,
      values: _initialValuesForSchema(schema),
      draftSavedSucceeded: true,
    );
  }

  if (action is ClearDraftSavedSucceededAction) {
    return state.copyWith(draftSavedSucceeded: false);
  }

  if (action is SaveDraftFailedAction) {
    return state.copyWith(
      isSubmitting: false,
      submitError: action.message,
      draftSavedSucceeded: false,
    );
  }

  return state;
}
