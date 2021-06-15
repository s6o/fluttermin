import 'package:flutter/material.dart';
import 'package:fluttermin/models/app_model.dart';

/// Translate from String route paths to AppRoutePath and vice versa.
class AppRoutePath {
  static Map<String, List<MapEntry<String, dynamic>>> _paths = {
    '/login': [],
  };

  AppRoutePath._internal();

  factory AppRoutePath(AppModel model, RouteInformation ri) {
    return AppRoutePath._internal();
  }
}
