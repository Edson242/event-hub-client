import 'dart:convert';

class User {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? passwordHash; // Make nullable

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.passwordHash,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      passwordHash: json['passwordHash'], // Will be null if not present
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'passwordHash': passwordHash,
    };
  }

  String toJson() => json.encode(toMap());

  factory User.fromJsonString(String source) => User.fromJson(json.decode(source));
}