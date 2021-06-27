import 'package:flutter/material.dart';
import 'package:fluttermin/app_route.dart';

class AppRouteParser extends RouteInformationParser<AppRoute> {
  AppRouteParser();

  @override
  Future<AppRoute> parseRouteInformation(
      RouteInformation routeInformation) async {
    print('Parse route info: ${routeInformation.location}');
    return AppRoute(routeInformation);
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute route) {
    print('Restore route info: ${route.asRouteInformation.location}');
    return route.asRouteInformation;
  }
}
