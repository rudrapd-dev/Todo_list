import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/task_controller.dart';
import '../widgest/task_tile.dart';
import '../screens_common/add_task_screen.dart';

class AssignedScreen extends StatelessWidget {
  AssignedScreen({super.key});

  final TaskController controller =
      Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey.shade900,
        icon: const Icon(Icons.add),
        label: const Text("Add Task"),
        onPressed: () {
          Get.to(
            () => const AddTaskScreen(
              category: "Assigned",
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
                      color: Color(0xffA8D5C2),
                    ),
                  ),

                  const Text(
                    "Lists",
                    style: TextStyle(
                      color: Color(0xffA8D5C2),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Color(0xffA8D5C2),
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
                child: Text(
                  "Assigned to me",
                  style: TextStyle(
                    color: Color(0xffA8D5C2),
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// TASKS
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    controller.getTasks("Assigned"),

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
                          Image.asset(
                            "assets/png/assigned.png",
                            height: 140,
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          const Text(
                            "Tasks assigned to you in To Do or Planner\nshow up here",
                            textAlign:
                                TextAlign.center,
                            style: TextStyle(
                              color: Color(
                                0xffA8D5C2,
                              ),
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final docs =
                      snapshot.data!.docs;

                  return ListView.builder(
                    padding:
                        const EdgeInsets.only(
                      bottom: 100,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (
                      context,
                      index,
                    ) {
                      final task =
                          docs[index];

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