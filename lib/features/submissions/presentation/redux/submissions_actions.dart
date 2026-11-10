import '../../domain/entities/submission.dart';

class SubmissionsLoadRequestedAction {
  const SubmissionsLoadRequestedAction();
}

class SubmissionsLoadedAction {
  const SubmissionsLoadedAction(this.items);

  final List<Submission> items;
}

class SubmissionsLoadFailedAction {
  const SubmissionsLoadFailedAction(this.message);

  final String message;
}

class SetSearchQueryAction {
  const SetSearchQueryAction(this.query);

  final String query;
}

class SubmissionMutationFailedAction {
  const SubmissionMutationFailedAction(this.message);

  final String message;
}
