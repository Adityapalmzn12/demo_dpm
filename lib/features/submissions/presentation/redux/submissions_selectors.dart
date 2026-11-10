import '../../../../app/redux/app_state.dart';
import '../../../schema_form/domain/entities/form_schema.dart';
import '../../domain/entities/submission.dart';
import '../../domain/usecases/filter_submissions.dart';
import 'form_draft_state.dart';

const _filter = FilterSubmissions();

List<Submission> selectAllSubmissions(AppState state) =>
    state.submissions.items;

List<Submission> selectActiveSubmissions(AppState state) =>
    _filter.active(state.submissions.items);

List<Submission> selectListVisibleSubmissions(AppState state) =>
    _filter.listVisible(state.submissions.items);

List<Submission> selectTrashedSubmissions(AppState state) =>
    _filter.trashed(state.submissions.items);

List<Submission> selectFilteredActive(AppState state) {
  final visible = selectListVisibleSubmissions(state);
  return _filter.search(visible, state.submissions.searchQuery);
}

Submission? selectSubmissionById(AppState state, String id) {
  try {
    return state.submissions.items.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}

FormDraftState selectFormDraft(AppState state) => state.formDraft;

FormSchema? selectFormSchema(AppState state) => state.formDraft.schema;

String selectSearchQuery(AppState state) => state.submissions.searchQuery;

bool selectSubmissionsLoading(AppState state) => state.submissions.isLoading;
