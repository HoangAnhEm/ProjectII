import 'package:client/layout/user_layout.dart';
import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../models/workspace.dart';
import '../widgets/navigation_tabs.dart';
import '../widgets/project_group.dart';
import '../widgets/toolbar.dart';

class MyTask extends StatefulWidget {
  const MyTask({Key? key}) : super(key: key);

  @override
  _ListViewScreenState createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<MyTask> {
  int _selectedTabIndex = 2; // List view is selected by default

  // Dữ liệu mẫu cho workspace hiện tại
  late Workspace _currentWorkspace;
  late User _currentUser;
  late List<Project> _projects;

  @override
  void initState() {
    super.initState();
    _initSampleData();
  }

  // Khởi tạo dữ liệu mẫu cho demo
  void _initSampleData() {
    // Workspace hiện tại
    _currentWorkspace = Workspace(
      workspaceId: 1,
      name: "My Workspace",
      description: "Main workspace for task management",
      isPublic: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // User hiện tại
    _currentUser = User(
      userId: 1,
      username: "john_doe",
      email: "john@example.com",
      fullName: "John Doe",
      role: "admin",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Dữ liệu mẫu cho các task
    final List<Task> tasks = [
      // Tasks cho Project 1
      Task(
        taskId: 1,
        projectId: 1,
        name: "First task",
        description: "Project 1 description goes here", // Tích hợp project name vào mô tả (theo database relation)
        status: "in_progress",
        priority: "medium", // Có thể dùng project name để xác định priority (theo database relation)
        actualHours: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        taskId: 2,
        projectId: 1,
        name: "Task 2",
        description: "Project 1 task description",
        status: "to_do",
        priority: "medium",
        actualHours: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        taskId: 3,
        projectId: 1,
        name: "Task 3",
        description: "Project 1 task description",
        status: "to_do",
        priority: "medium",
        actualHours: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      // Tasks cho Project 2
      Task(
        taskId: 4,
        projectId: 2,
        name: "Task 1",
        description: "Project 2 description relates to this task",
        status: "in_progress",
        priority: "high",
        dueDate: DateTime.now(),
        actualHours: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        taskId: 5,
        projectId: 2,
        name: "Task 2",
        description: "Project 2 task description",
        status: "to_do",
        priority: "medium",
        actualHours: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Task(
        taskId: 6,
        projectId: 2,
        name: "Task 3",
        description: "Project 2 task description",
        status: "to_do",
        priority: "low",
        actualHours: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    // Dữ liệu mẫu cho các project
    _projects = [
      Project(
        projectId: 1,
        workspaceId: _currentWorkspace.workspaceId,
        name: "Project 1",
        description: "First project description",
        status: "active",
        createdBy: _currentUser.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        taskGroups: [],
      ),
      Project(
        projectId: 2,
        workspaceId: _currentWorkspace.workspaceId,
        name: "Project 2",
        description: "Second project description",
        status: "active",
        createdBy: _currentUser.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        taskGroups: [],
      ),
    ];

    // Nhóm task theo project và status
    for (var project in _projects) {
      final projectTasks = tasks.where((task) => task.projectId == project.projectId).toList();

      // Nhóm task theo status
      final Map<String, List<Task>> groupedTasks = {};
      for (var task in projectTasks) {
        if (!groupedTasks.containsKey(task.status)) {
          groupedTasks[task.status] = [];
        }
        groupedTasks[task.status]!.add(task);
      }

      // Thêm taskGroups vào project
      project.taskGroups.addAll(
        groupedTasks.entries.map((entry) => TaskGroup(
          status: entry.key,
          tasks: entry.value,
        )).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      label: 'My Task',
      child: Column(
        children: [
          // Navigation tabs
          NavigationTabs(
            selectedTabIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedTabIndex = index;
              });
            },
          ),

          // Toolbar
          TaskToolbar(
            onAddTask: () {
              _showAddTaskDialog(context);
            },
          ),

          // Projects list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                return ProjectGroupWidget(
                  project: _projects[index],
                  isExpanded: true,
                  onTaskTap: _handleTaskTap,
                  onAddTask: _handleAddTask,
                );
              },
            ),
          ),

          // Bottom status bar
          _buildBottomStatusBar(),
        ],
      ),
    );
  }

  // Thanh trạng thái bên dưới
  Widget _buildBottomStatusBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.help_outline, size: 14, color: Colors.grey.shade700),
                SizedBox(width: 4),
                Text(
                  "0/4",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "This view has unsaved changes",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text("Revert"),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {},
            child: Text("Enable Autosave"),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            child: Text("Save Ctrl+S"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Hiển thị chi tiết task khi click
  void _handleTaskTap(Task task) {
    // Xử lý khi click vào task (hiển thị chi tiết, edit...)
    print('Task tapped: ${task.name} (ID: ${task.taskId})');
  }

  // Thêm task mới
  void _handleAddTask(int projectId, String status) {
    // Xử lý thêm task mới vào project với status đã cho
    print('Add task to project $projectId with status $status');

    // Hiển thị dialog thêm task
    _showAddTaskDialog(context, projectId: projectId, status: status);
  }

  // Dialog thêm task
  void _showAddTaskDialog(BuildContext context, {int? projectId, String? status}) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(labelText: 'Project'),
              value: projectId,
              items: _projects.map((project) => DropdownMenuItem(
                value: project.projectId,
                child: Text(project.name),
              )).toList(),
              onChanged: (value) {
                projectId = value;
              },
            ),
            SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Status'),
              value: status,
              items: ['to_do', 'in_progress', 'in_review', 'done'].map((s) => DropdownMenuItem(
                value: s,
                child: Text(s.toUpperCase().replaceAll('_', ' ')),
              )).toList(),
              onChanged: (value) {
                status = value;
              },
            ),
            SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Task Name'),
            ),
            SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (projectId != null && status != null && nameController.text.isNotEmpty) {
                // Logic thêm task ở đây
                final newTask = Task(
                  taskId: DateTime.now().millisecondsSinceEpoch, // Tạm thời dùng timestamp làm ID
                  projectId: projectId!,
                  name: nameController.text,
                  description: descController.text,
                  status: status!,
                  priority: 'medium',
                  actualHours: 0,
                  createdBy: _currentUser.userId,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                setState(() {
                  // Tìm project cần thêm task
                  final project = _projects.firstWhere((p) => p.projectId == projectId);

                  // Tìm hoặc tạo task group phù hợp
                  TaskGroup? group = project.taskGroups.firstWhere(
                        (g) => g.status == status,
                    orElse: () {
                      final newGroup = TaskGroup(status: status!, tasks: []);
                      project.taskGroups.add(newGroup);
                      return newGroup;
                    },
                  );

                  // Thêm task vào group
                  group.tasks.add(newTask);
                });

                Navigator.pop(context);
              }
            },
            child: Text('Add Task'),
          ),
        ],
      ),
    );
  }
}
