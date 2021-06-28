import 'package:flutter/material.dart';
import 'package:fluttermin/models/app_model.dart';
import 'package:fluttermin/models/app_path.dart';

/// Translate from String route paths to AppRoutePath and vice versa.
///
/// In the browser the Fluttermin's interal route (URL) is in the fragment.
/// The first path segment is considered as the app's page path that must be
/// followed by zero or more path segement pairs that capture the state.
///
/// For example:
///   * http://localhost:62639/#/login
///   * http://localhost:62639/#/users/id/1
class AppRoute {
  final AppModel model;

  AppRoute._internal(this.model, RouteInformation ri) {
    if (ri.location != null) {
      try {
        Uri uri = Uri.parse(ri.location!);
        if (uri.pathSegments.isNotEmpty) {
          AppPath? ap = model.hasPath(uri.pathSegments[0]);
          if (ap != null) {
            // parse url parameters into map
            model.appPath = ap;
            if (uri.pathSegments.length > 1) {
              String previousKey = '';
              Map<String, String> state =
                  uri.pathSegments.sublist(1).fold({}, (accum, ps) {
                if (previousKey.isEmpty) {
                  accum[ps] = '';
                  previousKey = ps;
                } else {
                  accum[previousKey] = ps;
                  previousKey = '';
                }
                return accum;
              });
              model.appPathState = state;
            }
          }
        } else {
          model.appPath = AppPath.Root;
        }
      } catch (e) {
        print('Incorrect route information: $ri');
      }
    }
  }

  factory AppRoute(AppModel model, RouteInformation ri) {
    return AppRoute._internal(model, ri);
  }

  /// Serialize as [RouteInformation]'s location (URL path section).
  RouteInformation get asRouteInformation {
    return RouteInformation(location: model.appPathString);
  }
}
