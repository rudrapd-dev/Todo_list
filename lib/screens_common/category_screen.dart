import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/widgest/task_tile.dart';

import '../controller/task_controller.dart';
import '../screens_common/list_options_sheet.dart';
import '../screens_common/add_task_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String title;
  final Color titleColor;
  final String category;
  final Widget? emptyWidget;
  final Widget? topWidget;

  CategoryScreen({
    super.key,
    required this.title,
    required this.category,
    required this.titleColor,
    this.emptyWidget,
    this.topWidget,
  });

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
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
                      fontSize: 18,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      // Get.bottomSheet(
                      //   ListOptionsSheet(
                      //     category: category,
                      //   ),
                      //   isScrollControlled: true,
                      //   backgroundColor: Colors.transparent,
                      // );
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// Optional Top Widget
            if (topWidget != null)
              Padding(
                padding: const EdgeInsets.all(20),
                child: topWidget!,
              ),

            const SizedBox(height: 10),

            /// Task List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.getTasks(category),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return emptyWidget ??
                        const Center(
                          child: Text(
                            "No Tasks",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 18,
                            ),
                          ),
                        );
                  }

                  final tasks = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 90,
                      top: 5,
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return TaskTile(
                        taskId: task.id,
                        title: task['title'] ?? '',
                        description: task['description'] ?? '',
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

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey.shade900,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
        onPressed: () {
          Get.to(
            () => AddTaskScreen(
              category: category,
            ),
          );
        },
      ),
    );
  }
}