import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../../../app/redux/app_state.dart';
import '../../../../injection.dart';
import '../../domain/entities/submission_status.dart';
import 'form_draft_actions.dart';
import 'submissions_actions.dart';

ThunkAction<AppState> loadSubmissionsThunk(AppDependencies deps) {
  return (Store<AppState> store) async {
    store.dispatch(const SubmissionsLoadRequestedAction());
    try {
      final items = await deps.loadSubmissions();
      store.dispatch(SubmissionsLoadedAction(items));
    } catch (error) {
      store.dispatch(SubmissionsLoadFailedAction(error.toString()));
    }
  };
}

ThunkAction<AppState> loadSchemaThunk(AppDependencies deps) {
  return (Store<AppState> store) async {
    if (store.state.formDraft.schema != null) return;
    store.dispatch(const SchemaLoadRequestedAction());
    try {
      final schema = await deps.schemaLoader.load();
      store.dispatch(SchemaLoadedAction(schema));
    } catch (error) {
      store.dispatch(SchemaLoadFailedAction(error.toString()));
    }
  };
}

ThunkAction<AppState> editDraftThunk(AppDependencies deps, String id) {
  return (Store<AppState> store) async {
    try {
      final submission = await deps.repository.getById(id);
      if (submission == null) {
        store.dispatch(
          const SubmissionMutationFailedAction('Draft not found'),
        );
        return;
      }

      // Set editing id + values first so schema load does not wipe them.
      store.dispatch(
        LoadDraftForEditAction(
          submissionId: submission.id,
          values: Map<String, dynamic>.from(submission.values),
        ),
      );

      if (store.state.formDraft.schema == null) {
        store.dispatch(const SchemaLoadRequestedAction());
        final schema = await deps.schemaLoader.load();
        store.dispatch(SchemaLoadedAction(schema));
      }
    } catch (error) {
      store.dispatch(SubmissionMutationFailedAction(error.toString()));
    }
  };
}

ThunkAction<AppState> submitFormThunk(AppDependencies deps) {
  return (Store<AppState> store) async {
    final draft = store.state.formDraft;
    final schema = draft.schema;
    if (schema == null) {
      store.dispatch(const SubmitFormFailedAction('Schema not loaded'));
      return;
    }

    final errors = deps.schemaValidator.validate(schema, draft.values);
    if (errors.isNotEmpty) {
      store.dispatch(SetFieldErrorsAction(errors));
      return;
    }

    store.dispatch(const SubmitFormRequestedAction());
    try {
      await deps.upsertSubmission(
        schema: schema,
        values: draft.values,
        status: SubmissionStatus.active,
        id: draft.editingSubmissionId,
      );
      final items = await deps.loadSubmissions();
      store.dispatch(SubmissionsLoadedAction(items));
      store.dispatch(const SubmitFormSucceededAction());
    } catch (error) {
      store.dispatch(SubmitFormFailedAction(error.toString()));
    }
  };
}

ThunkAction<AppState> saveDraftThunk(AppDependencies deps) {
  return (Store<AppState> store) async {
    final draft = store.state.formDraft;
    final schema = draft.schema;
    if (schema == null) {
      store.dispatch(const SaveDraftFailedAction('Schema not loaded'));
      return;
    }

    store.dispatch(const SaveDraftRequestedAction());
    try {
      await deps.upsertSubmission(
        schema: schema,
        values: draft.values,
        status: SubmissionStatus.draft,
        id: draft.editingSubmissionId,
      );
      final items = await deps.loadSubmissions();
      store.dispatch(SubmissionsLoadedAction(items));
      store.dispatch(const SaveDraftSucceededAction());
    } catch (error) {
      store.dispatch(SaveDraftFailedAction(error.toString()));
    }
  };
}

ThunkAction<AppState> moveToTrashThunk(AppDependencies deps, String id) {
  return (Store<AppState> store) async {
    try {
      await deps.moveToTrash(id);
      final items = await deps.loadSubmissions();
      store.dispatch(SubmissionsLoadedAction(items));
    } catch (error) {
      store.dispatch(SubmissionMutationFailedAction(error.toString()));
    }
  };
}

ThunkAction<AppState> restoreSubmissionThunk(AppDependencies deps, String id) {
  return (Store<AppState> store) async {
    try {
      await deps.restoreSubmission(id);
      final items = await deps.loadSubmissions();
      store.dispatch(SubmissionsLoadedAction(items));
    } catch (error) {
      store.dispatch(SubmissionMutationFailedAction(error.toString()));
    }
  };
}

ThunkAction<AppState> deletePermanentlyThunk(AppDependencies deps, String id) {
  return (Store<AppState> store) async {
    try {
      await deps.deletePermanently(id);
      final items = await deps.loadSubmissions();
      store.dispatch(SubmissionsLoadedAction(items));
    } catch (error) {
      store.dispatch(SubmissionMutationFailedAction(error.toString()));
    }
  };
}
