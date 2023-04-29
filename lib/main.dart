import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ikinci_el/app.dart';
import 'package:ikinci_el/core/cache/cache_manager.dart';
import 'package:ikinci_el/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await CacheManager().init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => AuthProvider(),
      )
    ],
    child: const MyApp(),
  ));
}
