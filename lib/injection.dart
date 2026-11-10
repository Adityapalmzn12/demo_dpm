import 'features/schema_form/data/schema_loader.dart';
import 'features/schema_form/domain/services/schema_validator.dart';
import 'features/submissions/data/datasources/hive_submission_datasource.dart';
import 'features/submissions/data/repositories/submission_repository_impl.dart';
import 'features/submissions/domain/repositories/submission_repository.dart';
import 'features/submissions/domain/usecases/create_submission.dart';
import 'features/submissions/domain/usecases/delete_permanently.dart';
import 'features/submissions/domain/usecases/filter_submissions.dart';
import 'features/submissions/domain/usecases/load_submissions.dart';
import 'features/submissions/domain/usecases/move_to_trash.dart';
import 'features/submissions/domain/usecases/restore_submission.dart';
import 'features/submissions/domain/usecases/upsert_submission.dart';

/// Composition root — wires data implementations to domain use cases.
class AppDependencies {
  AppDependencies._({
    required this.repository,
    required this.schemaLoader,
    required this.schemaValidator,
    required this.loadSubmissions,
    required this.createSubmission,
    required this.upsertSubmission,
    required this.moveToTrash,
    required this.restoreSubmission,
    required this.deletePermanently,
    required this.filterSubmissions,
  });

  factory AppDependencies.forTest({
    required SubmissionRepository repository,
    required SchemaLoader schemaLoader,
    required SchemaValidator schemaValidator,
    required LoadSubmissions loadSubmissions,
    required CreateSubmission createSubmission,
    required UpsertSubmission upsertSubmission,
    required MoveToTrash moveToTrash,
    required RestoreSubmission restoreSubmission,
    required DeletePermanently deletePermanently,
    required FilterSubmissions filterSubmissions,
  }) {
    return AppDependencies._(
      repository: repository,
      schemaLoader: schemaLoader,
      schemaValidator: schemaValidator,
      loadSubmissions: loadSubmissions,
      createSubmission: createSubmission,
      upsertSubmission: upsertSubmission,
      moveToTrash: moveToTrash,
      restoreSubmission: restoreSubmission,
      deletePermanently: deletePermanently,
      filterSubmissions: filterSubmissions,
    );
  }

  final SubmissionRepository repository;
  final SchemaLoader schemaLoader;
  final SchemaValidator schemaValidator;
  final LoadSubmissions loadSubmissions;
  final CreateSubmission createSubmission;
  final UpsertSubmission upsertSubmission;
  final MoveToTrash moveToTrash;
  final RestoreSubmission restoreSubmission;
  final DeletePermanently deletePermanently;
  final FilterSubmissions filterSubmissions;

  static Future<AppDependencies> create() async {
    final datasource = await HiveSubmissionDatasource.create();
    final repository = SubmissionRepositoryImpl(datasource);
    const schemaLoader = SchemaLoader();
    const schemaValidator = SchemaValidator();

    return AppDependencies._(
      repository: repository,
      schemaLoader: schemaLoader,
      schemaValidator: schemaValidator,
      loadSubmissions: LoadSubmissions(repository),
      createSubmission: CreateSubmission(repository),
      upsertSubmission: UpsertSubmission(repository),
      moveToTrash: MoveToTrash(repository),
      restoreSubmission: RestoreSubmission(repository),
      deletePermanently: DeletePermanently(repository),
      filterSubmissions: const FilterSubmissions(),
    );
  }
}
