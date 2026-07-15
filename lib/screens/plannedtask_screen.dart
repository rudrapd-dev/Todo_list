import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../controller/task_controller.dart';
import '../screens_common/add_task_screen.dart';

class PlannedScreen extends StatefulWidget {
  const PlannedScreen({super.key});

  @override
  State<PlannedScreen> createState() => _PlannedScreenState();
}

class _PlannedScreenState extends State<PlannedScreen> {
  final TaskController controller = Get.find<TaskController>();

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  // Stores expanded task ids
  final Set<String> expandedTasks = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planned Tasks"),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(
            () => AddTaskScreen(
              category: "Planned",
              selectedDate: selectedDay,
            ),
          );
        },
      ),

      // body: StreamBuilder<QuerySnapshot>(
      //   stream: controller.getPlannedTasks(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Center(
      //         child: Text(snapshot.error.toString()),
      //       );
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     final docs = snapshot.data!.docs;

      //     final selectedTasks = docs.where((doc) {
      //       final data = doc.data() as Map<String, dynamic>;

      //       final dueDate =
      //           (data["dueDate"] as Timestamp).toDate();

      //       return isSameDay(dueDate, selectedDay);
      //     }).toList();

      //     return Column(
      //       children: [

      //         // Calendar
      //         TableCalendar(
      //           firstDay: DateTime.utc(2025, 1, 1),
      //           lastDay: DateTime.utc(2035, 12, 31),
      //           focusedDay: focusedDay,

      //           selectedDayPredicate: (day) {
      //             return isSameDay(day, selectedDay);
      //           },

      //           onDaySelected: (selected, focused) {
      //             setState(() {
      //               selectedDay = selected;
      //               focusedDay = focused;
      //             });
      //           },

      //           eventLoader: (day) {
      //             return docs.where((doc) {
      //               final data =
      //                   doc.data() as Map<String, dynamic>;

      //               final dueDate =
      //                   (data["dueDate"] as Timestamp).toDate();

      //               return isSameDay(day, dueDate);
      //             }).toList();
      //           },

      //           calendarStyle: const CalendarStyle(
      //             todayDecoration: BoxDecoration(
      //               color: Colors.blue,
      //               shape: BoxShape.circle,
      //             ),
      //             selectedDecoration: BoxDecoration(
      //               color: Colors.orange,
      //               shape: BoxShape.circle,
      //             ),
      //             markerDecoration: BoxDecoration(
      //               color: Colors.red,
      //               shape: BoxShape.circle,
      //             ),
      //           ),
      //         ),

      //         const Divider(),

      //         Expanded(
      //           child: selectedTasks.isEmpty
      //               ? const Center(
      //                   child: Text(
      //                     "No Tasks",
      //                     style: TextStyle(fontSize: 18),
      //                   ),
      //                 )
      //               : ListView.builder(
      //                   itemCount: selectedTasks.length,
      //                   itemBuilder: (context, index) {
      //                     final doc = selectedTasks[index];

      //                     final data =
      //                         doc.data() as Map<String, dynamic>;

      //                     final dueDate =
      //                         (data["dueDate"] as Timestamp)
      //                             .toDate();

      //                     return Card(
      //                       margin: const EdgeInsets.symmetric(
      //                         horizontal: 12,
      //                         vertical: 8,
      //                       ),
      //                       elevation: 3,
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius:
      //                             BorderRadius.circular(12),
      //                       ),
      //                       child: Column(
      //                         children: [

      //                           ListTile(
      //                             leading: Checkbox(
      //                               value: data["completed"],
      //                               onChanged: (_) async {
      //                                 await controller.toggleTask(
      //                                   doc.id,
      //                                   data["completed"],
      //                                 );
      //                               },
      //                             ),

      //                             title: Text(
      //                               data["title"],
      //                               style: TextStyle(
      //                                 fontSize: 17,
      //                                 fontWeight:
      //                                     FontWeight.bold,
      //                                 decoration:
      //                                     data["completed"]
      //                                         ? TextDecoration
      //                                             .lineThrough
      //                                         : TextDecoration
      //                                             .none,
      //                               ),
      //                             ),

      //                             subtitle: Padding(
      //                               padding:
      //                                   const EdgeInsets.only(
      //                                       top: 5),
      //                               child: Text(
      //                                 "Due: ${DateFormat('dd MMM yyyy').format(dueDate)}",
      //                               ),
      //                             ),

      //                             trailing: Row(
      //                               mainAxisSize:
      //                                   MainAxisSize.min,
      //                               children: [

      //                                 IconButton(
      //                                   icon: Icon(
      //                                     expandedTasks
      //                                             .contains(
      //                                                 doc.id)
      //                                         ? Icons
      //                                             .keyboard_arrow_up
      //                                         : Icons
      //                                             .keyboard_arrow_down,
      //                                   ),
      //                                   onPressed: () {
      //                                     setState(() {
      //                                       if (expandedTasks
      //                                           .contains(
      //                                               doc.id)) {
      //                                         expandedTasks
      //                                             .remove(
      //                                                 doc.id);
      //                                       } else {
      //                                         expandedTasks
      //                                             .add(doc.id);
      //                                       }
      //                                     });
      //                                   },
      //                                 ),

      //                                 IconButton(
      //                                   icon: const Icon(
      //                                     Icons.delete,
      //                                     color: Colors.red,
      //                                   ),
      //                                   onPressed: () async {
      //                                     await controller
      //                                         .deleteTask(
      //                                             doc.id);
      //                                   },
      //                                 ),
      //                               ],
      //                             ),
      //                           ),

      //                           if (expandedTasks
      //                               .contains(doc.id))
      //                             Padding(
      //                               padding:
      //                                   const EdgeInsets
      //                                       .fromLTRB(
      //                                           20,
      //                                           0,
      //                                           20,
      //                                           20),
      //                               child: Column(
      //                                 crossAxisAlignment:
      //                                     CrossAxisAlignment
      //                                         .start,
      //                                 children: [

      //                                   const Divider(),

      //                                   const Text(
      //                                     "Description",
      //                                     style: TextStyle(
      //                                       fontSize: 16,
      //                                       fontWeight:
      //                                           FontWeight.bold,
      //                                     ),
      //                                   ),

      //                                   const SizedBox(
      //                                       height: 8),

      //                                   Text(
      //                                     (data["description"] ??
      //                                                 "")
      //                                             .toString()
      //                                             .trim()
      //                                             .isEmpty
      //                                         ? "No description added."
      //                                         : data[
      //                                             "description"],
      //                                     style:
      //                                         const TextStyle(
      //                                       fontSize: 15,
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                         ],
      //                       ),
      //                     );
      //                   },
      //                 ),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}