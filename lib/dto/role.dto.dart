enum RoleType { admin, user, staff, organizer }

extension RoleTypeExtension on RoleType {
  String get value {
    switch (this) {
      case RoleType.admin:
        return 'ADMIN';
      case RoleType.user:
        return 'USER';
      case RoleType.organizer:
        return 'ORGANIZER';
      case RoleType.staff:
        return 'STAFF';
    }
  }

  static RoleType fromValue(String value) {
    switch (value.toUpperCase()) {
      case 'ADMIN':
        return RoleType.admin;
      case 'USER':
        return RoleType.user;
      case 'ORGANIZER':
        return RoleType.organizer;
      case 'STAFF':
        return RoleType.staff;
      default:
        throw ArgumentError('Unknown role value: $value');
    }
  }
}

class RoleDTO {
  final RoleType role;

  const RoleDTO({required this.role});

  factory RoleDTO.fromJson(Map<String, dynamic> json) {
    final roleValue = json['role'] as String?;
    if (roleValue == null) {
      throw ArgumentError('role is required in JSON');
    }
    return RoleDTO(role: RoleTypeExtension.fromValue(roleValue));
  }

  Map<String, dynamic> toJson() => {
        'role': role.value,
      };

  @override
  String toString() => 'RoleDto(role: ${role.value})';
}