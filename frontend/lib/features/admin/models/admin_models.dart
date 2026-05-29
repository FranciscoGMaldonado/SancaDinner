enum UserRole { admin, kitchen, service }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:   return 'Admin';
      case UserRole.kitchen: return 'Cozinha';
      case UserRole.service: return 'Atendimento';
    }
  }

  String get value {
    switch (this) {
      case UserRole.admin:   return 'ADMIN';
      case UserRole.kitchen: return 'KITCHEN';
      case UserRole.service: return 'SERVICE';
    }
  }

  static UserRole fromString(String s) {
    switch (s.toUpperCase()) {
      case 'ADMIN':   return UserRole.admin;
      case 'KITCHEN': return UserRole.kitchen;
      case 'SERVICE': return UserRole.service;
      default:        return UserRole.service;
    }
  }
}

class AdminProduct {
  final int id;
  final String name;
  final double price;
  final String description;

  const AdminProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory AdminProduct.fromJson(Map<String, dynamic> json) {
    return AdminProduct(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
    );
  }

  String get formattedPrice =>
      'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
}

class AdminUser {
  final int id;
  final String name;
  final String email;
  final UserRole role;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRoleX.fromString(json['role'] as String? ?? 'SERVICE'),
    );
  }
}
