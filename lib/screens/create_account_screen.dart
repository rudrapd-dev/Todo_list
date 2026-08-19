import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controller/auth_controller.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final AuthController controller =
      Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 20,
            ),

            child: Column(
              children: [
                const SizedBox(height: 30),

                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Create account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Create your account to get started",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 17,
                  ),
                ),

                const SizedBox(height: 40),

                // Name
                TextField(
                  controller: controller.nameController,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                  textInputAction:
                      TextInputAction.next,

                  decoration: InputDecoration(
                    hintText: "Name",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.black,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey.shade800,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Email
                TextField(
                  controller:
                      controller.emailController,
                  keyboardType:
                      TextInputType.emailAddress,
                  textInputAction:
                      TextInputAction.next,
                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.black,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),

                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey.shade800,
                      ),
                    ),

                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                      borderSide:
                          const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Password
                Obx(
                  () => TextField(
                    controller:
                        controller.passwordController,
                    obscureText:
                        !controller.showPassword.value,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),

                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.showPassword
                                  .value =
                              !controller
                                  .showPassword
                                  .value;
                        },

                        icon: Icon(
                          controller
                                  .showPassword
                                  .value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),

                      filled: true,
                      fillColor: Colors.black,

                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color:
                              Colors.grey.shade800,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Password
                Obx(
                  () => TextField(
                    controller:
                        controller
                            .confirmPasswordController,
                    obscureText:
                        !controller
                            .showConfirmPassword
                            .value,
                    style: const TextStyle(
                      color: Colors.white,
                    ),

                    decoration: InputDecoration(
                      hintText: "Confirm password",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),

                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),

                      suffixIcon: IconButton(
                        onPressed: () {
                          controller
                                  .showConfirmPassword
                                  .value =
                              !controller
                                  .showConfirmPassword
                                  .value;
                        },

                        icon: Icon(
                          controller
                                  .showConfirmPassword
                                  .value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),

                      filled: true,
                      fillColor: Colors.black,

                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color:
                              Colors.grey.shade800,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  "By creating an account, you agree to our terms and privacy policy.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 30),

                // Create Account button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 60,

                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () {
                                  controller
                                      .register();
                                },

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                          0xffF2EEF8,
                        ),

                        disabledBackgroundColor:
                            Colors.grey.shade800,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            30,
                          ),
                        ),
                      ),

                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    color:
                                        Color(
                                      0xff6554C0,
                                    ),
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}