class UserDTO {
  final String name;
  final String email;
  final String passwordHash;
  final String role;

  UserDTO({
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.role,
  });

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      name: json['name'],
      email: json['email'],
      passwordHash: json['passwordHash'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'role': role,
    };
  }
}