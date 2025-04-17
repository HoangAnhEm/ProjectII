import 'package:flutter/material.dart';
import '../widgets/project_card.dart';
import 'package:client/layout/user_layout.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserLayout(
      label: 'HomePage',
      child: ListView(
        padding: EdgeInsets.all(24),
        children: [
          ProjectCard(
            projectName: 'Project 1',
            taskGroups: [
              TaskGroupData(
                status: 'IN PROGRESS',
                tasks: [
                  TaskData(name: 'First Task'),
                ],
              ),
              TaskGroupData(
                status: 'TO DO',
                tasks: [
                  TaskData(name: 'Task 1'),
                  TaskData(name: 'Task 2'),
                  TaskData(name: 'Task 3'),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          ProjectCard(
            projectName: 'Project 2',
            taskGroups: [
              TaskGroupData(
                status: 'IN PROGRESS',
                tasks: [
                  TaskData(name: 'Task 1'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
