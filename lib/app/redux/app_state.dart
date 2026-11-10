import 'package:equatable/equatable.dart';

import '../../features/submissions/presentation/redux/form_draft_state.dart';
import '../../features/submissions/presentation/redux/submissions_state.dart';

class AppState extends Equatable {
  const AppState({
    this.submissions = const SubmissionsState(),
    this.formDraft = const FormDraftState(),
  });

  final SubmissionsState submissions;
  final FormDraftState formDraft;

  AppState copyWith({
    SubmissionsState? submissions,
    FormDraftState? formDraft,
  }) {
    return AppState(
      submissions: submissions ?? this.submissions,
      formDraft: formDraft ?? this.formDraft,
    );
  }

  @override
  List<Object?> get props => [submissions, formDraft];
}
