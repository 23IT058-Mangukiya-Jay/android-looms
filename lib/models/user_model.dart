class User {
  final String id;
  final String name;
  final String email;
  final String role; // owner, manager
  final DateTime? lastLogin;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.lastLogin,
    required this.createdAt,
  });
}
