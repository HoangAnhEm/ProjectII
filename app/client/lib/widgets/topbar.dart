import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  final String label;
  const TopBarWidget({required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      // color: Colors.white10,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 3), // Đổ bóng chỉ ở phía dưới (bottom)
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            this.label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 24),
          // View options
          Spacer(),
          // Search
          Container(
            width: 250,
            height: 36,
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search everything...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          // Filter, Customize, User, Add Task
          IconButton(icon: Icon(Icons.filter_alt_outlined), onPressed: () {}),
          IconButton(icon: Icon(Icons.tune), onPressed: () {}),
          CircleAvatar(child: Text('T')),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}


