import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:todo_list/controller/auth_controller.dart';
import 'package:todo_list/controller/list_controller.dart';

import 'package:todo_list/controller/task_controller.dart';
import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/screens/account_screen.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:todo_list/screens/important_screen.dart';
import 'package:todo_list/screens/loginscreen.dart';
import 'package:todo_list/screens/my_day_screen.dart';
import 'package:todo_list/screens/plannedtask_screen.dart';
import 'package:todo_list/screens/profile_screen.dart';
import 'package:todo_list/screens/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Get.put(AuthController());
  Get.put(TaskController());
  Get.put(ListController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder.put(() => AuthController()),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),

        GetPage(name: '/login', page: () => LoginScreen()),

        GetPage(name: '/home', page: () => HomeScreen()),

        GetPage(name: '/myday', page: () => MyDayScreen()),

        GetPage(name: '/important', page: () => const ImportantScreen()),

        GetPage(name: '/planned', page: () => const PlannedScreen()),

        GetPage(name: '/account', page: () => AccountScreen()),

        GetPage(name: '/profile', page: () => ProfileScreen()),
      ],
    );
  }
}
