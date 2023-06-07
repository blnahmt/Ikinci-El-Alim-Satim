import 'package:flutter/material.dart';
import 'package:ikinci_el/core/theme/theme.dart';
import 'core/navigation/navigation_service.dart';
import 'core/navigation/routes.dart';
import 'core/navigation/screen_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'İkinci El',
      theme: AppTheme().theme,
      navigatorKey: NavigationService().navigatorKey,
      initialRoute: Routes.initial,
      onGenerateRoute: ScreenRouter.generateRoute,
    );
  }
}
