import 'submissions_actions.dart';
import 'submissions_state.dart';

SubmissionsState submissionsReducer(
  SubmissionsState state,
  dynamic action,
) {
  if (action is SubmissionsLoadRequestedAction) {
    return state.copyWith(isLoading: true, clearError: true);
  }

  if (action is SubmissionsLoadedAction) {
    return state.copyWith(
      items: action.items,
      isLoading: false,
      clearError: true,
    );
  }

  if (action is SubmissionsLoadFailedAction) {
    return state.copyWith(isLoading: false, error: action.message);
  }

  if (action is SetSearchQueryAction) {
    return state.copyWith(searchQuery: action.query);
  }

  if (action is SubmissionMutationFailedAction) {
    return state.copyWith(error: action.message);
  }

  return state;
}
