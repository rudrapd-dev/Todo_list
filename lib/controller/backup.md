import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list/controller/task_controller.dart';
import 'package:todo_list/screens_common/add_task_screen.dart';

class PlannedScreen extends StatefulWidget {
  const PlannedScreen({super.key});

  @override
  State<PlannedScreen> createState() => _PlannedScreenState();
}

class _PlannedScreenState extends State<PlannedScreen> {
  final TaskController controller = Get.find();

  DateTime focusedDay = DateTime.now();
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Planned"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => AddTaskScreen(
              category: "Planned",
              selectedDate: selectedDay,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getTasks("Planned"),
        builder: (context, allSnapshot) {
          if (allSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (allSnapshot.hasError) {
            return Center(
              child: Text(allSnapshot.error.toString()),
            );
          }

          final allDocs = allSnapshot.data?.docs ?? [];

          List<QueryDocumentSnapshot> selectedTasks = [];

          for (var doc in allDocs) {
            final data = doc.data() as Map<String, dynamic>;

            final dueDate =
                (data["dueDate"] as Timestamp).toDate();

            if (isSameDay(dueDate, selectedDay)) {
              selectedTasks.add(doc);
            }
          }

          return Column(
            children: [

              TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2035, 12, 31),
                focusedDay: focusedDay,

                selectedDayPredicate: (day) {
                  return isSameDay(day, selectedDay);
                },

                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    focusedDay = focused;
                  });
                },

                eventLoader: (day) {
                  return allDocs.where((doc) {
                    final data =
                        doc.data() as Map<String, dynamic>;

                    final dueDate =
                        (data["dueDate"] as Timestamp).toDate();

                    return isSameDay(day, dueDate);
                  }).toList();
                },

                calendarStyle: const CalendarStyle(
                  markerDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              const Divider(),

              Expanded(
                child: selectedTasks.isEmpty
                    ? const Center(
                        child: Text(
                          "No Tasks",
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: selectedTasks.length,
                        itemBuilder: (context, index) {

                          final doc = selectedTasks[index];

                          final data =
                              doc.data() as Map<String, dynamic>;

                          final dueDate =
                              (data["dueDate"] as Timestamp).toDate();

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: CheckboxListTile(
                              value: data["completed"],

                              onChanged: (_) {
                                controller.toggleTask(
                                  doc.id,
                                  data["completed"],
                                );
                              },

                              title: Text(
                                data["title"],
                                style: TextStyle(
                                  decoration: data["completed"]
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),

                              subtitle: Text(
                                "Due: ${DateFormat('dd MMM yyyy • hh:mm a').format(dueDate)}",
                              ),

                              secondary: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  controller.deleteTask(doc.id);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}