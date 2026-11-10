import 'package:demo_pfm/app/app.dart';
import 'package:demo_pfm/app/redux/store.dart';
import 'package:demo_pfm/features/schema_form/data/schema_loader.dart';
import 'package:demo_pfm/features/schema_form/domain/services/schema_validator.dart';
import 'package:demo_pfm/features/submissions/domain/entities/submission.dart';
import 'package:demo_pfm/features/submissions/domain/repositories/submission_repository.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/create_submission.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/delete_permanently.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/filter_submissions.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/load_submissions.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/move_to_trash.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/restore_submission.dart';
import 'package:demo_pfm/features/submissions/domain/usecases/upsert_submission.dart';
import 'package:demo_pfm/injection.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements SubmissionRepository {
  final List<Submission> items = [];

  @override
  Future<void> delete(String id) async {
    items.removeWhere((e) => e.id == id);
  }

  @override
  Future<List<Submission>> getAll() async => List.of(items);

  @override
  Future<Submission?> getById(String id) async {
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> save(Submission submission) async {
    items.removeWhere((e) => e.id == submission.id);
    items.add(submission);
  }
}

void main() {
  testWidgets('app boots with shell destinations', (tester) async {
    final repo = _FakeRepo();
    final deps = AppDependencies.forTest(
      repository: repo,
      schemaLoader: const SchemaLoader(),
      schemaValidator: const SchemaValidator(),
      loadSubmissions: LoadSubmissions(repo),
      createSubmission: CreateSubmission(repo),
      upsertSubmission: UpsertSubmission(repo),
      moveToTrash: MoveToTrash(repo),
      restoreSubmission: RestoreSubmission(repo),
      deletePermanently: DeletePermanently(repo),
      filterSubmissions: const FilterSubmissions(),
    );

    await tester.pumpWidget(
      SchemaFormApp(store: createAppStore(), deps: deps),
    );
    await tester.pumpAndSettle();

    expect(find.text('Responses'), findsWidgets);
    expect(find.text('Form'), findsOneWidget);
    expect(find.text('Trash'), findsOneWidget);
  });
}
