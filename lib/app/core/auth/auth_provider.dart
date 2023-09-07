import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provider/app/core/navigator/todo_list_navigator.dart';
import 'package:todo_list_provider/app/services/user/user_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _fiberaseAuth;
  final UserService _userService;

  AuthProvider(
      {required FirebaseAuth firebaseAuth, required UserService userService})
      : _fiberaseAuth = firebaseAuth,
        _userService = userService;

  Future<void> logout() => _userService.logout();

  User? get user => _fiberaseAuth.currentUser;

  void loadListener() {
    _fiberaseAuth.userChanges().listen((_) => notifyListeners());
    _fiberaseAuth.idTokenChanges().listen((user) {
      if (user != null) {
        TodoListNavigator.to
            .pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        TodoListNavigator.to
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }
}
