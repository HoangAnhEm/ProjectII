import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/topbar.dart';

class UserLayout extends StatelessWidget {
  final Widget child;
  final String label;
  const UserLayout({required this.child, required this.label});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          SidebarWidget(),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                TopBarWidget(label: this.label,),
                // Main content
                Expanded(
                  child: this.child
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
