import 'package:flutter/material.dart';

class TaskToolbar extends StatelessWidget {
  final VoidCallback onAddTask;
  final VoidCallback onAddProject;

  const TaskToolbar({
    Key? key,
    required this.onAddTask,
    required this.onAddProject,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildToolButton(Icons.view_list_outlined, "Group: Status"),
          _buildToolButton(Icons.subtitles_outlined, "Subtasks"),
          _buildToolButton(Icons.table_rows_outlined, "Columns"),
          Spacer(),
          _buildToolButton(Icons.filter_list_outlined, "Filter"),
          _buildClosedToggle(),
          _buildAssigneeDropdown(),
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            child: Text("T"),
          ),
          SizedBox(width: 10,),
          ElevatedButton.icon(
            onPressed: onAddProject,
            icon: Icon(Icons.add, size: 18),
            label: Text("Add Project"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          SizedBox(width: 10,),
          ElevatedButton.icon(
            onPressed: onAddTask,
            icon: Icon(Icons.add, size: 18),
            label: Text("Add Task"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton.icon(
        onPressed: () {},
        icon: Icon(
          icon,
          size: 20,
          color: Colors.grey.shade800,
        ),
        label: Text(
          label,
          style: TextStyle(color: Colors.grey.shade800),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }

  Widget _buildClosedToggle() {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
        ),
        Text("Closed", style: TextStyle(color: Colors.grey.shade800)),
        SizedBox(width: 12),
      ],
    );
  }

  Widget _buildAssigneeDropdown() {
    return Row(
      children: [
        Text("Assignee:", style: TextStyle(color: Colors.grey.shade800)),
        SizedBox(width: 4),
        IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {},
        ),
        SizedBox(width: 8),
      ],
    );
  }
}
