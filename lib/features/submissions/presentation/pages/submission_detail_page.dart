import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

import '../../../../app/redux/app_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../injection.dart';
import '../../../schema_form/domain/entities/form_schema.dart';
import '../../../schema_form/presentation/widgets/schema_form.dart';
import '../../domain/entities/submission.dart';
import '../../domain/entities/submission_status.dart';
import '../redux/submissions_selectors.dart';
import '../redux/submissions_thunks.dart';
import '../widgets/gform_header.dart';
import '../widgets/status_chip.dart';

class SubmissionDetailPage extends StatelessWidget {
  const SubmissionDetailPage({
    super.key,
    required this.deps,
    required this.submissionId,
  });

  final AppDependencies deps;
  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      onInit: (store) {
        store.dispatch(loadSchemaThunk(deps));
      },
      converter: (store) =>
          _ViewModel.fromStore(store, deps, submissionId),
      builder: (context, vm) {
        final submission = vm.submission;
        if (submission == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Response')),
            body: const Center(child: Text('Response not found')),
          );
        }

        final dateLabel = DateFormat('MMM d, yyyy · h:mm a')
            .format(submission.createdAt.toLocal());

        return Scaffold(
          appBar: AppBar(
            title: const Text('Response'),
            actions: [
              if (submission.status == SubmissionStatus.active)
                IconButton(
                  tooltip: 'Move to trash',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context,
                      title: 'Move to trash?',
                      message: 'This response will be moved to trash.',
                      confirmLabel: 'Move to trash',
                      isDestructive: false,
                    );
                    if (confirmed) {
                      vm.onMoveToTrash();
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                ),
              if (submission.status == SubmissionStatus.trashed) ...[
                IconButton(
                  tooltip: 'Restore',
                  icon: const Icon(Icons.restore),
                  onPressed: () {
                    vm.onRestore();
                    context.pop();
                  },
                ),
                IconButton(
                  tooltip: 'Delete forever',
                  icon: const Icon(Icons.delete_forever_outlined),
                  onPressed: () async {
                    final confirmed = await showConfirmDialog(
                      context,
                      title: 'Delete forever?',
                      message:
                          'This response will be permanently deleted. This cannot be undone.',
                      confirmLabel: 'Delete forever',
                    );
                    if (confirmed) {
                      vm.onDeleteForever();
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                ),
              ],
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              GformHeader(
                title: vm.schema?.displayTitle ?? submission.formId,
                description: 'Submitted $dateLabel',
              ),
              const SizedBox(height: 12),
              Material(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(8),
                elevation: 1,
                shadowColor: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      const Spacer(),
                      StatusChip(status: submission.status),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (vm.schema != null)
                SchemaForm(
                  schema: vm.schema!,
                  values: submission.values,
                  errors: const {},
                  onChanged: (_, __) {},
                  readOnly: true,
                )
              else
                ...submission.values.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(8),
                      elevation: 1,
                      child: ListTile(
                        title: Text(entry.key),
                        subtitle: Text(entry.value.toString()),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewModel {
  const _ViewModel({
    required this.submission,
    required this.schema,
    required this.onMoveToTrash,
    required this.onRestore,
    required this.onDeleteForever,
  });

  final Submission? submission;
  final FormSchema? schema;
  final VoidCallback onMoveToTrash;
  final VoidCallback onRestore;
  final VoidCallback onDeleteForever;

  factory _ViewModel.fromStore(
    Store<AppState> store,
    AppDependencies deps,
    String id,
  ) {
    return _ViewModel(
      submission: selectSubmissionById(store.state, id),
      schema: selectFormSchema(store.state),
      onMoveToTrash: () => store.dispatch(moveToTrashThunk(deps, id)),
      onRestore: () => store.dispatch(restoreSubmissionThunk(deps, id)),
      onDeleteForever: () =>
          store.dispatch(deletePermanentlyThunk(deps, id)),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is _ViewModel &&
      other.submission == submission &&
      other.schema == schema;

  @override
  int get hashCode => Object.hash(submission, schema);
}
