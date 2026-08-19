import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens_common/add_task_screen.dart';

import '../controller/task_controller.dart';
import '../widgest/task_tile.dart';


class TasksScreen extends StatelessWidget {
  TasksScreen({super.key});

  final TaskController controller =
      Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

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
                      color: Color(0xFF8FA2FF),
                    ),
                  ),

                  const Text(
                    "Lists",
                    style: TextStyle(
                      color: Color(0xFF8FA2FF),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF8FA2FF),
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
                  "Tasks",
                  style: TextStyle(
                    color: Color(0xFF8FA2FF),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// TASK LIST
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.getTasks("Tasks"),
                builder: (context, snapshot) {
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
                          const Icon(
                            Icons.task_alt,
                            size: 90,
                            color: Color(
                              0xFF8FA2FF,
                            ),
                          ),

                          const SizedBox(
                            height: 25,
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 40,
                            ),
                            child: Text(
                              "Tasks show up here if they aren’t part of any lists you've created.",
                              textAlign:
                                  TextAlign.center,
                              style: TextStyle(
                                color:
                                    Colors.blue.shade200,
                                fontSize: 18,
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
                    itemBuilder: (context, index) {
                      final task = tasks[index];

                      return TaskTile(
                        taskId: task.id,
                        title:
                            task['title'] ?? '',
                        description:
                            task['description'] ??
                                '',
                        completed:
                            task['completed'] ??
                                false, category: '',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// ADD TASK BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SizedBox(
            height: 60,
            child: ElevatedButton.icon(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.grey.shade900,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: Color(0xFF8FA2FF),
                size: 30,
              ),
              label: const Text(
                "Add a Task",
                style: TextStyle(
                  color: Color(0xFF8FA2FF),
                  fontSize: 22,
                  fontWeight:
                      FontWeight.w500,
                ),
              ),
              onPressed: () {
                Get.to(
                  () => const AddTaskScreen(
                    category: "Tasks",
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}