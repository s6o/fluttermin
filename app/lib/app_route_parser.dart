import 'package:flutter/material.dart';
import 'package:fluttermin/app_route_path.dart';
import 'package:fluttermin/models/app_model.dart';

class AppRouteParser extends RouteInformationParser<AppRoutePath> {
  final AppModel model;

  AppRouteParser(this.model);

  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    return AppRoutePath(model, routeInformation);
//    Uri uri = Uri.parse(routeInformation!.location);
//    // Handle '/'
//    if (uri.pathSegments.length == 0) {
//      return BookRoutePath.home();
//    }
//
//    // Handle '/book/:id'
//    if (uri.pathSegments.length == 2) {
//      if (uri.pathSegments[0] != 'book') return BookRoutePath.unknown();
//      var remaining = uri.pathSegments[1];
//      var id = int.tryParse(remaining);
//      if (id == null) return BookRoutePath.unknown();
//      return BookRoutePath.details(id);
//    }
//
//    // Handle unknown routes
//    return BookRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
//    if (path.isUnknown) {
//      return RouteInformation(location: '/404');
//    }
//    if (path.isHomePage) {
//      return RouteInformation(location: '/');
//    }
//    if (path.isDetailsPage) {
//      return RouteInformation(location: '/book/${path.id}');
//    }
    return RouteInformation();
  }
}
