import 'package:flutter/material.dart';
import 'package:fluttermin/models/auth.dart';
import 'package:fluttermin/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Main application model that composes various submodels.
class AppModel extends ChangeNotifier {
  Credentials _credentials;
  AppUser? _user;

  AppModel() : _credentials = Credentials() {
    _deserializeUser();
  }

  Credentials get credentials {
    return _credentials;
  }

  /// Default path to which to redirect after successful login.
  String get defaultPath => '/about';

  bool get isAuthorized => _user != null && _user!.isAuthorized;

  AppUser? get user {
    return _user;
  }

  set user(AppUser? u) {
    _user = u;
    _credentials = Credentials();
    _serializeUser();
    notifyListeners();
  }

  void unAuthorize() {
    user = null;
  }

  void _deserializeUser() async {
    try {
      var sp = await SharedPreferences.getInstance();
      var json = sp.getString('user');
      if (json != null) {
        _user = await AppUser.fromJson(json);
      }
    } catch (e) {
      print(e);
    }
  }

  void _serializeUser() async {
    try {
      var sp = await SharedPreferences.getInstance();
      if (_user != null) {
        sp.setString('user', _user!.toJson());
      } else {
        sp.remove('user');
      }
    } catch (e) {
      print(e);
    }
  }
}
