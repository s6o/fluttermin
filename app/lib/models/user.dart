class User {
  final int id;
  final String role;
  final String email;
  final String firstName;
  final String lastName;

  User._internal(
      {this.id = 0,
      this.email = '',
      this.role = '',
      this.firstName = '',
      this.lastName = ''});

  factory User.fromMap(Map<String, dynamic> m) {
    return User._internal(
        id: m['user_id'],
        role: m['app_role'],
        email: m['email'],
        firstName: m['first_name'],
        lastName: m['last_name']);
  }
}
