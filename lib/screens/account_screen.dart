import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controller/profile_controller.dart';
import 'package:todo_list/screens/loginscreen.dart';

import 'profile_screen.dart';

class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      final user = controller.currentUser.value;

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text("Account"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue,

                backgroundImage: user != null &&
                        user.profileImage.isNotEmpty
                    ? NetworkImage(user.profileImage)
                    : (FirebaseAuth.instance.currentUser?.photoURL != null
                        ? NetworkImage(
                            FirebaseAuth
                                .instance.currentUser!.photoURL!,
                          )
                        : null),

                child: user == null ||
                        (user.profileImage.isEmpty &&
                            FirebaseAuth.instance.currentUser?.photoURL ==
                                null)
                    ? const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 45,
                      )
                    : null,
              ),

              const SizedBox(height: 20),

              Text(
                user?.name.isNotEmpty == true
                    ? user!.name
                    : "No Name",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                user?.email ?? "No Email",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 15),

              Card(
                color: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                        title: Text(
                          user?.phone.isEmpty == true
                              ? "Not provided"
                              : user!.phone,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const Divider(),

                      ListTile(
                        leading: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        title: Text(
                          user?.bio.isEmpty == true
                              ? "No Bio"
                              : user!.bio,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  onPressed: () async {
                    await Get.to(() => ProfileScreen());

                    controller.loadUserData();
                  },
                ),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                  ),
                  onPressed: () async {
                    final confirm = await Get.dialog<bool>(
                      AlertDialog(
                        title: const Text("Logout"),
                        content: const Text(
                          "Are you sure you want to logout?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Get.back(result: false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                Get.back(result: true),
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(() => LoginScreen());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}