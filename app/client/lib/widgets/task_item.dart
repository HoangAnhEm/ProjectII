// import 'package:flutter/material.dart';
//
// import '../models/task.dart';
//
// class TaskItemWidget extends StatelessWidget {
//   final Task task;
//
//   const TaskItemWidget({
//     Key? key,
//     required this.task,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Colors.grey.shade200),
//         ),
//       ),
//       child: Row(
//         children: [
//           SizedBox(width: 36),
//           _buildTaskCheckbox(),
//           SizedBox(width: 12),
//           Expanded(
//             flex: 3,
//             child: Text(
//               task.name,
//               style: TextStyle(
//                 fontSize: 14,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: _buildAssignee(),
//           ),
//           Expanded(
//             flex: 1,
//             child: _buildDueDate(),
//           ),
//           Expanded(
//             flex: 1,
//             child: _buildPriority(),
//           ),
//           IconButton(
//             icon: Icon(Icons.more_horiz, size: 18, color: Colors.grey.shade600),
//             onPressed: () {},
//             padding: EdgeInsets.zero,
//             constraints: BoxConstraints(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTaskCheckbox() {
//     return Container(
//       width: 20,
//       height: 20,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(color: Colors.blue, width: 2),
//       ),
//       child: Center(
//         child: Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: Colors.blue,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAssignee() {
//     return Container(
//       child: task.assigneeId != null
//           ? CircleAvatar(
//         radius: 14,
//         backgroundColor: Colors.grey.shade300,
//         child: Icon(Icons.person_outline, size: 16, color: Colors.grey.shade700),
//       )
//           : Icon(Icons.person_add_alt_outlined, size: 18, color: Colors.grey.shade500),
//     );
//   }
//
//   Widget _buildDueDate() {
//     return Container(
//       child: task.dueDate != null
//           ? Row(
//         children: [
//           Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade600),
//           SizedBox(width: 4),
//           Text(
//             task.dueDate!.day == DateTime.now().day &&
//                 task.dueDate!.month == DateTime.now().month &&
//                 task.dueDate!.year == DateTime.now().year
//                 ? "Today"
//                 : DateFormat("MMM d").format(task.dueDate!),
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey.shade700,
//             ),
//           ),
//         ],
//       )
//           : Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey.shade400),
//     );
//   }
//
//   Widget _buildPriority() {
//     IconData priorityIcon;
//     Color priorityColor;
//
//     switch (task.priority) {
//       case TaskPriority.urgent:
//         priorityIcon = Icons.flag;
//         priorityColor = Colors.red;
//         break;
//       case TaskPriority.high:
//         priorityIcon = Icons.flag;
//         priorityColor = Colors.orange;
//         break;
//       case TaskPriority.normal:
//         priorityIcon = Icons.flag_outlined;
//         priorityColor = Colors.grey.shade600;
//         break;
//       case TaskPriority.low:
//         priorityIcon = Icons.flag_outlined;
//         priorityColor = Colors.grey.shade400;
//         break;
//     }
//
//     return Icon(priorityIcon, size: 18, color: priorityColor);
//   }
// }
