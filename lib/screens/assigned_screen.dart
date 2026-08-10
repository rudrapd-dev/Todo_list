import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens_common/category_screen.dart';

class AssignedScreen extends StatelessWidget {
  const AssignedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryScreen(
      title: "Assigned to me",
      category: "Assigned",
      titleColor: const Color(0xffA8D5C2),

      emptyWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/png/assigned.png",
              height: 140,
            ),

            const SizedBox(height: 20),

            const Text(
              "Tasks assigned to you in To Do or Planner\n"
              "show up here",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xffA8D5C2),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}