import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:super_drag_and_drop/super_drag_and_drop.dart';

import '../models/project.dart';
import '../models/task.dart';


class MeetingMinutesDropScreen extends StatefulWidget {
  const MeetingMinutesDropScreen({super.key});

  @override
  State<MeetingMinutesDropScreen> createState() => _MeetingMinutesDropScreenState();
}

class _MeetingMinutesDropScreenState extends State<MeetingMinutesDropScreen> {
  bool _dragging = false;
  String? _fileContent;
  List<String> _tasks = [];

  List<Project> _projects = [
    Project(
      projectId: 1,
      workspaceId: 1,
      name: "Project 1",
      description: "First project description",
      status: "active",
      createdBy: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      taskGroups: [],
    ),
    Project(
      projectId: 2,
      workspaceId: 1,
      name: "Project 2",
      description: "Second project description",
      status: "active",
      createdBy: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      taskGroups: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chuyển biên bản họp thành công việc'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Vùng kéo thả file
            Expanded(
              flex: 0,
              child: DropRegion(
                formats: const [Formats.plainText, Formats.fileUri],
                onDropOver: (event) => DropOperation.copy,
                onDropEnter: (event) => setState(() => _dragging = true),
                onDropLeave: (event) => setState(() => _dragging = false),
                onPerformDrop: (event) async {
                  setState(() {
                    _dragging = false;
                    _fileContent = null;
                    _tasks = [];
                  });

                  // Lấy đường dẫn file (chỉ demo với file .txt)
                  final item = event.session.items.first;
                  final reader = item.dataReader!;
                  if (reader.canProvide(Formats.fileUri)) {
                    reader.getValue<Uri>(Formats.fileUri, (uri) async {
                      if (uri != null) {
                        final path = uri.toFilePath();
                        if (path.endsWith('.txt')) {
                          final content = await File(path).readAsString();
                          setState(() {
                            _fileContent = content;
                            _tasks = _extractTasksFromText(content);
                          });
                        } else {
                          setState(() {
                            _fileContent = '[Chỉ hỗ trợ file .txt]';
                            _tasks = [];
                          });
                        }
                      }
                    });
                  } else if (reader.canProvide(Formats.plainText)) {
                    reader.getValue<String>(Formats.plainText, (value) {
                      setState(() {
                        _fileContent = value;
                        _tasks = _extractTasksFromText(value ?? '');
                      });
                    });
                  }
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: _dragging ? Colors.indigo.withOpacity(0.1) : Colors.grey[100],
                    border: Border.all(
                      color: _dragging ? Colors.indigo : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 48, color: _dragging ? Colors.indigo : Colors.grey),
                        const SizedBox(height: 8),
                        Text(
                          'Kéo và thả file biên bản họp (.txt) vào đây',
                          style: TextStyle(
                            fontSize: 18,
                            color: _dragging ? Colors.indigo : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '(Chỉ hỗ trợ file .txt)',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_fileContent != null)
              Expanded(
                child: Row(
                  children: [
                    // Nội dung file
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Nội dung biên bản họp:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SingleChildScrollView(child: Text(_fileContent!)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Danh sách công việc
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Công việc trích xuất:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Expanded(
                            child: _tasks.isEmpty
                                ? const Text('Không phát hiện công việc nào.')
                                : ListView.separated(
                              itemCount: _tasks.length,
                              separatorBuilder: (_, __) => const Divider(),
                              itemBuilder: (context, index) => TextButton(
                                onPressed: () => _showAddTaskDialog(context, _tasks[index]),
                                child: ListTile(
                                  leading: const Icon(Icons.task),
                                  title: Text(_tasks[index]),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Demo: tách các dòng bắt đầu bằng '-' hoặc 'Task:' thành công việc
  List<String> _extractTasksFromText(String text) {
    // Trả về danh sách công việc demo
    return [
      'Hoàn thành báo cáo tài chính',
      'Gửi email cho khách hàng',
      'Lên kế hoạch họp nhóm',
      'Cập nhật tiến độ dự án',
      'Kiểm tra và phê duyệt tài liệu',
    ];
  }

  void _showAddTaskDialog(BuildContext context, String name, {int? projectId, String? status}) {
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
              decoration: InputDecoration(labelText: name),
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
                  createdBy: 1,
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
