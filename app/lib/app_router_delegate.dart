import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttermin/app_route.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:fluttermin/pages/about_page.dart';
import 'package:fluttermin/pages/app_users_page.dart';
import 'package:fluttermin/pages/login_page.dart';
import 'package:fluttermin/pages/not_found_page.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final List<Page<dynamic>> _history = [];
  final GlobalKey<NavigatorState> navigatorKey;
  final AppModel model;

  AppRouterDelegate(AppModel model)
      : navigatorKey = GlobalKey<NavigatorState>(),
        model = model;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _updateHistory(),
      onPopPage: (Route<dynamic> route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        _history.removeLast();
        notifyListeners();

        return true;
      },
    );
  }

  List<Page<dynamic>> _updateHistory([AppRoute? route]) {
    if (route == null) {
      if (model.isAuthorized) {
        _history.add(MaterialPage(child: AboutPage()));
      } else {
        _history.add(MaterialPage(child: LoginPage()));
      }
      return _history;
    }

    if (route.isNotFound) {
      _history.add(MaterialPage(child: NotFoundPage()));
      return _history;
    }

    if (model.isAuthorized == false) {
      _history.clear();
      _history.add(MaterialPage(child: LoginPage()));
      return _history;
    }

    if (model.isAuthorized) {
      switch (route.path) {
        case AppPath.NotFound:
        case AppPath.Login:
          break;

        case AppPath.Root:
        case AppPath.About:
          _history.clear();
          _history.add(MaterialPage(child: AboutPage()));
          break;

        case AppPath.Users:
          _history.add(MaterialPage(child: AppUsersPage()));
          break;
      }
    }
    return _history;
  }

  @override
  Future<void> setNewRoutePath(AppRoute route) async {
    _updateHistory(route);
    return SynchronousFuture<void>(null);
  }
}
