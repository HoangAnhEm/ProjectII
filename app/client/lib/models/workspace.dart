import 'package:client/models/user.dart';

class Workspace {
  final String id;
  final String name;
  final String? description;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<User> members; // Thêm trường này

  Workspace({
    required this.id,
    required this.name,
    this.description,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
    required this.members, // Thêm vào constructor
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isPublic: json['is_public'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      members: json['members'] != null
          ? (json['members'] as List)
          .map((m) => User.fromJson(m))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'members': members.map((m) => m.toJson()).toList(),
    };
  }
}

