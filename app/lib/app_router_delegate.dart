import 'package:flutter/material.dart';
import 'package:fluttermin/app_route.dart';
import 'package:fluttermin/pages/app_users_page.dart';
import 'package:fluttermin/pages/login_page.dart';
import 'package:fluttermin/pages/not_found_page.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final GlobalKey<NavigatorState> navigatorKey;
  final List<Page<dynamic>> _history = [];

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: _history,
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

  @override
  Future<void> setNewRoutePath(AppRoute route) async {
    if (route.isNotFound) {
      _history.add(MaterialPage(child: NotFoundPage()));
      return;
    }

    if (route.appModel.isAuthorized == false) {
      _history.clear();
      _history.add(MaterialPage(child: LoginPage()));
      return;
    }

    if (route.appModel.isAuthorized) {
      switch (route.path) {
        case AppPath.NotFound:
        case AppPath.Login:
          return;

        case AppPath.Root:
        case AppPath.Users:
          _history.add(MaterialPage(child: AppUsersPage()));
          return;
      }
    }
  }
}
