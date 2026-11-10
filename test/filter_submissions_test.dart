import 'package:demo_pfm/features/submissions/domain/entities/submission.dart';
import 'package:demo_pfm/features/submissions/domain/entities/submission_status.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/filter_submissions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const filter = FilterSubmissions();
  final now = DateTime.utc(2024, 1, 1);

  final items = [
    Submission(
      id: '1',
      formId: 'employee',
      schemaVersion: 1,
      values: const {'name': 'Ada'},
      status: SubmissionStatus.active,
      createdAt: now,
      updatedAt: now,
    ),
    Submission(
      id: '2',
      formId: 'employee',
      schemaVersion: 1,
      values: const {'name': 'Grace'},
      status: SubmissionStatus.trashed,
      createdAt: now,
      updatedAt: now,
      deletedAt: now,
    ),
    Submission(
      id: '3',
      formId: 'employee',
      schemaVersion: 1,
      values: const {'name': 'Draft User'},
      status: SubmissionStatus.draft,
      createdAt: now,
      updatedAt: now,
    ),
  ];

  test('splits active, draft and trashed', () {
    expect(filter.active(items).map((e) => e.id), ['1']);
    expect(filter.drafts(items).map((e) => e.id), ['3']);
    expect(filter.trashed(items).map((e) => e.id), ['2']);
    expect(filter.listVisible(items).map((e) => e.id), ['1', '3']);
  });

  test('searches by value', () {
    final result = filter.search(filter.listVisible(items), 'ada');
    expect(result.map((e) => e.id), ['1']);
  });
}
