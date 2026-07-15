import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controller/profile_controller.dart';


class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  /// Avatar
                  CircleAvatar(
                    radius: 55,
                    backgroundColor:
                        Theme.of(context).colorScheme.primary,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    controller.nameController.text,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    controller.emailController.text,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          TextField(
                            controller:
                                controller.nameController,
                            decoration: InputDecoration(
                              labelText: "Full Name",
                              prefixIcon:
                                  const Icon(Icons.person),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller:
                                controller.emailController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Email",
                              prefixIcon:
                                  const Icon(Icons.email),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller:
                                controller.phoneController,
                            keyboardType:
                                TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              prefixIcon:
                                  const Icon(Icons.phone),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller:
                                controller.bioController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: "Bio",
                              alignLabelWithHint: true,
                              prefixIcon:
                                  const Icon(Icons.info),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save),
                              label: const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              style:
                                  ElevatedButton.styleFrom(
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          12),
                                ),
                              ),
                              onPressed: () {
                                controller.updateProfile();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  Text(
                    "Your profile information is securely stored in Firebase Firestore.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}