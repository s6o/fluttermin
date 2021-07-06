import 'package:flutter/material.dart';
import 'package:fluttermin/models/auth.dart';
import 'package:fluttermin/models/user.dart';

/// Main application model that composes various submodels.
class AppModel extends ChangeNotifier {
  Credentials _credentials;
  User? _user;

  AppModel() : _credentials = Credentials();

  Credentials get credentials {
    return _credentials;
  }

  /// Default path to which to redirect after successful login.
  String get defaultPath => '/about';

  bool get isAuthorized => _user != null && _user!.isAuthorized;

  User? get user {
    return _user;
  }

  set user(User? u) {
    _user = u;
    _credentials = Credentials();
    notifyListeners();
  }

  void unAuthorize() {
    _user = null;
    notifyListeners();
  }
}
