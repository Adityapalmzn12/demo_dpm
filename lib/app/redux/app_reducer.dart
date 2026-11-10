import '../../features/submissions/presentation/redux/form_draft_reducer.dart';
import '../../features/submissions/presentation/redux/submissions_reducer.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    submissions: submissionsReducer(state.submissions, action),
    formDraft: formDraftReducer(state.formDraft, action),
  );
}
