import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Loading state
  RxBool isLoading = false.obs;

  /// Current user
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  /// Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  /// Load user information from Firestore
  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) {
        Get.snackbar(
          "Error",
          "No authenticated user found.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final doc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        final user = UserModel.fromMap(doc.data()!);

        currentUser.value = user;

        nameController.text = user.name;
        emailController.text = user.email;
        phoneController.text = user.phone;
        bioController.text = user.bio;
      } else {
        /// Create user document if it doesn't exist
        final newUser = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? "",
          email: firebaseUser.email ?? "",
          phone: "",
          bio: "",
          profileImage: "",
          createdAt: Timestamp.now(),
        );

        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());

        currentUser.value = newUser;

        nameController.text = newUser.name;
        emailController.text = newUser.email;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile information
  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      final firebaseUser = _auth.currentUser;

      if (firebaseUser == null) return;

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .update({
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'bio': bioController.text.trim(),
      });

      currentUser.value = currentUser.value?.copyWith(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        bio: bioController.text.trim(),
      );

      Get.snackbar(
        "Success",
        "Profile updated successfully.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Update Failed",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh profile
  Future<void> refreshProfile() async {
    await loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.onClose();
  }
}