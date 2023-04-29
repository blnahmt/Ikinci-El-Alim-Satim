import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _singleton = NavigationService._internal();

  factory NavigationService() {
    return _singleton;
  }

  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> to({required String routeName, Object? args}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: args);
  }

  void back() {
    return navigatorKey.currentState?.pop();
  }

  Future<dynamic> clearAllTo({required String routeName, Object? args}) {
    return navigatorKey.currentState!
        .pushNamedAndRemoveUntil(routeName, (route) => false, arguments: args);
  }
}
