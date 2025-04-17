import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String projectName;
  final List<TaskGroupData> taskGroups;

  const ProjectCard({required this.projectName, required this.taskGroups, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project title & menu
            Row(
              children: [
                Text(
                  projectName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
              ],
            ),
            Divider(),
            // Task groups
            ...taskGroups.map((group) => TaskGroupWidget(group: group)).toList(),
          ],
        ),
      ),
    );
  }
}

class TaskGroupData {
  final String status;
  final List<TaskData> tasks;
  TaskGroupData({required this.status, required this.tasks});
}

class TaskData {
  final String name;
  TaskData({required this.name});
}

class TaskGroupWidget extends StatelessWidget {
  final TaskGroupData group;
  const TaskGroupWidget({required this.group});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: group.status == 'IN PROGRESS' ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                group.status,
                style: TextStyle(
                  color: group.status == 'IN PROGRESS' ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            TextButton.icon(
              icon: Icon(Icons.add, size: 18),
              label: Text('Add Task'),
              onPressed: () {},
            ),
          ],
        ),
        // Task list
        Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Column(
            children: group.tasks
                .map((task) => TaskItemWidget(task: task))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class TaskItemWidget extends StatelessWidget {
  final TaskData task;
  const TaskItemWidget({required this.task});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0),
      leading: Icon(Icons.radio_button_unchecked, color: Colors.blue),
      title: Text(task.name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline, size: 18, color: Colors.grey),
          SizedBox(width: 12),
          Icon(Icons.calendar_today, size: 18, color: Colors.grey),
          SizedBox(width: 12),
          Icon(Icons.flag_outlined, size: 18, color: Colors.grey),
          SizedBox(width: 12),
          Icon(Icons.more_horiz, size: 18, color: Colors.grey),
        ],
      ),
    );
  }
}
