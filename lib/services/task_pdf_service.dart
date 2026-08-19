import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class TaskPdfService {
  static Future<Uint8List> generateTaskPdf({
    required List<QueryDocumentSnapshot> tasks,
    required String category,
  }) async {
    final pdf = pw.Document();

    final date = DateFormat(
      'EEEE, d MMMM yyyy',
    ).format(DateTime.now());

    int completed = 0;

    for (final task in tasks) {
      final data =
          task.data() as Map<String, dynamic>;

      if (data["completed"] == true) {
        completed++;
      }
    }

    final pending = tasks.length - completed;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        margin: const pw.EdgeInsets.all(32),

        build: (context) {
          return [

            // ==================================================
            // HEADER
            // ==================================================

            pw.Row(
              mainAxisAlignment:
                  pw.MainAxisAlignment.spaceBetween,

              children: [

                pw.Column(
                  crossAxisAlignment:
                      pw.CrossAxisAlignment.start,

                  children: [

                    pw.Text(
                      "TASK LIST",
                      style: pw.TextStyle(
                        fontSize: 25,
                        fontWeight:
                            pw.FontWeight.bold,
                      ),
                    ),

                    pw.SizedBox(height: 5),

                    pw.Text(
                      category,
                      style: const pw.TextStyle(
                        fontSize: 13,
                        color:
                            PdfColors.grey700,
                      ),
                    ),
                  ],
                ),

                pw.Text(
                  date,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color:
                        PdfColors.grey700,
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            pw.Divider(),

            pw.SizedBox(height: 15),

            // ==================================================
            // SUMMARY
            // ==================================================

            pw.Row(
              children: [

                _summaryBox(
                  "TOTAL",
                  tasks.length.toString(),
                  PdfColors.black,
                ),

                pw.SizedBox(width: 10),

                _summaryBox(
                  "COMPLETED",
                  completed.toString(),
                  PdfColors.green,
                ),

                pw.SizedBox(width: 10),

                _summaryBox(
                  "PENDING",
                  pending.toString(),
                  PdfColors.orange,
                ),
              ],
            ),

            pw.SizedBox(height: 25),

            pw.Text(
              "All Tasks",
              style: pw.TextStyle(
                fontSize: 17,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 12),

            // ==================================================
            // TASKS
            // ==================================================

            if (tasks.isEmpty)
              pw.Center(
                child: pw.Padding(
                  padding:
                      const pw.EdgeInsets.all(50),

                  child: pw.Text(
                    "No tasks available",
                    style:
                        const pw.TextStyle(
                      fontSize: 16,
                      color:
                          PdfColors.grey700,
                    ),
                  ),
                ),
              ),

            ...List.generate(
              tasks.length,
              (index) {

                final data =
                    tasks[index].data()
                        as Map<String, dynamic>;

                final String title =
                    data["title"] ?? "";

                final String description =
                    data["description"] ?? "";

                final bool isCompleted =
                    data["completed"] ?? false;

                return _taskCard(
                  number: index + 1,
                  title: title,
                  description: description,
                  completed: isCompleted,
                );
              },
            ),
          ];
        },

        // ======================================================
        // FOOTER
        // ======================================================

        footer: (context) {
          return pw.Row(
            mainAxisAlignment:
                pw.MainAxisAlignment.spaceBetween,

            children: [

              pw.Text(
                "Todo List",
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey,
                ),
              ),

              pw.Text(
                "Page ${context.pageNumber}",
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // SUMMARY BOX
  // ============================================================

  static pw.Expanded _summaryBox(
    String title,
    String value,
    PdfColor color,
  ) {
    return pw.Expanded(
      child: pw.Container(
        padding:
            const pw.EdgeInsets.all(12),

        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,

          borderRadius:
              pw.BorderRadius.circular(8),

          border: pw.Border.all(
            color: PdfColors.grey300,
          ),
        ),

        child: pw.Column(
          crossAxisAlignment:
              pw.CrossAxisAlignment.start,

          children: [

            pw.Text(
              title,
              style: const pw.TextStyle(
                fontSize: 8,
                color:
                    PdfColors.grey700,
              ),
            ),

            pw.SizedBox(height: 4),

            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight:
                    pw.FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TASK CARD
  // ============================================================

  static pw.Container _taskCard({
    required int number,
    required String title,
    required String description,
    required bool completed,
  }) {
    return pw.Container(
      margin:
          const pw.EdgeInsets.only(
        bottom: 10,
      ),

      padding:
          const pw.EdgeInsets.all(12),

      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,

        borderRadius:
            pw.BorderRadius.circular(8),

        border: pw.Border.all(
          color: PdfColors.grey300,
        ),
      ),

      child: pw.Row(
        crossAxisAlignment:
            pw.CrossAxisAlignment.start,

        children: [

          // ==================================================
          // NUMBER
          // ==================================================

          pw.Container(
            width: 28,
            height: 28,

            alignment:
                pw.Alignment.center,

            decoration:
                pw.BoxDecoration(
              color: completed
                  ? PdfColors.green
                  : PdfColors.black,

              shape: pw.BoxShape.circle,
            ),

            child: pw.Text(
              number.toString(),
              style: const pw.TextStyle(
                color: PdfColors.white,
                fontSize: 10,
              ),
            ),
          ),

          pw.SizedBox(width: 12),

          // ==================================================
          // CONTENT
          // ==================================================

          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,

              children: [

                pw.Text(
                  title.isEmpty
                      ? "Untitled Task"
                      : title,

                  style: pw.TextStyle(
                    fontSize: 13,
                    fontWeight:
                        pw.FontWeight.bold,

                    decoration: completed
                        ? pw.TextDecoration
                            .lineThrough
                        : null,
                  ),
                ),

                if (description.isNotEmpty) ...[
                  pw.SizedBox(height: 5),

                  pw.Text(
                    description,
                    style:
                        const pw.TextStyle(
                      fontSize: 9,
                      color:
                          PdfColors.grey700,
                    ),
                  ),
                ],

                pw.SizedBox(height: 6),

                pw.Text(
                  completed
                      ? "COMPLETED"
                      : "PENDING",

                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight:
                        pw.FontWeight.bold,

                    color: completed
                        ? PdfColors.green
                        : PdfColors.orange,
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