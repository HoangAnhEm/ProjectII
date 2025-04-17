class Workspace {
  final int workspaceId;
  final String name;
  final String? description;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  Workspace({
    required this.workspaceId,
    required this.name,
    this.description,
    required this.isPublic,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      workspaceId: json['workspace_id'],
      name: json['name'],
      description: json['description'],
      isPublic: json['is_public'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workspace_id': workspaceId,
      'name': name,
      'description': description,
      'is_public': isPublic,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class WorkspaceUser {
  final int workspaceUserId;
  final int workspaceId;
  final int userId;
  final String roleInWorkspace; // 'owner', 'admin', 'member', 'guest'
  final DateTime joinedAt;

  WorkspaceUser({
    required this.workspaceUserId,
    required this.workspaceId,
    required this.userId,
    required this.roleInWorkspace,
    required this.joinedAt,
  });

  factory WorkspaceUser.fromJson(Map<String, dynamic> json) {
    return WorkspaceUser(
      workspaceUserId: json['workspace_user_id'],
      workspaceId: json['workspace_id'],
      userId: json['user_id'],
      roleInWorkspace: json['role_in_workspace'],
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }
}
