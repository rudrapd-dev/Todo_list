import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:todo_list/widgest/task_tile.dart';

import '../controller/task_controller.dart';
import '../controller/theme_controller.dart';
import '../controller/weather_controller.dart';
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

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TaskController controller =
      Get.find<TaskController>();

  final ThemeController themeController =
      Get.find<ThemeController>();

  final WeatherController weatherController =
      Get.find<WeatherController>();

  @override
  Widget build(BuildContext context) {
    // ==========================================================
    // DATE
    // ==========================================================

    final String today =
        DateFormat('EEEE, d MMMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.black,

      // ========================================================
      // FLOATING ACTION BUTTON
      // ========================================================

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.grey.shade900,

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
              category: category,
            ),
          );
        },
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Obx(
        () {
          return Stack(
            children: [

              // ==================================================
              // BACKGROUND THEME
              // ==================================================

              Positioned.fill(
                child: _buildBackground(),
              ),

              // ==================================================
              // DARK OVERLAY
              // ==================================================

              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.45),
                ),
              ),

              // ==================================================
              // SCREEN CONTENT
              // ==================================================

              SafeArea(
                child: Column(
                  children: [

                    // ==========================================
                    // HEADER
                    // ==========================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),

                      child: Row(
                        children: [

                          // ------------------------------------
                          // BACK BUTTON
                          // ------------------------------------

                          IconButton(
                            onPressed: () {
                              Get.back();
                            },

                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),

                          // ------------------------------------
                          // LISTS TEXT
                          // ------------------------------------

                          const Text(
                            "Lists",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),

                          const Spacer(),

                          // ------------------------------------
                          // OPTIONS BUTTON
                          // ------------------------------------

                          IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                ListOptionsSheet(
                                  category: category,
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

                    // ==========================================
                    // CATEGORY TITLE
                    // ==========================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // ------------------------------------
                          // TITLE
                          // ------------------------------------

                          Align(
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

                          const SizedBox(height: 4),

                          // ------------------------------------
                          // DAY + DATE + MONTH
                          // ------------------------------------

                          Align(
                            alignment: Alignment.centerLeft,

                            child: Text(
                              today,

                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          const SizedBox(height: 7),

                          // ------------------------------------
                          // WEATHER
                          // ------------------------------------

                          Obx(
                            () {
                              final weather =
                                  weatherController
                                      .weatherData
                                      .value;

                              if (weather == null) {
                                return const Text(
                                  "Loading weather...",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 16,
                                  ),
                                );
                              }

                              final temperature =
                                  weather['main']['temp'];

                              final description =
                                  weather['weather'][0]
                                      ['description'];

                              return Row(
                                children: [

                                  const Icon(
                                    Icons.cloud_outlined,
                                    color: Colors.white70,
                                    size: 20,
                                  ),

                                  const SizedBox(width: 7),

                                  Text(
                                    "${temperature.toStringAsFixed(1)}°C",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.w500,
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    "• $description",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // ==========================================
                    // OPTIONAL TOP WIDGET
                    // ==========================================

                    if (topWidget != null)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: topWidget!,
                      ),

                    const SizedBox(height: 10),

                    // ==========================================
                    // TASK LIST
                    // ==========================================

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: controller.getTasks(
                          category,
                        ),

                        builder: (
                          context,
                          snapshot,
                        ) {

                          // ------------------------------------
                          // LOADING
                          // ------------------------------------

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child:
                                  CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          // ------------------------------------
                          // ERROR
                          // ------------------------------------

                          if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                "Something went wrong",

                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }

                          // ------------------------------------
                          // NO DATA / EMPTY
                          // ------------------------------------

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

                          // ------------------------------------
                          // TASKS
                          // ------------------------------------

                          final tasks =
                              snapshot.data!.docs;

                          return ListView.builder(
                            padding:
                                const EdgeInsets.only(
                              bottom: 90,
                              top: 5,
                            ),

                            itemCount: tasks.length,

                            itemBuilder:
                                (context, index) {

                              final task =
                                  tasks[index];

                              // Safely get Firestore data
                              final data =
                                  task.data()
                                      as Map<String, dynamic>;

                              return TaskTile(
                                taskId: task.id,

                                title:
                                    data["title"] ?? "",

                                description:
                                    data["description"] ??
                                        "",

                                completed:
                                    data["completed"] ??
                                        false,

                                category: category,
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

  // ============================================================
  // BUILD CATEGORY BACKGROUND
  // ============================================================

  Widget _buildBackground() {

    // ==========================================================
    // 1. CHECK CUSTOM IMAGE
    // ==========================================================

    final String? imagePath =
        themeController.selectedImages[category];

    if (imagePath != null &&
        imagePath.isNotEmpty) {

      final File imageFile =
          File(imagePath);

      if (imageFile.existsSync()) {
        return Image.file(
          imageFile,
          fit: BoxFit.cover,

          errorBuilder:
              (context, error, stackTrace) {
            return _defaultBackground();
          },
        );
      }
    }

    // ==========================================================
    // 2. CHECK DEFAULT THEME
    // ==========================================================

    final String? theme =
        themeController.selectedThemes[category];

    if (theme != null &&
        theme.isNotEmpty) {

      return Image.asset(
        theme,
        fit: BoxFit.cover,

        errorBuilder:
            (context, error, stackTrace) {
          return _defaultBackground();
        },
      );
    }

    // ==========================================================
    // 3. NO THEME SELECTED
    // ==========================================================

    return _defaultBackground();
  }

  // ============================================================
  // DEFAULT BLACK BACKGROUND
  // ============================================================

  Widget _defaultBackground() {
    return Container(
      color: Colors.black,
    );
  }
}