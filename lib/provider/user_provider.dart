import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user_model.dart';
import 'package:instagram_clone/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User userData = await _authMethods.getUserDetails();
    _user = userData;
    notifyListeners();
  }
}
