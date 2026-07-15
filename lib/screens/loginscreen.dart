import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController =
      Get.find<AuthController>();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final RxBool obscurePassword = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.blue,
                    size: 90,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Todo App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Organize your day efficiently",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 40),

                  TextField(
                    controller: emailController,
                    keyboardType:
                        TextInputType.emailAddress,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                      ),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white54,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Obx(
                    () => TextField(
                      controller: passwordController,
                      obscureText:
                          obscurePassword.value,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: const TextStyle(
                          color: Colors.white54,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.white54,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            obscurePassword.value =
                                !obscurePassword.value;
                          },
                          icon: Icon(
                            obscurePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white54,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade900,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () async {
                        final email =
                            emailController.text.trim();

                        final password =
                            passwordController.text.trim();

                        if (email.isEmpty ||
                            password.isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please fill all fields",
                            snackPosition:
                                SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        await authController.login(
                           email: email, password: password,
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Get.to(
                          //   () => SignupScreen(),
                          // );
                        },
                        child: const Text(
                          "Sign Up",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}