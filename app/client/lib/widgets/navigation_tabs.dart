import 'package:flutter/material.dart';

class NavigationTabs extends StatelessWidget {
  final int selectedTabIndex;
  final Function(int) onTabChanged;

  const NavigationTabs({
    Key? key,
    required this.selectedTabIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildAddChannelButton(),
          ..._buildTabs(),
        ],
      ),
    );
  }

  Widget _buildAddChannelButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Text('Add Channel'),
      ),
    );
  }

  List<Widget> _buildTabs() {
    final tabs = [
      {'icon': Icons.article_outlined, 'label': 'Overview'},
      {'icon': Icons.dashboard_outlined, 'label': 'Board'},
      {'icon': Icons.list_alt_outlined, 'label': 'List'},
      {'icon': Icons.calendar_today_outlined, 'label': 'Calendar'},
      {'icon': Icons.bar_chart_outlined, 'label': 'Gantt'},
      {'icon': Icons.table_chart_outlined, 'label': 'Table'},
      {'icon': Icons.timeline_outlined, 'label': 'Timeline'},
    ];

    return [
      for (int i = 0; i < tabs.length; i++)
        InkWell(
          onTap: () => onTabChanged(i),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: i == selectedTabIndex ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  tabs[i]['icon'] as IconData,
                  size: 20,
                  color: i == selectedTabIndex ? Colors.blue : Colors.grey.shade600,
                ),
                SizedBox(width: 8),
                Text(
                  tabs[i]['label'] as String,
                  style: TextStyle(
                    color: i == selectedTabIndex ? Colors.blue : Colors.grey.shade600,
                    fontWeight: i == selectedTabIndex ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

      // View More button
      IconButton(
        icon: Icon(Icons.more_horiz, color: Colors.grey.shade600),
        onPressed: () {},
      ),
    ];
  }
}
