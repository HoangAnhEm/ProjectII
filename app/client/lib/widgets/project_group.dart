import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';

class ProjectGroupWidget extends StatefulWidget {
  final Project project;
  final bool isExpanded;
  final Function(Task) onTaskTap;
  final Function(int, String) onAddTask;

  const ProjectGroupWidget({
    Key? key,
    required this.project,
    this.isExpanded = true,
    required this.onTaskTap,
    required this.onAddTask,
  }) : super(key: key);

  @override
  _ProjectGroupWidgetState createState() => _ProjectGroupWidgetState();
}

class _ProjectGroupWidgetState extends State<ProjectGroupWidget> {
  late bool _isExpanded;
  late Map<String, bool> _expandedStatus;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
    _expandedStatus = {};
    for (var group in widget.project.taskGroups) {
      _expandedStatus[group.status] = group.isExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Header
          _buildProjectHeader(),

          // Task Groups
          if (_isExpanded)
            ...widget.project.taskGroups.map((group) => _buildTaskGroup(group)).toList(),

          // New Status Button
          if (_isExpanded)
            _buildNewStatusButton(),
        ],
      ),
    );
  }

  // Widget tiêu đề project
  Widget _buildProjectHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: _isExpanded ? Colors.grey.shade300 : Colors.transparent,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Icon(
              _isExpanded ? Icons.expand_more : Icons.chevron_right,
              size: 20,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 8),
          Text(
            widget.project.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.more_horiz, size: 20, color: Colors.grey.shade700),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.content_copy_outlined,
              size: 20,
              color: Colors.grey.shade700,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Widget nhóm task theo status
  Widget _buildTaskGroup(TaskGroup group) {
    bool isExpanded = _expandedStatus[group.status] ?? true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Task Group Header
        InkWell(
          onTap: () {
            setState(() {
              _expandedStatus[group.status] = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  size: 18,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(group.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getStatusIcon(group.status),
                        size: 14,
                        color: group.status.toLowerCase() == "in_progress" ? Colors.white : Colors.grey.shade700,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _formatStatus(group.status),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: group.status.toLowerCase() == "in_progress" ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  group.count.toString(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.more_horiz, size: 16, color: Colors.grey.shade600),
                SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    widget.onAddTask(widget.project.projectId, group.status);
                  },
                  icon: Icon(Icons.add, size: 16),
                  label: Text("Add Task"),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    foregroundColor: Colors.grey.shade700,
                    minimumSize: Size(0, 0),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tasks
        if (isExpanded)
          ...group.tasks.map((task) => TaskItemWidget(
            task: task,
            onTap: () => widget.onTaskTap(task),
          )).toList(),

        // Add Task Button for this group
        if (isExpanded)
          Padding(
            padding: EdgeInsets.only(left: 48, bottom: 8),
            child: TextButton.icon(
              onPressed: () {
                widget.onAddTask(widget.project.projectId, group.status);
              },
              icon: Icon(Icons.add, size: 16),
              label: Text("Add Task"),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                foregroundColor: Colors.grey.shade600,
              ),
            ),
          ),
      ],
    );
  }

  // Widget nút thêm status mới
  Widget _buildNewStatusButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.add, size: 16),
        label: Text("New status"),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          foregroundColor: Colors.grey.shade700,
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return Colors.blue;
      case 'to_do':
        return Colors.grey.shade300;
      case 'in_review':
        return Colors.amber;
      case 'done':
        return Colors.green;
      default:
        return Colors.grey.shade300;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'in_progress':
        return Icons.play_circle_outline;
      case 'to_do':
        return Icons.circle_outlined;
      case 'in_review':
        return Icons.visibility_outlined;
      case 'done':
        return Icons.check_circle_outline;
      default:
        return Icons.circle_outlined;
    }
  }

  String _formatStatus(String status) {
    // Convert to_do to TO DO
    return status.toUpperCase().replaceAll('_', ' ');
  }
}

// Widget hiển thị từng task
class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItemWidget({
    Key? key,
    required this.task,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 36),
            _buildTaskCheckbox(),
            SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Text(
                task.name,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: _buildAssignee(),
            ),
            Expanded(
              flex: 1,
              child: _buildDueDate(),
            ),
            Expanded(
              flex: 1,
              child: _buildPriority(),
            ),
            IconButton(
              icon: Icon(Icons.more_horiz, size: 18, color: Colors.grey.shade600),
              onPressed: () {},
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCheckbox() {
    final isCompleted = task.status.toLowerCase() == 'done';
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: Center(
        child: isCompleted
            ? Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        )
            : SizedBox(),
      ),
    );
  }

  Widget _buildAssignee() {
    return Container(
      child: task.assigneeId != null
          ? CircleAvatar(
        radius: 14,
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.person_outline, size: 16, color: Colors.grey.shade700),
      )
          : Icon(Icons.person_add_alt_outlined, size: 18, color: Colors.grey.shade500),
    );
  }

  Widget _buildDueDate() {
    return Container(
      child: task.dueDate != null
          ? Row(
        children: [
          Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
          SizedBox(width: 4),
          Text(
            task.dueDate!.day == DateTime.now().day &&
                task.dueDate!.month == DateTime.now().month &&
                task.dueDate!.year == DateTime.now().year
                ? "Today"
                : "not Today",
                // : DateFormat("MMM d").format(task.dueDate!),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      )
          : Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade400),
    );
  }

  Widget _buildPriority() {
    IconData priorityIcon;
    Color priorityColor;

    switch (task.priority.toLowerCase()) {
      case 'urgent':
        priorityIcon = Icons.flag;
        priorityColor = Colors.red;
        break;
      case 'high':
        priorityIcon = Icons.flag;
        priorityColor = Colors.orange;
        break;
      case 'medium':
        priorityIcon = Icons.flag_outlined;
        priorityColor = Colors.grey.shade600;
        break;
      case 'low':
        priorityIcon = Icons.flag_outlined;
        priorityColor = Colors.grey.shade400;
        break;
      default:
        priorityIcon = Icons.flag_outlined;
        priorityColor = Colors.grey.shade600;
    }

    return Icon(priorityIcon, size: 18, color: priorityColor);
  }
}
