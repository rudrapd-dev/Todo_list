import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Try adding some crucial and important tasks here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}