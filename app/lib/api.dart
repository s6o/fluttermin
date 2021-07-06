import 'dart:convert';

import 'package:fluttermin/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:fluttermin/models/auth.dart';
import 'package:fluttermin/models/app_error.dart';

class Api {
  static bool _isApp = false;
  static Uri _baseUrlApp = Uri(scheme: 'https', host: '332243c48c25.ngrok.io');
  static Uri _baseUrlWeb = Uri(scheme: 'http', host: 'localhost', port: 3000);
  static Uri _baseUrl = _isApp ? _baseUrlApp : _baseUrlWeb;

  static Future<Jwt> login(Credentials credentials) async {
    try {
      http.Response r = await http.post(
        _baseUrl.replace(path: 'rpc/fluttermin_login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/vnd.pgrst.object+json'
        },
        body: credentials.toJson(),
      );
      return r.statusCode == 200
          ? Future.value(Jwt.fromJson(r.body))
          : Future.error(AppError(r));
    } catch (e) {
      return Future.error(AppError(e));
    }
  }

  /// Decrypt and decode JWT claims.
  /// A valid server response looks like:
  /// ```json
  ///{
  ///  "header": {
  ///    "alg": "HS256",
  ///    "typ": "JWT"
  ///  },
  ///  "payload": {
  ///    "role": "fluttermin_user",
  ///    "app_role": "admin",
  ///    "email": "john.doe@lost.net",
  ///    "user_id": 1,
  ///    "exp": 1623585505
  ///  },
  ///  "valid": true
  ///}
  /// ```
  /// The [Claims] is instanciated only if JSON's valid member is true.
  static Future<Claims> claims(Jwt jwt) async {
    try {
      http.Response r = await http.post(
        _baseUrl.replace(path: 'rpc/fluttermin_claims'),
        headers: {
          'Authorization': 'Bearer ${jwt.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/vnd.pgrst.object+json'
        },
        body: jwt.toJson(),
      );
      if (r.statusCode == 200) {
        Map<String, dynamic> m = jsonDecode(r.body);
        if (m.containsKey('valid') &&
            m['valid'] == true &&
            m.containsKey('payload')) {
          return Future.value(Claims.fromMap(m['payload']));
        } else {
          return Future.error(AppError(m));
        }
      } else {
        return Future.error(AppError(r));
      }
    } catch (e) {
      return Future.error(AppError(e));
    }
  }

  static Future<List<User>> users(Jwt jwt) async {
    try {
      http.Response r = await http.get(
        _baseUrl.replace(path: 'fluttermin_users'),
        headers: {
          'Authorization': 'Bearer ${jwt.token}',
          'Content-Type': 'application/json',
        },
      );
      if (r.statusCode == 200) {
        List<dynamic> data = jsonDecode(r.body);
        return data.map((m) => User.fromMap(m)).toList();
      } else {
        return Future.error(AppError(r));
      }
    } catch (e) {
      return Future.error(AppError(e));
    }
  }
}
