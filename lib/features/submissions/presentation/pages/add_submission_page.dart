import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';

import '../../../../app/redux/app_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../injection.dart';
import '../../../schema_form/domain/entities/form_schema.dart';
import '../../../schema_form/presentation/widgets/schema_form.dart';
import '../redux/form_draft_actions.dart';
import '../redux/submissions_selectors.dart';
import '../redux/submissions_thunks.dart';
import '../widgets/gform_header.dart';

class AddSubmissionPage extends StatelessWidget {
  const AddSubmissionPage({required this.deps});

  final AppDependencies deps;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      onInit: (store) {
        store.dispatch(loadSchemaThunk(deps));
      },
      converter: (store) => _ViewModel.fromStore(store, deps),
      onWillChange: (previous, current) {
        if (previous?.submitSucceeded != true && current.submitSucceeded) {
          current.onClearSubmitSucceeded();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Response submitted')));
          context.go('/submissions');
        }
        if (previous?.draftSavedSucceeded != true && current.draftSavedSucceeded) {
          current.onClearDraftSavedSucceeded();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Draft saved')));
          context.go('/submissions');
        }
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: Text(vm.isEditingDraft ? 'Edit draft' : 'Form'),
            actions: [if (vm.isEditingDraft) TextButton(onPressed: vm.isSubmitting ? null : vm.onClearForm, child: const Text('New form'))],
          ),
          body: vm.isLoadingSchema
              ? const Center(child: CircularProgressIndicator())
              : vm.schemaError != null
              ? Center(child: Text(vm.schemaError!))
              : vm.schema == null
              ? const Center(child: Text('Schema unavailable'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        children: [
                          GformHeader(title: vm.schema!.displayTitle, description: vm.isEditingDraft ? 'Continue editing your saved draft.' : vm.schema!.displayDescription),
                          const SizedBox(height: 12),
                          SchemaForm(schema: vm.schema!, values: vm.values, errors: vm.errors, onChanged: vm.onFieldChanged),
                          if (vm.submitError != null) ...[const SizedBox(height: 8), Text(vm.submitError!, style: const TextStyle(color: AppColors.error))],
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        width: double.infinity,
                        color: AppColors.card,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: Row(
                          children: [
                            OutlinedButton.icon(
                              onPressed: vm.isSubmitting ? null : vm.onSaveDraft,
                              icon: const Icon(Icons.drafts_outlined),
                              label: const Text('Draft'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.draftAccent,
                                side: const BorderSide(color: AppColors.draftAccent),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: vm.isSubmitting ? null : vm.onSubmit,
                              child: vm.isSubmitting ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ViewModel {
  const _ViewModel({
    required this.schema,
    required this.values,
    required this.errors,
    required this.isLoadingSchema,
    required this.isSubmitting,
    required this.schemaError,
    required this.submitError,
    required this.submitSucceeded,
    required this.draftSavedSucceeded,
    required this.isEditingDraft,
    required this.onFieldChanged,
    required this.onSubmit,
    required this.onSaveDraft,
    required this.onClearForm,
    required this.onClearSubmitSucceeded,
    required this.onClearDraftSavedSucceeded,
  });

  final FormSchema? schema;
  final Map<String, dynamic> values;
  final Map<String, String> errors;
  final bool isLoadingSchema;
  final bool isSubmitting;
  final String? schemaError;
  final String? submitError;
  final bool submitSucceeded;
  final bool draftSavedSucceeded;
  final bool isEditingDraft;
  final void Function(String fieldId, dynamic value) onFieldChanged;
  final VoidCallback onSubmit;
  final VoidCallback onSaveDraft;
  final VoidCallback onClearForm;
  final VoidCallback onClearSubmitSucceeded;
  final VoidCallback onClearDraftSavedSucceeded;

  factory _ViewModel.fromStore(Store<AppState> store, AppDependencies deps) {
    final draft = selectFormDraft(store.state);
    return _ViewModel(
      schema: draft.schema,
      values: draft.values,
      errors: draft.fieldErrors,
      isLoadingSchema: draft.isLoadingSchema,
      isSubmitting: draft.isSubmitting,
      schemaError: draft.schemaError,
      submitError: draft.submitError,
      submitSucceeded: draft.submitSucceeded,
      draftSavedSucceeded: draft.draftSavedSucceeded,
      isEditingDraft: draft.isEditingDraft,
      onFieldChanged: (fieldId, value) {
        store.dispatch(UpdateFieldValueAction(fieldId, value));
      },
      onSubmit: () => store.dispatch(submitFormThunk(deps)),
      onSaveDraft: () => store.dispatch(saveDraftThunk(deps)),
      onClearForm: () => store.dispatch(const ClearFormDraftAction()),
      onClearSubmitSucceeded: () => store.dispatch(const ClearSubmitSucceededAction()),
      onClearDraftSavedSucceeded: () => store.dispatch(const ClearDraftSavedSucceededAction()),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _ViewModel &&
        other.schema == schema &&
        other.values == values &&
        other.errors == errors &&
        other.isLoadingSchema == isLoadingSchema &&
        other.isSubmitting == isSubmitting &&
        other.schemaError == schemaError &&
        other.submitError == submitError &&
        other.submitSucceeded == submitSucceeded &&
        other.draftSavedSucceeded == draftSavedSucceeded &&
        other.isEditingDraft == isEditingDraft;
  }

  @override
  int get hashCode => Object.hash(schema, values, errors, isLoadingSchema, isSubmitting, schemaError, submitError, submitSucceeded, draftSavedSucceeded, isEditingDraft);
}
