class Task {
  final int taskId;
  final int projectId;
  final int? parentTaskId;
  final String name;
  final String? description;
  final String status; // 'to_do', 'in_progress', 'in_review', 'done'
  final String priority; // 'low', 'medium', 'high', 'urgent'
  final DateTime? dueDate;
  final double? estimatedHours;
  final double actualHours;
  final int? assigneeId;
  final int? createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.taskId,
    required this.projectId,
    this.parentTaskId,
    required this.name,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    this.estimatedHours,
    required this.actualHours,
    this.assigneeId,
    this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    taskId: json['task_id'],
    projectId: json['project_id'],
    parentTaskId: json['parent_task_id'],
    name: json['name'],
    description: json['description'],
    status: json['status'],
    priority: json['priority'],
    dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    estimatedHours: json['estimated_hours'] != null ? (json['estimated_hours'] as num).toDouble() : null,
    actualHours: (json['actual_hours'] as num).toDouble(),
    assigneeId: json['assignee_id'],
    createdBy: json['created_by'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
  );

  Map<String, dynamic> toJson() => {
    'task_id': taskId,
    'project_id': projectId,
    'parent_task_id': parentTaskId,
    'name': name,
    'description': description,
    'status': status,
    'priority': priority,
    'due_date': dueDate?.toIso8601String(),
    'estimated_hours': estimatedHours,
    'actual_hours': actualHours,
    'assignee_id': assigneeId,
    'created_by': createdBy,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };
}
