import 'package:flutter/material.dart';
import 'package:client/providers/workspace_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/workspace.dart';

class SidebarWidget extends ConsumerWidget  {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWorkspace = ref.watch(currentWorkspaceProvider);
    final workspacesAsync = ref.watch(userWorkspacesProvider);

    return Container(
      width: 260,
      color: Colors.black87,
      child: Column(
        children: [
          SizedBox(height: 16),
          // Logo & Workspace
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: workspacesAsync.when(
              loading: () => _buildWorkspaceLoading(),
              error: (error, stack) => _buildWorkspaceError(),
              data: (workspaces) => _buildWorkspaceDropdown(
                ref,
                workspaces,
                currentWorkspace,
              ),
            ),
          ),
          Divider(color: Colors.white24),
          // Main navigation
          _SidebarButton(icon: Icons.home, label: 'Home'),
          _SidebarButton(icon: Icons.list_alt, label: 'My Tasks'),
          _SidebarButton(icon: Icons.calendar_today, label: 'Calendar'),
          _SidebarButton(icon: Icons.dashboard, label: 'Dashboard'),
          _SidebarButton(icon: Icons.access_time, label: 'Timesheet'),
          _SidebarButton(icon: Icons.restart_alt, label: 'Convert'),
          _SidebarButton(icon: Icons.more_horiz, label: 'More'),
          Divider(color: Colors.white24),
          // Favorites, Channels, Spaces
          _SidebarSection(title: 'Favorites', children: []),
          _SidebarSection(title: 'Channels', children: [
            ListTile(
              leading: Icon(Icons.tag, color: Colors.white70, size: 20),
              title: Text('Tuan\'s Workspace', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.white70, size: 20),
              title: Text('Add Channel', style: TextStyle(color: Colors.white70)),
            ),
          ]),
          _SidebarSection(title: 'Spaces', children: [
            ListTile(
              leading: Icon(Icons.space_dashboard, color: Colors.white70, size: 20),
              title: Text('Tuan\'s Workspace', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: Icon(Icons.group, color: Colors.white70, size: 20),
              title: Text('Team Space', style: TextStyle(color: Colors.white70)),
            ),
            ListTile(
              leading: Icon(Icons.add, color: Colors.white70, size: 20),
              title: Text('New Space', style: TextStyle(color: Colors.white70)),
            ),
          ]),
          Spacer(),
          // Invite & Upgrade
          ListTile(
            leading: Icon(Icons.person_add, color: Colors.pinkAccent),
            title: Text('Invite', style: TextStyle(color: Colors.pinkAccent)),
          ),
          ListTile(
            leading: Icon(Icons.upgrade, color: Colors.amber),
            title: Text('Upgrade', style: TextStyle(color: Colors.amber)),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
  Widget _buildWorkspaceDropdown(
      WidgetRef ref,
      List<Workspace> workspaces,
      Workspace? currentWorkspace,
      ) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentWorkspace?.id, // Sử dụng ID
        isExpanded: true,
        dropdownColor: Colors.black87,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        items: workspaces
            .map((workspace) => DropdownMenuItem<String>(
          value: workspace.id, // Sử dụng ID
          child: ListTile(
            leading: CircleAvatar(child: Text(workspace.name[0])),
            title: Text(
              workspace.name,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ))
            .toList(),
        onChanged: (String? newWorkspaceId) {
          if (newWorkspaceId != null) {
            final selectedWorkspace = workspaces.firstWhere(
                    (workspace) => workspace.id == newWorkspaceId
            );
            ref.read(currentWorkspaceProvider.notifier)
                .setCurrentWorkspace(selectedWorkspace);
          }
        },
        hint: Text(
          'Select Workspace',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }


  Widget _buildWorkspaceLoading() {
    return ListTile(
      leading: CircleAvatar(child: CircularProgressIndicator(color: Colors.white)),
      title: Text(
        'Loading...',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildWorkspaceError() {
    return ListTile(
      leading: Icon(Icons.error, color: Colors.red),
      title: Text(
        'Failed to load workspaces',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SidebarButton({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    String getRoute(String label) {
      switch (label) {
        case 'Home':
          return '/home';
        case 'My Tasks':
          return '/myTask';
        case 'Calendar':
          return '/calendar';
        case 'Dashboard':
          return '/dashboard';
        case 'Timesheet':
          return '/timesheet';
        case 'Convert':
          return '/convert';
        case 'More':
          return '/more';
        default:
          return '/home';
      }
    }
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pushReplacementNamed(context, getRoute(label));
      },
    );
  }
}

class _SidebarSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SidebarSection({required this.title, required this.children});
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
      children: children,
      collapsedIconColor: Colors.white54,
      iconColor: Colors.white,
    );
  }
}
