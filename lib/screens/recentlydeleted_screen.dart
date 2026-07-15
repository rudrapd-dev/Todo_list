import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/task_controller.dart';

class RecentlyDeletedScreen extends StatelessWidget {
  RecentlyDeletedScreen({super.key});

  final TaskController controller =
      Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Recently Deleted",
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getDeletedTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final docs =
              snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "No Deleted Tasks",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder:
                (context, index) {
              final task = docs[index];

              return Card(
                color: Colors.grey[900],
                child: ListTile(
                  title: Text(
                    task['title'],
                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                    ),
                  ),

                  subtitle: Text(
                    task['category'],
                    style:
                        const TextStyle(
                      color:
                          Colors.white54,
                    ),
                  ),

                  trailing: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.restore,
                          color:
                              Colors.green,
                        ),
                        onPressed: () {
                          controller
                              .restoreTask(
                            task.id,
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          controller
                              .permanentlyDeleteTask(
                            task.id,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 