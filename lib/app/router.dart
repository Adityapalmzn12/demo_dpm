import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../features/submissions/presentation/pages/add_submission_page.dart';
import '../features/submissions/presentation/pages/submission_detail_page.dart';
import '../features/submissions/presentation/pages/submissions_list_page.dart';
import '../features/submissions/presentation/pages/trash_page.dart';
import '../injection.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

GoRouter createRouter(AppDependencies deps) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/submissions',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/submissions',
                builder: (context, state) =>
                    SubmissionsListPage(deps: deps),
                routes: [
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return SubmissionDetailPage(
                        deps: deps,
                        submissionId: id,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/add',
                builder: (context, state) => AddSubmissionPage(deps: deps),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trash',
                builder: (context, state) => TrashPage(deps: deps),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _AppShell extends StatelessWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const int _responsesBranch = 0;
  static const int _formBranch = 1;
  static const int _trashBranch = 2;

  void _goBranch(int branchIndex) {
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _FormFloatingButton(
        selected: current == _formBranch,
        onPressed: () => _goBranch(_formBranch),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.card,
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.inbox_outlined,
                  selectedIcon: Icons.inbox,
                  label: 'Responses',
                  selected: current == _responsesBranch,
                  onTap: () => _goBranch(_responsesBranch),
                ),
              ),
              const SizedBox(width: 72),
              Expanded(
                child: _BottomNavItem(
                  icon: Icons.delete_outline,
                  selectedIcon: Icons.delete,
                  label: 'Trash',
                  selected: current == _trashBranch,
                  onTap: () => _goBranch(_trashBranch),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.purple : AppColors.textSecondary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(selected ? selectedIcon : icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormFloatingButton extends StatelessWidget {
  const _FormFloatingButton({
    required this.selected,
    required this.onPressed,
  });

  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color foreground =
        selected ? AppColors.purple : AppColors.textPrimary;
    final Color background =
        selected ? AppColors.purple.withValues(alpha: 0.18) : const Color(0xFFE8EAED);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: background,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              child: Icon(
                selected ? Icons.edit_note : Icons.edit_note_outlined,
                color: foreground,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Form',
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: foreground,
          ),
        ),
      ],
    );
  }
}
