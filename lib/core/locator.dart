import 'package:test_flutter/core/repository/databasehelper.dart';

import '../core/services/navigator_service.dart';
import 'package:get_it/get_it.dart';

GetIt get app => GetIt.instance;

void initializeGetIt() {
  app.registerLazySingleton(
    () => NavigatorService(),
  );
  app.registerLazySingleton(
    () => DatabaseHelper(),
  );
}
