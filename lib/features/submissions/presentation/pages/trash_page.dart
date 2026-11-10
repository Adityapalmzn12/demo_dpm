import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';

import '../../../../app/redux/app_state.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../injection.dart';
import '../../domain/entities/submission.dart';
import '../redux/submissions_selectors.dart';
import '../redux/submissions_thunks.dart';
import '../widgets/submission_list_card.dart';

class TrashPage extends StatelessWidget {
  const TrashPage({super.key, required this.deps});

  final AppDependencies deps;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, deps),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(title: const Text('Trash')),
          body: vm.items.isEmpty
              ? const EmptyState(
                  icon: Icons.delete_outline,
                  title: 'Trash is empty',
                  subtitle: 'Deleted responses will appear here.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: vm.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = vm.items[index];
                    return SubmissionListCard(
                      submission: item,
                      onTap: () => context.push('/submissions/${item.id}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'restore') {
                            vm.onRestore(item.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Restored')),
                            );
                          } else if (value == 'delete') {
                            final confirmed = await showConfirmDialog(
                              context,
                              title: 'Delete forever?',
                              message:
                                  'This response will be permanently deleted. This cannot be undone.',
                              confirmLabel: 'Delete forever',
                            );
                            if (confirmed) {
                              vm.onDeleteForever(item.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Permanently deleted'),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'restore',
                            child: Text('Restore'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete forever'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

class _ViewModel {
  const _ViewModel({
    required this.items,
    required this.onRestore,
    required this.onDeleteForever,
  });

  final List<Submission> items;
  final ValueChanged<String> onRestore;
  final ValueChanged<String> onDeleteForever;

  factory _ViewModel.fromStore(Store<AppState> store, AppDependencies deps) {
    return _ViewModel(
      items: selectTrashedSubmissions(store.state),
      onRestore: (id) => store.dispatch(restoreSubmissionThunk(deps, id)),
      onDeleteForever: (id) =>
          store.dispatch(deletePermanentlyThunk(deps, id)),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is _ViewModel && other.items == items;

  @override
  int get hashCode => items.hashCode;
}
