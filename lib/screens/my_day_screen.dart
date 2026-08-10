import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/controller/task_controller.dart';
import 'package:todo_list/controller/theme_controller.dart';

import 'package:todo_list/screens_common/add_task_screen.dart';
import 'package:todo_list/screens_common/list_options_sheet.dart';
import 'package:todo_list/widgest/task_tile.dart';

class MyDayScreen extends StatelessWidget {
  MyDayScreen({super.key});

  final TaskController controller =
      Get.find<TaskController>();

  final ThemeController themeController =
      Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final String today =
        DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,

      // =========================================================
      // ADD TASK BUTTON
      // =========================================================

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black87,

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        label: const Text(
          "Add Task",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        onPressed: () {
          Get.to(
            () => AddTaskScreen(
              category: "My Day",
            ),
          );
        },
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: Obx(
        () {
          return Stack(
            children: [

              // =================================================
              // BACKGROUND
              // =================================================

              Positioned.fill(
                child: _buildBackground(),
              ),

              // =================================================
              // DARK OVERLAY
              // =================================================

              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.35),
                ),
              ),

              // =================================================
              // CONTENT
              // =================================================

              SafeArea(
                child: Column(
                  children: [

                    // =========================================
                    // TOP BAR
                    // =========================================

                    Padding(
                      padding: const EdgeInsets.all(20),

                      child: Row(
                        children: [

                          // Back button
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },

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

                          // Lightbulb
                          IconButton(
                            onPressed: () {},

                            icon: const Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white,
                            ),
                          ),

                          // More options
                          IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                const ListOptionsSheet(
                                  category: "My Day",
                                ),

                                isScrollControlled: true,

                                backgroundColor:
                                    Colors.transparent,
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

                    // =========================================
                    // TITLE + DATE
                    // =========================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Align(
                            alignment:
                                Alignment.centerLeft,

                            child: const Text(
                              "My Day",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          Align(
                            alignment:
                                Alignment.centerLeft,

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

                    // =========================================
                    // TASK LIST
                    // =========================================

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: controller.getTasks(
                          "My Day",
                        ),

                        builder: (
                          context,
                          snapshot,
                        ) {

                          // -------------------------------
                          // LOADING
                          // -------------------------------

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          // -------------------------------
                          // ERROR
                          // -------------------------------

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Error loading tasks:\n${snapshot.error}",

                                textAlign: TextAlign.center,

                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          // -------------------------------
                          // NO TASKS
                          // -------------------------------

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

                          final tasks =
                              snapshot.data!.docs;

                          // -------------------------------
                          // TASK LIST
                          // -------------------------------

                          return ListView.builder(
                            padding:
                                const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              bottom: 100,
                            ),

                            itemCount: tasks.length,

                            itemBuilder:
                                (context, index) {

                              final task =
                                  tasks[index];

                              final data =
                                  task.data()
                                      as Map<String, dynamic>;

                              return TaskTile(
                                taskId: task.id,

                                title:
                                    data["title"] ??
                                        "",

                                description:
                                    data["description"] ??
                                        "",

                                completed:
                                    data["completed"] ??
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
            ],
          );
        },
      ),
    );
  }

  // ===========================================================
  // BUILD BACKGROUND
  // ===========================================================

  Widget _buildBackground() {

    // =========================================================
    // CATEGORY
    // =========================================================

    const String category = "My Day";

    // =========================================================
    // 1. CUSTOM IMAGE
    // =========================================================

    final String? customImagePath =
        themeController.selectedImages[category];

    if (customImagePath != null &&
        customImagePath.isNotEmpty) {

      final File imageFile =
          File(customImagePath);

      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          fit: BoxFit.cover,

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return _defaultBackground();
          },
        );
      }
    }

    // =========================================================
    // 2. DEFAULT THEME
    // =========================================================

    final String? defaultTheme =
        themeController.selectedThemes[category];

    if (defaultTheme != null &&
        defaultTheme.isNotEmpty) {

      return Image.asset(
        defaultTheme,
        fit: BoxFit.cover,

        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _defaultBackground();
        },
      );
    }

    // =========================================================
    // 3. DEFAULT APP BACKGROUND
    // =========================================================

    return _defaultBackground();
  }

  // ===========================================================
  // DEFAULT BACKGROUND
  // ===========================================================

  Widget _defaultBackground() {
    return Image.asset(
      "assets/png/image.png",
      fit: BoxFit.cover,

      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return Container(
          color: Colors.black,
        );
      },
    );
  }
}