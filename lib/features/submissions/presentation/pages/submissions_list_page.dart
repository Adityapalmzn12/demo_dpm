import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';

import '../../../../app/redux/app_state.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/gform_search_bar.dart';
import '../../../../injection.dart';
import '../../domain/entities/submission.dart';
import '../../domain/entities/submission_status.dart';
import '../redux/submissions_actions.dart';
import '../redux/submissions_selectors.dart';
import '../redux/submissions_thunks.dart';
import '../widgets/submission_list_card.dart';

class SubmissionsListPage extends StatelessWidget {
  const SubmissionsListPage({super.key, required this.deps});

  final AppDependencies deps;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store, deps),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Responses'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: GformSearchBar(
                  value: vm.searchQuery,
                  onChanged: vm.onSearchChanged,
                ),
              ),
              Expanded(
                child: vm.isLoading && vm.items.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : vm.items.isEmpty
                        ? EmptyState(
                            icon: Icons.inbox_outlined,
                            title: vm.searchQuery.isEmpty
                                ? 'No responses yet'
                                : 'No matching responses',
                            subtitle: vm.searchQuery.isEmpty
                                ? 'Submit or save a draft to see items here.'
                                : 'Try a different search term.',
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                            itemCount: vm.items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = vm.items[index];
                              final isDraft =
                                  item.status == SubmissionStatus.draft;
                              return SubmissionListCard(
                                submission: item,
                                onTap: () async {
                                  if (isDraft) {
                                    await vm.onEditDraft(item.id);
                                    if (context.mounted) {
                                      context.go('/add');
                                    }
                                  } else {
                                    context.push('/submissions/${item.id}');
                                  }
                                },
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) async {
                                    if (value == 'trash') {
                                      vm.onMoveToTrash(item.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('Moved to trash'),
                                        ),
                                      );
                                    } else if (value == 'edit') {
                                      await vm.onEditDraft(item.id);
                                      if (context.mounted) {
                                        context.go('/add');
                                      }
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    if (isDraft)
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit draft'),
                                      ),
                                    const PopupMenuItem(
                                      value: 'trash',
                                      child: Text('Move to trash'),
                                    ),
                                  ],
                                ),
                              );
                            },
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
    required this.items,
    required this.isLoading,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onMoveToTrash,
    required this.onEditDraft,
  });

  final List<Submission> items;
  final bool isLoading;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onMoveToTrash;
  final Future<void> Function(String id) onEditDraft;

  factory _ViewModel.fromStore(Store<AppState> store, AppDependencies deps) {
    return _ViewModel(
      items: selectFilteredActive(store.state),
      isLoading: selectSubmissionsLoading(store.state),
      searchQuery: selectSearchQuery(store.state),
      onSearchChanged: (query) =>
          store.dispatch(SetSearchQueryAction(query)),
      onMoveToTrash: (id) =>
          store.dispatch(moveToTrashThunk(deps, id)),
      onEditDraft: (id) async {
        await store.dispatch(editDraftThunk(deps, id));
      },
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _ViewModel &&
        other.isLoading == isLoading &&
        other.searchQuery == searchQuery &&
        other.items == items;
  }

  @override
  int get hashCode => Object.hash(isLoading, searchQuery, items);
}
