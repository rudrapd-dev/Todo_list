import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListOptionsSheet extends StatelessWidget {
  final String category;

  const ListOptionsSheet({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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

          Container(
            width: 50,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(height: 20),

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
                  onPressed: () => Get.back(),
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

          Expanded(
            child: ListView(
              children: [
                _optionTile(
                  icon: Icons.sort,
                  title: "Sort",
                  onTap: () {
                    Get.snackbar(
                      "Sort",
                      "Coming Soon",
                    );
                  },
                  showArrow: true,
                ),

                _optionTile(
                  icon: Icons.palette_outlined,
                  title: "Change Theme",
                  onTap: () {
                    Get.snackbar(
                      "Theme",
                      "Coming Soon",
                    );
                  },
                  showArrow: true,
                ),

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

                _optionTile(
                  icon: Icons.delete_outline,
                  title: "Delete List",
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: () {
                    Get.back();

                    Get.defaultDialog(
                      title: "Delete List",
                      middleText:
                          "Are you sure you want to delete $category?",
                      textCancel: "Cancel",
                      textConfirm: "Delete",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showArrow = false,
    Color iconColor = Colors.white,
    Color textColor = Colors.white,
  }) {
    return ListTile(
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
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(
          0xFF2A2A2A,
        ),
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
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();

              Get.snackbar(
                "Success",
                "List renamed",
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}