import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  final String category;
  final DateTime? selectedDate;

  const AddTaskScreen({
    super.key,
    required this.category,
    this.selectedDate,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController controller = Get.find<TaskController>();

  final TextEditingController titleController =
      TextEditingController();

  final TextEditingController descriptionController =
      TextEditingController();

  bool showDescription = false;
  bool isLoading = false;

  Future<void> saveTask() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a task title",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await controller.addTask(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: widget.category,
        dueDate: widget.selectedDate ?? DateTime.now(),
      );

      Get.back();

      Get.snackbar(
        "Success",
        "Task Added Successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// TITLE FIELD
            TextField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: "Task Title",
                hintText: "Enter task title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            /// DESCRIPTION SECTION
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: const Text("Description"),
                    trailing: IconButton(
                      icon: Icon(
                        showDescription
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                      onPressed: () {
                        setState(() {
                          showDescription =
                              !showDescription;
                        });
                      },
                    ),
                  ),

                  if (showDescription)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        0,
                        16,
                        16,
                      ),
                      child: TextField(
                        controller: descriptionController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText:
                              "Write additional details about this task...",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// DATE CARD FOR PLANNED TASKS
            if (widget.category == "Planned" &&
                widget.selectedDate != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    isLoading ? null : saveTask,
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Save Task",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}