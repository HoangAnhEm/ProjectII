
import 'package:client/models/task.dart';

class Project {
  final int projectId;
  final int workspaceId;
  final String name;
  final String? description;
  final String status; // 'planning', 'active', 'on_hold', 'completed', 'archived'
  final DateTime? startDate;
  final DateTime? endDate;
  final int? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TaskGroup> taskGroups; // Nhóm task theo status để hiển thị UI

    Project({
    required this.projectId,
    required this.workspaceId,
    required this.name,
    this.description,
    required this.status,
    this.startDate,
    this.endDate,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.taskGroups,
  });

  Map<String, dynamic> toJson() => {
    'project_id': projectId,
    'workspace_id': workspaceId,
    'name': name,
    'description': description,
    'status': status,
    'start_date': startDate?.toIso8601String(),
    'end_date': endDate?.toIso8601String(),
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Project.fromJson(Map<String, dynamic> json, {List<Task>? tasks}) {
    final project = Project(
      projectId: json['project_id'],
      workspaceId: json['workspace_id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      taskGroups: [],
    );

    // Nhóm task theo status nếu có
    if (tasks != null) {
      final Map<String, List<Task>> groupedTasks = {};

      for (var task in tasks.where((t) => t.projectId == project.projectId)) {
        if (!groupedTasks.containsKey(task.status)) {
          groupedTasks[task.status] = [];
        }
        groupedTasks[task.status]!.add(task);
      }

      project.taskGroups.addAll(
        groupedTasks.entries.map((entry) => TaskGroup(
          status: entry.key,
          tasks: entry.value,
        )).toList(),
      );
    }

    return project;
  }
}

// Class hỗ trợ cho UI, không có trong DB schema
class TaskGroup {
  final String status;
  final List<Task> tasks;
  bool isExpanded;

  TaskGroup({
    required this.status,
    required this.tasks,
    this.isExpanded = true,
  });

  int get count => tasks.length;
}
