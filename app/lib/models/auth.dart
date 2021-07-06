import 'dart:convert';

class Credentials {
  String email;
  String pass;

  Credentials()
      : email = '',
        pass = '';

  String toJson() {
    return jsonEncode({
      'email': email,
      'pass': pass,
    });
  }
}

class Claims {
  final int id;
  final String email;
  final String role;
  final DateTime expiration;

  Claims._internal({
    this.id = 0,
    this.email = '',
    this.role = '',
    int exp = 0,
  }) : expiration = DateTime.fromMillisecondsSinceEpoch(exp * 1000);

  factory Claims.fromMap(Map<String, dynamic> m) {
    return Claims._internal(
      id: m['user_id'],
      email: m['email'],
      role: m['app_role'],
      exp: m['exp'],
    );
  }

  bool get isExpired => expiration.compareTo(DateTime.now()) < 0;

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'email': email,
      'app_role': role,
      'exp': expiration.millisecondsSinceEpoch / 1000
    };
  }

  @override
  String toString() {
    return 'Claims: $id | $email | $role | expired = $isExpired';
  }
}

class Jwt {
  final String token;

  Jwt([this.token = '']);

  factory Jwt.fromJson(String json) {
    try {
      Map<String, dynamic> m = jsonDecode(json);
      if (m.containsKey('token') && (m['token'] as String).length > 0) {
        return Jwt(m['token']);
      } else {
        return Jwt();
      }
    } catch (e) {
      print('Failed to decode Jwt | ${e.toString()}');
      return Jwt();
    }
  }

  String toJson() {
    return jsonEncode({'token': token});
  }

  @override
  String toString() {
    return 'JWT token: $token';
  }
}
