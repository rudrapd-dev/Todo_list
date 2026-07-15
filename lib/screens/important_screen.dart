import 'package:flutter/material.dart';
import 'package:todo_list/screens_common/category_screen.dart';


class ImportantScreen extends StatelessWidget {
  const ImportantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryScreen(
      title: "Important",
      category: "Important",
      titleColor: Colors.pink.shade100,
      emptyWidget: const Center(
        child: Text(
          "Try starring some tasks to see them here.",
          style: TextStyle(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}