import 'package:flutter/material.dart';
import 'package:fluttermin/models/app_error.dart';
import 'package:fluttermin/models/auth.dart';
import 'package:fluttermin/models/user.dart';

class AppModel extends ChangeNotifier {
  AppError _appError;
  Credentials _credentials;
  User? _user;

  AppModel()
      : _appError = AppError.empty(),
        _credentials = Credentials(),
        _user = null;

  AppError get appError {
    return _appError;
  }

  void setAppError(String message) {
    _appError = AppError(message);
    notifyListeners();
  }

  Credentials get credentials {
    return _credentials;
  }

  User? get user {
    return _user;
  }

  set user(User? u) {
    _user = u;
    _credentials = Credentials();
    notifyListeners();
  }

  bool get isAuthorized => _user != null && _user!.isAuthorized;

  void unAuthorize() {
    _user = null;
    notifyListeners();
  }
}
