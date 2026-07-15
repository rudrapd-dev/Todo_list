import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/task_controller.dart';

class TaskTile extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final bool completed;

  const TaskTile({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.completed,
  });

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool expanded = false;

  final TaskController controller = Get.find<TaskController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.grey.shade900.withOpacity(0.85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(
              value: widget.completed,
              activeColor: Colors.blue,
              onChanged: (_) {
                controller.toggleTask(
                  widget.taskId,
                  widget.completed,
                );
              },
            ),

            title: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                decoration: widget.completed
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  tooltip: expanded
                      ? "Hide Description"
                      : "Show Description",
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                  },
                ),

                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  tooltip: "Delete Task",
                  onPressed: () async {
                    final bool? confirm =
                        await showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(15),
                          ),
                          title: const Text(
                            "Delete Task?",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to delete "${widget.title}"?',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  false,
                                );
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  true,
                                );
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      controller.deleteTask(widget.taskId);
                    }
                  },
                ),
              ],
            ),
          ),

          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 70,
                right: 20,
                bottom: 18,
              ),
              child: Text(
                widget.description.trim().isEmpty
                    ? "No description available."
                    : widget.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(
              milliseconds: 250,
            ),
          ),
        ],
      ),
    );
  }
}