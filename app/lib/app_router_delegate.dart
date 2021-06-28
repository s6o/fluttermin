import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttermin/app_route.dart';
import 'package:fluttermin/models/app_model.dart';

class AppRouterDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final GlobalKey<NavigatorState> navigatorKey;
  final AppModel model;

  AppRouterDelegate(AppModel model)
      : navigatorKey = GlobalKey<NavigatorState>(),
        model = model;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: model.pages,
      onPopPage: (Route<dynamic> route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        model.pages.removeLast();
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute route) async {
    print(
        'setNewRoutePath: ${route.model.appPath} | ${route.asRouteInformation.location}');
    return SynchronousFuture<void>(null);
  }
}
