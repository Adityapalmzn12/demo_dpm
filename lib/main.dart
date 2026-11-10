import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'app/redux/store.dart';
import 'features/submissions/presentation/redux/submissions_thunks.dart';
import 'injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final deps = await AppDependencies.create();
  final store = createAppStore();
  store.dispatch(loadSubmissionsThunk(deps));

  runApp(SchemaFormApp(store: store, deps: deps));
}
