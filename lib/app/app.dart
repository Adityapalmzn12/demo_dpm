import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';

import '../injection.dart';
import 'redux/app_state.dart';
import 'router.dart';
import 'theme.dart';

class SchemaFormApp extends StatelessWidget {
  const SchemaFormApp({
    super.key,
    required this.store,
    required this.deps,
  });

  final Store<AppState> store;
  final AppDependencies deps;

  @override
  Widget build(BuildContext context) {
    final GoRouter router = createRouter(deps);

    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp.router(
        title: 'Schema Forms',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: router,
      ),
    );
  }
}
