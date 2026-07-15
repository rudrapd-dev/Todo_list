import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xff1C1C1E),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const Spacer(),

                const Icon(
                  Icons.notifications_none_rounded,
                  size: 100,
                  color: Color(0xff3B82F6),
                ),

                const SizedBox(height: 40),

                const Text(
                  "Keep track of everything",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Get reminded when it's time to complete a task.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4F6EF7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      // Request notification permission here later
                      Get.offAll(() => HomeScreen());
                    },
                    child: const Text(
                      "Turn on notifications",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                TextButton(
                  onPressed: () {
                    Get.offAll(() => HomeScreen());
                  },
                  child: const Text(
                    "Not now",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}