import 'dart:convert';

import 'package:fluttermin/models/app_error.dart';
import 'package:fluttermin/models/auth.dart';

class AppUser {
  final Jwt jwt;
  final Claims claims;

  AppUser(this.jwt, this.claims);

  static Future<AppUser> fromJson(String json) async {
    Map<String, dynamic> m = jsonDecode(json);
    Jwt jwt = Jwt(m['token']);
    Claims c = Claims.fromMap(m['claims']);
    if (c.isExpired) {
      return Future.error(AppError(c));
    } else {
      return Future.value(AppUser(jwt, c));
    }
  }

  bool get isAdmin => claims.role.toLowerCase() == 'admin';

  bool get isAuthorized => jwt.token.isNotEmpty && claims.isExpired == false;

  String toJson() {
    return jsonEncode({
      'claims': claims.toMap(),
      'token': jwt.token,
    });
  }
}
