import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import 'package:todo_list/controller/task_controller.dart';
import 'package:todo_list/services/task_pdf_service.dart';

class PrintListScreen extends StatefulWidget {
  final String category;

  const PrintListScreen({
    super.key,
    required this.category,
  });

  @override
  State<PrintListScreen> createState() =>
      _PrintListScreenState();
}

class _PrintListScreenState
    extends State<PrintListScreen> {

  final TaskController controller =
      Get.find<TaskController>();

  bool isPrinting = false;
  bool isSharing = false;

  // ============================================================
  // GET TASKS
  // ============================================================

  Future<List<QueryDocumentSnapshot>> _getTasks() async {
    final snapshot =
        await controller
            .getTasks(widget.category)
            .first;

    return snapshot.docs;
  }

  // ============================================================
  // PRINT
  // ============================================================

  Future<void> _printTasks() async {
    if (isPrinting) return;

    setState(() {
      isPrinting = true;
    });

    try {
      final tasks = await _getTasks();

      final pdfBytes =
          await TaskPdfService.generateTaskPdf(
        tasks: tasks,
        category: widget.category,
      );

      await Printing.layoutPdf(
        onLayout: (format) async {
          return pdfBytes;
        },
      );
    } catch (e) {
      Get.snackbar(
        "Print Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          isPrinting = false;
        });
      }
    }
  }

  // ============================================================
  // SEND COPY
  // ============================================================

  Future<void> _sendCopy() async {
    if (isSharing) return;

    setState(() {
      isSharing = true;
    });

    try {
      final tasks = await _getTasks();

      final pdfBytes =
          await TaskPdfService.generateTaskPdf(
        tasks: tasks,
        category: widget.category,
      );

      final fileName =
          "${widget.category.toLowerCase().replaceAll(
                " ",
                "_",
              )}_tasks.pdf";

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: fileName,
      );
    } catch (e) {
      Get.snackbar(
        "Share Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) {
        setState(() {
          isSharing = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final date =
        DateFormat(
          "EEEE, d MMMM yyyy",
        ).format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFF101010),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF101010),

        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),

          onPressed: () {
            Get.back();
          },
        ),

        title: const Text(
          "Print List",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: FutureBuilder<
            List<QueryDocumentSnapshot>>(
          future: _getTasks(),

          builder: (
            context,
            snapshot,
          ) {

            // ==================================================
            // LOADING
            // ==================================================

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }

            // ==================================================
            // ERROR
            // ==================================================

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(25),

                  child: Text(
                    "Unable to load tasks\n\n${snapshot.error}",
                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            final tasks =
                snapshot.data ?? [];

            // ==================================================
            // MAIN CONTENT
            // ==================================================

            return Column(
              children: [

                // ==============================================
                // HEADER
                // ==============================================

                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(
                    20,
                    20,
                    20,
                    10,
                  ),

                  child: Column(
                    children: [

                      Text(
                        widget.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 15),

                      // ========================================
                      // TASK COUNT
                      // ========================================

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),

                        decoration: BoxDecoration(
                          color:
                              Colors.white10,
                          borderRadius:
                              BorderRadius.circular(
                            20,
                          ),
                        ),

                        child: Text(
                          "${tasks.length} ${tasks.length == 1 ? "Task" : "Tasks"}",
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ==============================================
                // PREVIEW
                // ==============================================

                Expanded(
                  child: tasks.isEmpty
                      ? _emptyState()
                      : ListView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(
                            16,
                            10,
                            16,
                            150,
                          ),

                          itemCount:
                              tasks.length,

                          itemBuilder:
                              (context, index) {

                            final task =
                                tasks[index];

                            final data =
                                task.data()
                                    as Map<String,
                                        dynamic>;

                            return _taskPreviewCard(
                              index: index + 1,
                              data: data,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),

      // ========================================================
      // BOTTOM ACTIONS
      // ========================================================

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            16,
          ),

          decoration: const BoxDecoration(
            color: Color(0xFF181818),

            border: Border(
              top: BorderSide(
                color: Colors.white10,
              ),
            ),
          ),

          child: Row(
            children: [

              // ================================================
              // PRINT
              // ================================================

              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      isPrinting
                          ? null
                          : _printTasks,

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.white,
                    foregroundColor:
                        Colors.black,

                    disabledBackgroundColor:
                        Colors.white24,

                    disabledForegroundColor:
                        Colors.white54,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 16,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),

                  icon: isPrinting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.print_outlined,
                        ),

                  label: Text(
                    isPrinting
                        ? "Printing..."
                        : "Print",
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // ================================================
              // SEND COPY
              // ================================================

              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      isSharing
                          ? null
                          : _sendCopy,

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        Colors.white,

                    side:
                        const BorderSide(
                      color: Colors.white30,
                    ),

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 16,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),

                  icon: isSharing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.share_outlined,
                        ),

                  label: Text(
                    isSharing
                        ? "Sharing..."
                        : "Send a Copy",
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TASK PREVIEW CARD
  // ============================================================

  Widget _taskPreviewCard({
    required int index,
    required Map<String, dynamic> data,
  }) {
    final String title =
        data["title"] ?? "Untitled Task";

    final String description =
        data["description"] ?? "";

    final bool completed =
        data["completed"] ?? false;

    final String category =
        data["category"] ?? widget.category;

    return Container(
      margin:
          const EdgeInsets.only(bottom: 10),

      padding:
          const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),

        borderRadius:
            BorderRadius.circular(15),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          // ====================================================
          // NUMBER
          // ====================================================

          Container(
            width: 32,
            height: 32,

            alignment:
                Alignment.center,

            decoration: BoxDecoration(
              color:
                  completed
                      ? Colors.green
                      : Colors.white12,

              shape: BoxShape.circle,
            ),

            child: completed
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 18,
                  )
                : Text(
                    "$index",
                    style:
                        const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
          ),

          const SizedBox(width: 12),

          // ====================================================
          // CONTENT
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        title,
                        style:
                            TextStyle(
                          color:
                              Colors.white,

                          fontSize: 16,

                          fontWeight:
                              FontWeight.w600,

                          decoration:
                              completed
                                  ? TextDecoration
                                      .lineThrough
                                  : null,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            completed
                                ? Colors.green
                                    .withOpacity(
                                    0.15,
                                  )
                                : Colors.orange
                                    .withOpacity(
                                    0.15,
                                  ),

                        borderRadius:
                            BorderRadius.circular(
                          8,
                        ),
                      ),

                      child: Text(
                        completed
                            ? "Done"
                            : "Pending",

                        style:
                            TextStyle(
                          color:
                              completed
                                  ? Colors.green
                                  : Colors.orange,

                          fontSize: 11,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                if (description.isNotEmpty) ...[
                  const SizedBox(height: 6),

                  Text(
                    description,
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,

                    style:
                        const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],

                const SizedBox(height: 7),

                Text(
                  category,
                  style:
                      const TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Container(
            width: 80,
            height: 80,

            decoration: BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.print_disabled_outlined,
              color: Colors.white54,
              size: 40,
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            "No Tasks to Print",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            "Add some tasks to this list\n"
            "before printing.",
            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}