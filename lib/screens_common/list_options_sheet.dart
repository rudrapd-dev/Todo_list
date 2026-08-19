import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/changetheme_screen.dart';
import 'package:todo_list/screens_common/print_list_screen.dart';
import 'package:todo_list/screens_common/sort_by.dart';

class ListOptionsSheet extends StatelessWidget {
  final String category;

  const ListOptionsSheet({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 350,
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            /// Top Handle
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Spacer(),

                  const Text(
                    "List Options",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Color(0xFF4E7BFF),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white12),

            /// Options
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  /// Sort
                  _optionTile(
                    icon: Icons.sort,
                    title: "Sort",
                    showArrow: true,
                    onTap: () async {
                      Get.back();

                      final result = await Get.to(
                        () => SortByScreen(category: category),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );

                      if (result != null) {
                        print("Selected sort: $result");

                        Get.snackbar(
                          "Sort Applied",
                          "Tasks sorted by $result",
                          snackPosition: SnackPosition.BOTTOM,
                        );

                        // TODO:
                        // Pass this value to your TaskController
                        // and sort your tasks.
                      }
                    },
                  ),

                  /// Change Theme
                  _optionTile(
                    icon: Icons.palette_outlined,
                    title: "Change Theme",
                    showArrow: true,

                    onTap: () {
                      Get.back();

                      Get.to(
                        () => ThemeSelectorScreen(category: category),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),

                  /// Print
                  _optionTile(
                    icon: Icons.print_outlined,
                    title: "Print List",
                    showArrow: true,

                    onTap: () {
                      Get.back();

                      Get.to(
                        () => PrintListScreen(category: category),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  ),

                  /// Share
                  _optionTile(
                    icon: Icons.share_outlined,
                    title: "Send a Copy",
                    onTap: () {
                      Get.snackbar("Share", "Coming Soon");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Option Tile
  Widget _optionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = false,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        tileColor: Colors.transparent,
        splashColor: Colors.white10,
        hoverColor: Colors.white10,

        leading: Icon(icon, color: iconColor, size: 28),

        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),

        trailing: showArrow
            ? const Icon(Icons.chevron_right, color: Colors.white54, size: 30)
            : null,

        onTap: onTap,
      ),
    );
  }
}
