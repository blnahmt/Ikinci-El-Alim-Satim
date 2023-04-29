import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ikinci_el/core/auth/auth_manager.dart';
import 'package:ikinci_el/core/database/firestore.dart';
import 'package:ikinci_el/core/models/user_detail.dart';

class AuthProvider extends ChangeNotifier {
  UserDetail? _userDetail;
  User? _user;

  UserDetail? get userDetail => _userDetail;
  User? get user => _user;

  AuthProvider() {
    init();
  }

  void init() {
    AuthManager().auth.userChanges().listen((event) {
      updateUser();
    });
  }

  Future<void> updateUser() async {
    _user = AuthManager().auth.currentUser;
    if (_user != null) {
      _userDetail = await FirestoreManager().getUserDetail(_user!.uid);
    }
    notifyListeners();
  }

  Future<void> reloadUser() async {
    _user?.reload();
    notifyListeners();
  }
}
