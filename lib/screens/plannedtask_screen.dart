import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_list/controller/weather_controller.dart';

import '../controller/task_controller.dart';
import '../controller/theme_controller.dart';
import '../screens_common/add_task_screen.dart';
import '../screens_common/list_options_sheet.dart';

class PlannedScreen extends StatefulWidget {
  const PlannedScreen({super.key});

  @override
  State<PlannedScreen> createState() => _PlannedScreenState();
}

class _PlannedScreenState extends State<PlannedScreen> {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  final TaskController controller =
      Get.find<TaskController>();

  final ThemeController themeController =
      Get.find<ThemeController>();
      final WeatherController weatherController =
    Get.find<WeatherController>();

  // ==========================================================
  // CALENDAR
  // ==========================================================

  DateTime focusedDay = DateTime.now();

  DateTime selectedDay = DateTime.now();

  // ==========================================================
  // EXPANDED TASKS
  // ==========================================================

  final Set<String> expandedTasks = <String>{};

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ======================================================
      // ADD TASK BUTTON
      // ======================================================

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
              category: "Planned",
              selectedDate: selectedDay,
            ),
          );
        },
      ),

      // ======================================================
      // BODY WITH THEME BACKGROUND
      // ======================================================

      body: Obx(
        () {
          return Stack(
            fit: StackFit.expand,
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
              // ACTUAL SCREEN
              // ==================================================

              SafeArea(
                child: Column(
                  children: [

                    // ============================================
                    // HEADER
                    // ============================================

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
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
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Spacer(),

                          // Three dots
                          IconButton(
                            onPressed: () {
                              Get.bottomSheet(
                                const ListOptionsSheet(
                                  category: "Planned",
                                ),
                                isScrollControlled: true,
                                backgroundColor:
                                    Colors.transparent,
                              );
                            },
                            icon: const Icon(
                              Icons.more_horiz,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ============================================
                    // TITLE
                    // ============================================

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 25,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Planned",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // ============================================
                    // DATE
                    // ============================================

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        child: Text(
                          DateFormat(
                            'EEEE, d MMMM',
                          ).format(selectedDay),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        
                      ),
                    ),

                    const SizedBox(height: 12),
                    Obx(() {
  final weather = weatherController.weatherData.value;

  if (weather == null) {
    return const Text(
      "Loading weather...",
      style: TextStyle(
        color: Colors.white54,
        fontSize: 17,
      ),
    );
  }

  return Text(
    "${weather['main']['temp'].toStringAsFixed(1)}°C • "
    "${weather['weather'][0]['description']}",
    style: const TextStyle(
      color: Colors.white70,
      fontSize: 17,
    ),
  );
}),

                    // ============================================
                    // FIRESTORE TASKS
                    // ============================================

                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: controller.getPlannedTasks(),

                        builder: (
                          context,
                          snapshot,
                        ) {

                          // ======================================
                          // ERROR
                          // ======================================

                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(20),
                                child: Text(
                                  snapshot.error.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          }

                          // ======================================
                          // LOADING
                          // ======================================

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          // ======================================
                          // DOCUMENTS
                          // ======================================

                          final docs =
                              snapshot.data?.docs ?? [];

                          // ======================================
                          // TASKS FOR SELECTED DATE
                          // ======================================

                          final selectedTasks =
                              docs.where((doc) {

                            final data =
                                doc.data()
                                    as Map<String, dynamic>;

                            if (data["dueDate"] == null) {
                              return false;
                            }

                            final dynamic dueDateValue =
                                data["dueDate"];

                            if (dueDateValue
                                is! Timestamp) {
                              return false;
                            }

                            final DateTime dueDate =
                                dueDateValue.toDate();

                            return isSameDay(
                              dueDate,
                              selectedDay,
                            );
                          }).toList();

                          return Column(
                            children: [

                              // ==================================
                              // CALENDAR
                              // ==================================

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: TableCalendar<
                                    QueryDocumentSnapshot>(
                                  firstDay: DateTime.utc(
                                    2025,
                                    1,
                                    1,
                                  ),

                                  lastDay: DateTime.utc(
                                    2035,
                                    12,
                                    31,
                                  ),

                                  focusedDay: focusedDay,

                                  selectedDayPredicate:
                                      (day) {
                                    return isSameDay(
                                      day,
                                      selectedDay,
                                    );
                                  },

                                  // ================================
                                  // DAY SELECT
                                  // ================================

                                  onDaySelected:
                                      (
                                    selected,
                                    focused,
                                  ) {
                                    setState(() {
                                      selectedDay =
                                          selected;

                                      focusedDay =
                                          focused;
                                    });
                                  },

                                  // ================================
                                  // TASK MARKERS
                                  // ================================

                                  eventLoader: (day) {

                                    return docs
                                        .where((doc) {

                                      final data =
                                          doc.data()
                                              as Map<
                                                  String,
                                                  dynamic>;

                                      if (data[
                                              "dueDate"] ==
                                          null) {
                                        return false;
                                      }

                                      final dynamic
                                          dueDateValue =
                                          data["dueDate"];

                                      if (dueDateValue
                                          is! Timestamp) {
                                        return false;
                                      }

                                      final DateTime
                                          dueDate =
                                          dueDateValue
                                              .toDate();

                                      return isSameDay(
                                        day,
                                        dueDate,
                                      );
                                    }).toList();
                                  },

                                  // ================================
                                  // CALENDAR STYLE
                                  // ================================

                                  calendarStyle:
                                      const CalendarStyle(

                                    todayDecoration:
                                        BoxDecoration(
                                      color: Colors.blue,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    selectedDecoration:
                                        BoxDecoration(
                                      color: Colors.orange,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    markerDecoration:
                                        BoxDecoration(
                                      color: Colors.red,
                                      shape:
                                          BoxShape.circle,
                                    ),

                                    defaultTextStyle:
                                        TextStyle(
                                      color:
                                          Colors.white,
                                    ),

                                    weekendTextStyle:
                                        TextStyle(
                                      color:
                                          Colors.white70,
                                    ),

                                    outsideTextStyle:
                                        TextStyle(
                                      color:
                                          Colors.white24,
                                    ),

                                    todayTextStyle:
                                        TextStyle(
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    selectedTextStyle:
                                        TextStyle(
                                      color:
                                          Colors.white,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  // ================================
                                  // HEADER
                                  // ================================

                                  headerStyle:
                                      const HeaderStyle(

                                    titleTextStyle:
                                        TextStyle(
                                      color:
                                          Colors.white,
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),

                                    formatButtonVisible:
                                        false,

                                    leftChevronIcon:
                                        Icon(
                                      Icons.chevron_left,
                                      color:
                                          Colors.white,
                                    ),

                                    rightChevronIcon:
                                        Icon(
                                      Icons.chevron_right,
                                      color:
                                          Colors.white,
                                    ),
                                  ),
                                ),
                              ),

                              // ==================================
                              // DIVIDER
                              // ==================================

                              const Divider(
                                color: Colors.white24,
                              ),

                              // ==================================
                              // SELECTED DATE TASKS
                              // ==================================

                              Expanded(
                                child:
                                    selectedTasks.isEmpty
                                        ? _emptyTasks()
                                        : ListView.builder(
                                            padding:
                                                const EdgeInsets
                                                    .only(
                                              bottom: 100,
                                            ),

                                            itemCount:
                                                selectedTasks
                                                    .length,

                                            itemBuilder:
                                                (
                                              context,
                                              index,
                                            ) {
                                              return _buildTaskCard(
                                                selectedTasks[
                                                    index],
                                              );
                                            },
                                          ),
                              ),
                            ],
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

  // ==========================================================
  // BUILD BACKGROUND
  // ==========================================================

  Widget _buildBackground() {

    // ========================================================
    // 1. CUSTOM IMAGE
    // ========================================================

    final String? imagePath =
        themeController.selectedImages["Planned"];

    if (imagePath != null &&
        imagePath.isNotEmpty) {

      final File imageFile =
          File(imagePath);

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

    // ========================================================
    // 2. DEFAULT THEME
    // ========================================================

    final String? theme =
        themeController.selectedThemes["Planned"];

    if (theme != null &&
        theme.isNotEmpty) {

      return Image.asset(
        theme,
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

    // ========================================================
    // 3. DEFAULT BACKGROUND
    // ========================================================

    return _defaultBackground();
  }

  // ==========================================================
  // DEFAULT BACKGROUND
  // ==========================================================

  Widget _defaultBackground() {
    return Container(
      color: Colors.black,
    );
  }

  // ==========================================================
  // EMPTY TASK VIEW
  // ==========================================================

  Widget _emptyTasks() {
    return const Center(
      child: Text(
        "No Tasks",
        style: TextStyle(
          color: Colors.white54,
          fontSize: 18,
        ),
      ),
    );
  }

  // ==========================================================
  // TASK CARD
  // ==========================================================

  Widget _buildTaskCard(
    QueryDocumentSnapshot doc,
  ) {

    final data =
        doc.data()
            as Map<String, dynamic>;

    // ========================================================
    // DUE DATE
    // ========================================================

    DateTime dueDate =
        DateTime.now();

    if (data["dueDate"] is Timestamp) {
      dueDate =
          (data["dueDate"] as Timestamp)
              .toDate();
    }

    // ========================================================
    // COMPLETED
    // ========================================================

    final bool completed =
        data["completed"] ?? false;

    // ========================================================
    // EXPANDED
    // ========================================================

    final bool isExpanded =
        expandedTasks.contains(doc.id);

    return Card(
      color: Colors.grey.shade900.withOpacity(0.90),

      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      elevation: 3,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),

      child: Column(
        children: [

          // ====================================================
          // TASK TILE
          // ====================================================

          ListTile(

            leading: Checkbox(
              value: completed,

              activeColor: Colors.orange,

              onChanged: (value) async {

                await controller.toggleTask(
                  doc.id,
                  completed,
                );
              },
            ),

            title: Text(
              data["title"] ?? "",

              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,

                decoration: completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),

              child: Text(
                "Due: ${DateFormat('dd MMM yyyy').format(dueDate)}",

                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),
            ),

            trailing: Row(
              mainAxisSize: MainAxisSize.min,

              children: [

                // ============================================
                // EXPAND / COLLAPSE
                // ============================================

                IconButton(
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,

                    color: Colors.white,
                  ),

                  onPressed: () {

                    setState(() {

                      if (isExpanded) {
                        expandedTasks.remove(
                          doc.id,
                        );
                      } else {
                        expandedTasks.add(
                          doc.id,
                        );
                      }
                    });
                  },
                ),

                // ============================================
                // DELETE
                // ============================================

                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),

                  onPressed: () async {

                    await controller.deleteTask(
                      doc.id,
                    );
                  },
                ),
              ],
            ),
          ),

          // ====================================================
          // DESCRIPTION
          // ====================================================

          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                0,
                20,
                20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Divider(
                    color: Colors.white24,
                  ),

                  const Text(
                    "Description",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    (data["description"] ??
                            "")
                        .toString()
                        .trim()
                        .isEmpty
                        ? "No description added."
                        : data["description"]
                            .toString(),

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}