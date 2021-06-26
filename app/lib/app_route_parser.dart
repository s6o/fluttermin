import 'package:flutter/material.dart';
import 'package:fluttermin/app_route.dart';
import 'package:fluttermin/models/app_model.dart';

class AppRouteParser extends RouteInformationParser<AppRoute> {
  final AppModel model;

  AppRouteParser(this.model);

  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    print('Parse route info: $routeInformation');
    return AppRoute(model, routeInformation);
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute route) {
    print('Restore route info: ${route.asRouteInformation}');
    return route.asRouteInformation;
  }
}
