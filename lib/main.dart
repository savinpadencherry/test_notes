import 'package:provider/provider.dart';
import 'package:test_flutter/core/repository/databasehelper.dart';
import 'package:test_flutter/core/repository/test_repo.dart';

import 'core/locator.dart';
import 'core/services/navigator_service.dart';
import 'package:flutter/material.dart';
import 'views/home/home_view.dart';

void main() async {
  initializeGetIt();
  runApp(
    const MainApplication(),
  );
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseHelper(),
        ),
        ChangeNotifierProvider(
          create: (_) => TestRepository(
            dbHelper: app(),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: app<NavigatorService>().navigatorKey,
        debugShowCheckedModeBanner: false,
        home: const HomeView(),
      ),
    );
  }
}
