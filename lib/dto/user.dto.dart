import 'package:myapp/model/user.dart';

class AuthResponseDTO {
  final String token;
  final UserDTO user;

  AuthResponseDTO({required this.token, required this.user});

  factory AuthResponseDTO.fromJson(Map<String, dynamic> json) {
    return AuthResponseDTO(
      token: json['token'] as String,
      user: UserDTO.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user.toJson()};
  }
}

class UserDTO {
  final int id;
  final String name;
  final String email;
  final String role;

  UserDTO({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  factory UserDTO.fromUser(User user) {
    return UserDTO(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'role': role};
  }
}
