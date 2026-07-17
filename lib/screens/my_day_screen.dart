import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controller/task_controller.dart';
import 'package:todo_list/screens_common/add_task_screen.dart';
import 'package:todo_list/screens_common/list_options_sheet.dart';
import 'package:todo_list/widgest/task_tile.dart';

class MyDayScreen extends StatelessWidget {
  MyDayScreen({super.key});

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black87,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
        onPressed: () {
          Get.to(
            () => AddTaskScreen(
              category: "My Day",
            ),
          );
        },
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/png/image.png",
              fit: BoxFit.cover,
            ),
          ),

          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          SafeArea(
            child: Column(
              children: [
                /// Top Bar
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),

                      const Text(
                        "Lists",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.lightbulb_outline,
                          color: Colors.white,
                        ),
                      ),

                      IconButton(
  onPressed: () {
    Get.bottomSheet(
      const ListOptionsSheet(
        category: "My Day",
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  },
  icon: const Icon(
    Icons.more_horiz,
    color: Colors.white,
  ),
),
                    ],
                  ),
                ),

                /// Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "My Day",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          today,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Task List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: controller.getTasks("My Day"),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Tasks Yet",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        );
                      }

                      final tasks = snapshot.data!.docs;

                      return ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          bottom: 100,
                        ),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];

                          return TaskTile(
                            taskId: task.id,
                            title: task['title'] ?? '',
                            description:
                                task.data().toString().contains('description')
                                    ? task['description'] ?? ''
                                    : '',
                            completed: task['completed'] ?? false,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}