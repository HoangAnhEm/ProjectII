
import 'package:client/layout/user_layout.dart';
import 'package:client/services/token_service.dart';
import 'package:client/services/workspace_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../models/workspace.dart';
import '../providers/workspace_provider.dart';

class HomePage extends ConsumerStatefulWidget  {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with SingleTickerProviderStateMixin {
  final _workspaceService = WorkspaceService();
  final _tokenService = TokenService();

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> suggestedWorkspaces = [
    {'name': 'Sheets', 'location': '', 'status': 'Recently created by you'},
    {'name': '4. Project Dashboard', 'location': 'PRJ1', 'status': 'Recently created by you'},
    {'name': '2. Task Summary Report', 'location': 'PRJ1', 'status': 'Recently created by you'},
    {'name': '3. Overdue Tasks Report', 'location': 'PRJ1', 'status': 'Recently created by you'},
    {'name': '1. Task Sheet', 'location': 'PRJ1', 'status': 'Recently edited'},
  ];

  final List<Map<String, String>> allWorkspaces = [
    // Ví dụ thêm workspace khác nếu cần
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCreateProjectButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          // Button tím bên trái
          Expanded(
            child: Container(
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  _showAddWorkspaceDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6F4FF2), // Tím gradient có thể dùng màu này
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Bo góc nhỏ
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Start a new project, program or process',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Choose a template or start from scratch',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          // Button phải: hỗ trợ peer-to-peer
          Expanded(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Peer-to-peer support',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(
                                text: 'Find best practices and guidance from fellow users in our Community. ',
                              ),
                              TextSpan(
                                text: 'Get connected.',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                // Có thể thêm recognizer nếu muốn click
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  // Ảnh minh họa (nếu muốn giống ảnh mẫu)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://img.icons8.com/ios-filled/50/000000/group-foreground-selected.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildTabBar() {
    return Container(
      width: 300,
      alignment: Alignment.topRight,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.deepPurple,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.deepPurple,
        tabs: [
          Tab(text: 'Suggested'),
          Tab(text: 'All workspaces'),
        ],
      ),
    );
  }

  Widget _buildWorkspaceTable(List<Map<String, String>> workspaces) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: DataTable(
        columns: [
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Location')),
          DataColumn(label: Text('')),
        ],
        rows: workspaces.map((ws) {
          return DataRow(cells: [
            DataCell(Row(
              children: [
                Icon(_getIconForName(ws['name'] ?? ''), size: 20),
                SizedBox(width: 8),
                Text(ws['name'] ?? ''),
              ],
            )),
            DataCell(Text(ws['location'] ?? '')),
            DataCell(Container(child: Text(ws['status'] ?? '', style: TextStyle(color: Colors.grey)), alignment: Alignment.topRight)),
          ]);
        }).toList(),
      ),
    );
  }

  IconData _getIconForName(String name) {
    // Dựa trên tên hoặc loại workspace/project để chọn icon phù hợp
    if (name.toLowerCase().contains('dashboard')) return Icons.dashboard;
    if (name.toLowerCase().contains('task')) return Icons.task;
    if (name.toLowerCase().contains('report')) return Icons.insert_drive_file;
    if (name.toLowerCase().contains('sheet')) return Icons.grid_on;
    return Icons.folder;
  }

  @override
  Widget build(BuildContext context) {
    return UserLayout(
      label: 'HomePage',
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCreateProjectButton(),
            SizedBox(height: 24),
            _buildTabBar(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 2,
                ),
              ),
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWorkspaceTable(suggestedWorkspaces),
                  _buildWorkspaceTable(allWorkspaces),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddWorkspaceDialog(BuildContext context, {List<User>? allUsers}) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descController = TextEditingController();
    bool isPublic = false;
    List<User> selectedMembers = [];

    void handleCreate() async {
      if (nameController.text.isNotEmpty) {
        // Logic thêm workspace ở đây
        // final newWorkspace = Workspace(
        //   workspaceId: DateTime.now().millisecondsSinceEpoch, // tạm thời
        //   name: nameController.text,
        //   description: descController.text,
        //   isPublic: isPublic,
        //   members: selectedMembers,
        //   createdAt: DateTime.now(),
        //   updatedAt: DateTime.now(),
        // );
        final newWorkspace = {
          'name': nameController.text,
          'description': descController.text,
          'is_public': isPublic,
          'members': selectedMembers.map((m) => m.toJson()).toList(),
        };
        String? access_token = await _tokenService.getAccessToken();
        if(access_token == null){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Đăng nhập thất bại. Vui lòng thử lại.'))
          );
          Navigator.pop(context);
          return;
        }

        _workspaceService.createWorkspace(access_token, newWorkspace);
        ref.invalidate(userWorkspacesProvider);
        Navigator.pop(context);

        setState(() {
          // _workspaces.add(newWorkspace);
        });


      }
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add New Workspace'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Workspace Name'),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                SizedBox(height: 12),
                SwitchListTile(
                  title: Text('Public Workspace'),
                  value: isPublic,
                  onChanged: (value) {
                    setState(() {
                      isPublic = value;
                    });
                  },
                ),
                if (allUsers != null && allUsers.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Members', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Wrap(
                    spacing: 6,
                    children: allUsers.map((user) {
                      final isSelected = selectedMembers.contains(user);
                      return FilterChip(
                        label: Text(user.username),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedMembers.add(user);
                            } else {
                              selectedMembers.remove(user);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => handleCreate(),
              child: Text('Add Workspace'),
            ),
          ],
        ),
      ),
    );
  }
}

