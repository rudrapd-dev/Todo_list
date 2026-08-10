
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/changetheme_screen.dart';

class ListOptionsSheet extends StatelessWidget {
  final String category;

  const ListOptionsSheet({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 500,
        decoration: const BoxDecoration(
          color: Color(0xFF1F1F1F),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  const Spacer(),

                  const Text(
                    "List Options",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
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

            const Divider(
              color: Colors.white12,
            ),

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
                    onTap: () {
                      Get.snackbar(
                        "Sort",
                        "Coming Soon",
                      );
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
      () => ThemeSelectorScreen(
        category: category,
      ),
      transition: Transition.rightToLeft,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
  },
),

                  /// Duplicate
                  _optionTile(
                    icon: Icons.copy_outlined,
                    title: "Duplicate List",
                    onTap: () {
                      Get.snackbar(
                        "Duplicate",
                        "Coming Soon",
                      );
                    },
                  ),

                  /// Print
                  _optionTile(
                    icon: Icons.print_outlined,
                    title: "Print List",
                    onTap: () {
                      Get.snackbar(
                        "Print",
                        "Coming Soon",
                      );
                    },
                  ),

                  /// Share
                  _optionTile(
                    icon: Icons.share_outlined,
                    title: "Send a Copy",
                    onTap: () {
                      Get.snackbar(
                        "Share",
                        "Coming Soon",
                      );
                    },
                  ),

                  const Divider(
                    color: Colors.white12,
                    height: 30,
                  ),

                  /// Rename
                  _optionTile(
                    icon: Icons.edit_outlined,
                    title: "Rename List",
                    iconColor: Colors.orange,
                    textColor: Colors.orange,
                    onTap: () {
                      Get.back();
                      _showRenameDialog(context);
                    },
                  ),

                  /// Delete
                  _optionTile(
                    icon: Icons.delete_outline,
                    title: "Delete List",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    onTap: () {
                      Get.back();

                      Get.defaultDialog(
                        backgroundColor: const Color(0xFF2A2A2A),
                        title: "Delete List",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        middleText:
                            "Are you sure you want to delete $category?",
                        middleTextStyle: const TextStyle(
                          color: Colors.white70,
                        ),
                        textCancel: "Cancel",
                        textConfirm: "Delete",
                        cancelTextColor: Colors.white,
                        confirmTextColor: Colors.white,
                        buttonColor: Colors.red,
                        onConfirm: () {
                          Get.back();

                          Get.snackbar(
                            "Deleted",
                            "$category deleted",
                            snackPosition:
                                SnackPosition.BOTTOM,
                          );

                          // TODO:
                          // Add your Firestore delete logic here.
                        },
                      );
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

        leading: Icon(
          icon,
          color: iconColor,
          size: 28,
        ),

        title: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),

        trailing: showArrow
            ? const Icon(
                Icons.chevron_right,
                color: Colors.white54,
                size: 30,
              )
            : null,

        onTap: onTap,
      ),
    );
  }

  /// Rename Dialog
  void _showRenameDialog(BuildContext context) {
    final TextEditingController controller =
        TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),

        title: const Text(
          "Rename List",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        content: TextField(
          controller: controller,
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: "New list name",
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Colors.white24,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF4E7BFF),
              ),
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4E7BFF),
            ),
            onPressed: () {
              final String newName =
                  controller.text.trim();

              if (newName.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Please enter a list name",
                  snackPosition:
                      SnackPosition.BOTTOM,
                );
                return;
              }

              Get.back();

              Get.snackbar(
                "Success",
                "List renamed to $newName",
                snackPosition:
                    SnackPosition.BOTTOM,
              );

              // TODO:
              // Add your Firestore rename logic here.
            },
            child: const Text(
              "Save",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

