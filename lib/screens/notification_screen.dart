import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/notification_service.dart';

class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  Future<void> _enableNotifications() async {
    bool granted =
        await NotificationService.requestPermission();

    if (granted) {
      Get.snackbar(
        "Success",
        "Notifications turned on",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      String? token =
          await NotificationService.getToken();

      print("FCM Token: $token");

      Future.delayed(
        const Duration(seconds: 1),
        () => Get.offAllNamed('/home'),
      );
    } else {
      Get.snackbar(
        "Permission Denied",
        "Notification permission not granted",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _skipNotifications() {
    Get.snackbar(
      "Reminder",
      "You can enable notifications later from Settings",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(
      const Duration(seconds: 1),
      () => Get.offAllNamed('/home'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .88,
          height: MediaQuery.of(context).size.height * .75,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xff1F1F22),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              const Spacer(),

              const Icon(
                Icons.notifications_none_rounded,
                size: 90,
                color: Color(0xff4F6EF7),
              ),

              const SizedBox(height: 35),

              const Text(
                "Keep track of\neverything",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                "Get reminded when it's time to\ncomplete a task.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  onPressed: _enableNotifications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xff4F6EF7),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    "Turn on notifications",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: _skipNotifications,
                child: const Text(
                  "Not now",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}