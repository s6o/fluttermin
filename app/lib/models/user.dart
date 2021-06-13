import 'package:fluttermin/models/auth.dart';

class User {
  final Jwt jwt;
  final Claims claims;

  User(this.jwt, this.claims);

  bool get isAdmin => claims.role.toLowerCase() == 'admin';

  bool get isAuthorized => jwt.token.isNotEmpty && claims.isExpired == false;
}
