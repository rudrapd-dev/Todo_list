import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/task_controller.dart';
import '../screens_common/add_task_screen.dart';
import '../widgest/task_tile.dart';

class FlaggedScreen extends StatelessWidget {
  FlaggedScreen({super.key});

  final TaskController controller =
      Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: Colors.grey.shade900,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
        onPressed: () {
          Get.to(
            () => const AddTaskScreen(
              category: "Flagged",
            ),
          );
        },
      ),

      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
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
                      color: Color(0xFFFFD7C2),
                    ),
                  ),

                  const Text(
                    "Lists",
                    style: TextStyle(
                      color: Color(0xFFFFD7C2),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFFFFD7C2),
                    ),
                  ),
                ],
              ),
            ),

            /// TITLE
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Icon(
                      Icons.outlined_flag,
                      color: Color(0xFFFFD7C2),
                      size: 42,
                    ),

                    SizedBox(width: 10),

                    Text(
                      "Flagged Email",
                      style: TextStyle(
                        color: Color(0xFFFFD7C2),
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.getTasks(
                  "Flagged",
                ),
                builder: (
                  context,
                  snapshot,
                ) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 110,
                            color: Colors.blue.shade300,
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          const Padding(
                            padding:
                                EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              "Messages you flag will show up as tasks here.",
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                color: Color(
                                  0xFFFFD7C2,
                                ),
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final tasks =
                      snapshot.data!.docs;

                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(
                      bottom: 100,
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final task =
                          tasks[index];

                      return TaskTile(
                        taskId: task.id,
                        title:
                            task['title'] ?? '',
                        description:
                            task['description'] ??
                                '',
                        completed:
                            task['completed'] ??
                                false,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}