import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: Colors.black87,
      child: Column(
        children: [
          SizedBox(height: 16),
          // Logo & Workspace
          ListTile(
            leading: CircleAvatar(child: Text('T')),
            title: Text('Tuan\'s Workspace', style: TextStyle(color: Colors.white)),
            subtitle: Text('All Tasks', style: TextStyle(color: Colors.white70, fontSize: 12)),
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
