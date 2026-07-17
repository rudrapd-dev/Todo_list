import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/splashScreen.dart';

import 'controller/auth_controller.dart';
import 'controller/list_controller.dart';
import 'controller/task_controller.dart';
import 'firebase_options.dart';

import 'screens/home_screen.dart';
import 'screens/loginscreen.dart';

import 'screens/my_day_screen.dart';
import 'screens/important_screen.dart';
import 'screens/plannedtask_screen.dart';
import 'screens/account_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Get.put(AuthController());
  Get.put(TaskController());
  Get.put(ListController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),      getPages: [
        GetPage(name: '/login', page: () => LoginScreen()),

        GetPage(
          name: '/notification',
          page: () => const NotificationPermissionScreen(),
        ),

        GetPage(name: '/home', page: () => HomeScreen()),

        GetPage(name: '/myday', page: () => MyDayScreen()),
        GetPage(name: '/important', page: () => const ImportantScreen()),

        GetPage(name: '/planned', page: () => const PlannedScreen()),

        GetPage(name: '/account', page: () => AccountScreen()),

        GetPage(name: '/profile', page: () => ProfileScreen()),
        GetPage(name: '/', page: () => Splashscreen()),
      ],
    );
  }
}
