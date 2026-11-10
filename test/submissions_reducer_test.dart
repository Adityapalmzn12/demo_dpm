import 'package:demo_pfm/features/submissions/domain/entities/submission.dart';
import 'package:demo_pfm/features/submissions/domain/entities/submission_status.dart';
import 'package:demo_pfm/features/submissions/presentation/redux/submissions_actions.dart';
import 'package:demo_pfm/features/submissions/presentation/redux/submissions_reducer.dart';
import 'package:demo_pfm/features/submissions/presentation/redux/submissions_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2024, 5, 1);
  final submission = Submission(
    id: 'abc',
    formId: 'employee',
    schemaVersion: 1,
    values: const {'name': 'Ada'},
    status: SubmissionStatus.active,
    createdAt: now,
    updatedAt: now,
  );

  test('loads submissions into state', () {
    final next = submissionsReducer(
      const SubmissionsState(isLoading: true),
      SubmissionsLoadedAction([submission]),
    );

    expect(next.isLoading, isFalse);
    expect(next.items, [submission]);
    expect(next.error, isNull);
  });

  test('updates search query', () {
    final next = submissionsReducer(
      const SubmissionsState(),
      const SetSearchQueryAction('ada'),
    );

    expect(next.searchQuery, 'ada');
  });
}
