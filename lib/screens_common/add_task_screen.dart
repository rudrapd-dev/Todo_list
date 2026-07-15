import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/task_controller.dart';

class AddTaskScreen extends StatelessWidget {
  AddTaskScreen({
    super.key,
    required this.category,
    this.selectedDate,
  });

  final String category;
  final DateTime? selectedDate;

  final TextEditingController taskController = TextEditingController();

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            if (category == "Planned" && selectedDate != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),

                      const SizedBox(width: 10),

                      Text(
                        "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (taskController.text.trim().isEmpty) {
                    Get.snackbar(
                      "Error",
                      "Please enter task title",
                    );
                    return;
                  }

                  await controller.addTask(
                    title: taskController.text.trim(),
                    category: category,
                     description: '',
                  );

                  Get.back();
                },
                child: const Text("Save Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}