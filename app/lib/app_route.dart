import 'package:flutter/material.dart';
import 'package:fluttermin/models/app_model.dart';

/// Application path constants serialized as app's URL fragment.
enum AppPath {
  NotFound,
  Root,
  Login,
  Users,
}

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
  /// List of configured app's paths and respective initial states.
  static final Map<String, MapEntry<AppPath, Map<String, String>>> _paths = {
    '404': MapEntry(AppPath.NotFound, {}),
    '/': MapEntry(AppPath.Root, {}),
    'login': MapEntry(AppPath.Login, {}),
    'users': MapEntry(AppPath.Users, {})
  };
  String _path = '404';
  AppModel _model;

  AppRoute._internal(AppModel model, RouteInformation ri) : _model = model {
    if (ri.location != null) {
      try {
        Uri uri = Uri.parse(ri.location!);
        if (uri.pathSegments.isNotEmpty) {
          if (_paths.containsKey(uri.pathSegments[0])) {
            // parse url parameters into map
            _path = uri.pathSegments[0];
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
              _paths[_path] = MapEntry(_paths[_path]!.key, state);
            }
          }
        } else {
          _path = '/';
        }
      } catch (e) {
        print('Incorrect route information: $ri');
      }
    }
  }

  factory AppRoute(AppModel model, RouteInformation ri) {
    return AppRoute._internal(model, ri);
  }

  /// Access to app's data model
  AppModel get appModel {
    return _model;
  }

  /// Serialize as [RouteInformation]'s location (URL path section).
  RouteInformation get asRouteInformation {
    List<String> pairs =
        _paths[_path]!.value.entries.map((e) => '${e.key}/${e.value}').toList();
    return RouteInformation(
        location: '$_path${pairs.isEmpty ? '' : '/' + pairs.join('/')}');
  }

  /// The current [AppPath].
  AppPath get path {
    return _paths[_path]!.key;
  }

  /// True when during initialization [RouteInformation] could not correctly
  /// find a valid [AppRoute] to instanciate.
  bool get isNotFound {
    return _path == '404';
  }

  /// True if the root path was initialized
  bool get isRoot {
    return _path == '/';
  }

  /// State of current location.
  Map<String, String> get state {
    return _paths[_path]!.value;
  }
}
