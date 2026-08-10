import 'package:flutter/material.dart';

import '../screens_common/category_screen.dart';

class FlaggedScreen extends StatelessWidget {
  const FlaggedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CategoryScreen(
      title: "Flagged Email",
      category: "Flagged",
      titleColor: const Color(0xFFFFD7C2),

      emptyWidget: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag_outlined,
              size: 110,
              color: Colors.blue.shade300,
            ),

            const SizedBox(height: 25),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "Messages you flag will show up as tasks here.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFFD7C2),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}