import 'package:flutter/material.dart';
import 'package:fluttermin/models/app_error.dart';
import 'package:fluttermin/models/app_path.dart';
import 'package:fluttermin/models/auth.dart';
import 'package:fluttermin/models/user.dart';
import 'package:fluttermin/pages/about_page.dart';
import 'package:fluttermin/pages/app_users_page.dart';
import 'package:fluttermin/pages/login_page.dart';
import 'package:fluttermin/pages/not_found_page.dart';

/// Main application model that composes various submodels.
class AppModel extends ChangeNotifier {
  AppError _appError;
  Credentials _credentials;
  static User? _user;

  // List of configured app's paths and respective initial states.
  static final Map<String, MapEntry<AppPath, Map<String, String>>> _paths = {
    '404': MapEntry(AppPath.NotFound, {}),
    '/': MapEntry(AppPath.Root, {}),
    'login': MapEntry(AppPath.Login, {}),
    'about': MapEntry(AppPath.About, {}),
    'users': MapEntry(AppPath.Users, {})
  };

  // Application path and page loader mappings.
  static final Map<AppPath, Function> _pathPages = {
    AppPath.NotFound: () => _mp(NotFoundPage()),
    AppPath.Root: () => isAuthorized ? _mp(AboutPage()) : _mp(LoginPage()),
    AppPath.About: () => _mp(AboutPage()),
    AppPath.Login: () => _mp(LoginPage()),
    AppPath.Users: () => _mp(AppUsersPage()),
  };

  static Page<dynamic> _mp(Widget w) {
    return MaterialPage(child: w, name: _path);
  }

  // Stack of application current application pages.
  final List<Page<dynamic>> _pages;

  // Current page path.
  static String _path = '404';

  AppModel()
      : _appError = AppError.empty(),
        _credentials = Credentials(),
        _pages = [];

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

  static bool get isAuthorized => _user != null && _user!.isAuthorized;

  void unAuthorize() {
    _user = null;
    notifyListeners();
  }

  /// Active application path specifing which page to load i.e. is top of the page stack.
  AppPath get appPath {
    return _paths[_path]!.key;
  }

  /// Serialized active application path with state as [String].
  String get appPathString {
    List<String> pairs =
        _paths[_path]!.value.entries.map((e) => '${e.key}/${e.value}').toList();
    return '$_path${pairs.isEmpty ? '' : '/' + pairs.join('/')}';
  }

  /// Set new active application path without routing i.e. loading respective page.
  set appPath(AppPath ap) {
    _path = _paths.entries
        .firstWhere(
          (MapEntry<String, MapEntry<AppPath, Map<String, String>>> me) =>
              me.value.key == ap,
          orElse: () => MapEntry('/', MapEntry(AppPath.Root, {})),
        )
        .key;
  }

  /// State of active application path.
  Map<String, String> get appPathState {
    return _paths[_path]!.value;
  }

  set appPathState(Map<String, String> aps) {
    _paths[_path] = MapEntry(_paths[_path]!.key, aps);
  }

  /// Find respective application path via an URI path segment.
  AppPath? hasPath(String path) {
    return _paths.containsKey(path) ? _paths[path]!.key : null;
  }

  /// Current application page stack for [Navigator].
  List<Page<dynamic>> get pages {
    if (appPath == AppPath.Root) {
      _pages.clear();
      _pages.add(Function.apply(_pathPages[appPath]!, []));
      return _pages;
    }

    if (_pages.last.name != _path) {
      _pages.add(Function.apply(_pathPages[appPath]!, []));
    }
    return _pages;
  }
}
