import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  // ============================================================
  // FIREBASE
  // ============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // TEXT CONTROLLERS
  // ============================================================

  final TextEditingController nameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  // ============================================================
  // OBSERVABLES
  // ============================================================

  RxBool isLoading = false.obs;

  RxBool showPassword = false.obs;

  RxBool showConfirmPassword = false.obs;

  // ============================================================
  // CURRENT USER
  // ============================================================

  User? get currentUser => _auth.currentUser;

  // ============================================================
  // INITIALIZATION
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        debugPrint(
          "Three seconds have passed.",
        );

        checkLoginStatus();
      },
    );
  }

  // ============================================================
  // CHECK LOGIN STATUS
  // ============================================================

  void checkLoginStatus() {
    final User? user = _auth.currentUser;

    debugPrint(
      "Current Firebase user: ${user?.email}",
    );

    if (user != null) {
      // User already logged in
      Get.offAllNamed('/home');
    } else {
      // User is not logged in
      Get.offAllNamed('/login');
    }
  }

  // ============================================================
  // LOGIN
  // ============================================================

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final String cleanEmail =
        email.trim();

    final String cleanPassword =
        password.trim();

    // -------------------------------
    // Validation
    // -------------------------------

    if (cleanEmail.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    if (cleanPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your password.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      debugPrint(
        "Attempting login for: $cleanEmail",
      );

      await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: cleanPassword,
      );

      debugPrint(
        "Login successful: ${_auth.currentUser?.uid}",
      );

      Get.snackbar(
        "Success",
        "Login successful.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

      Get.offAllNamed('/home');

    } on FirebaseAuthException catch (e) {
      debugPrint(
        "Firebase login error: ${e.code}",
      );

      String message =
          "Login failed.";

      switch (e.code) {
        case 'user-not-found':
          message =
              "No account found with this email.";
          break;

        case 'wrong-password':
          message =
              "Incorrect password.";
          break;

        case 'invalid-credential':
          message =
              "Incorrect email or password.";
          break;

        case 'invalid-email':
          message =
              "Please enter a valid email address.";
          break;

        case 'user-disabled':
          message =
              "This account has been disabled.";
          break;

        case 'too-many-requests':
          message =
              "Too many login attempts. Please try again later.";
          break;

        case 'network-request-failed':
          message =
              "Please check your internet connection.";
          break;

        default:
          message =
              e.message ?? "Login failed.";
      }

      Get.snackbar(
        "Login Failed",
        message,
        snackPosition:
            SnackPosition.BOTTOM,
      );

    } catch (e) {
      debugPrint(
        "Login error: $e",
      );

      Get.snackbar(
        "Error",
        "Something went wrong while logging in.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // REGISTER / CREATE ACCOUNT
  // ============================================================

  Future<void> register() async {
    final String name =
        nameController.text.trim();

    final String email =
        emailController.text.trim();

    final String password =
        passwordController.text.trim();

    final String confirmPassword =
        confirmPasswordController.text.trim();

    // ==========================================================
    // VALIDATION
    // ==========================================================

    if (name.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your name.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    if (email.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter a password.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.length < 6) {
      Get.snackbar(
        "Error",
        "Password must be at least 6 characters.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please confirm your password.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Passwords do not match.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    // ==========================================================
    // CREATE ACCOUNT
    // ==========================================================

    try {
      isLoading.value = true;

      debugPrint(
        "Creating Firebase account for: $email",
      );

      // --------------------------------------------------------
      // Create Firebase Authentication account
      // --------------------------------------------------------

      final UserCredential credential =
          await _auth
              .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user =
          credential.user;

      if (user == null) {
        throw Exception(
          "Firebase user could not be created.",
        );
      }

      debugPrint(
        "Firebase account created: ${user.uid}",
      );

      // --------------------------------------------------------
      // Save display name in Firebase Auth
      // --------------------------------------------------------

      await user.updateDisplayName(name);

      // --------------------------------------------------------
      // Save user information in Firestore
      // --------------------------------------------------------

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'createdAt':
            FieldValue.serverTimestamp(),
      });

      debugPrint(
        "User data saved in Firestore.",
      );

      // --------------------------------------------------------
      // Clear form
      // --------------------------------------------------------

      nameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();

      showPassword.value = false;
      showConfirmPassword.value = false;

      // --------------------------------------------------------
      // Registration successful
      // --------------------------------------------------------

      Get.snackbar(
        "Account Created",
        "Your account has been created successfully.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

      // --------------------------------------------------------
      // Go to notification screen
      // --------------------------------------------------------

      Get.offAllNamed('/notification');

    } on FirebaseAuthException catch (e) {
      debugPrint(
        "Firebase registration error: ${e.code}",
      );

      String message =
          "Registration failed.";

      switch (e.code) {
        case 'email-already-in-use':
          message =
              "An account already exists with this email.";
          break;

        case 'invalid-email':
          message =
              "Please enter a valid email address.";
          break;

        case 'weak-password':
          message =
              "Password is too weak. Use at least 6 characters.";
          break;

        case 'operation-not-allowed':
          message =
              "Email/password authentication is not enabled in Firebase.";
          break;

        case 'network-request-failed':
          message =
              "Please check your internet connection.";
          break;

        default:
          message =
              e.message ?? "Registration failed.";
      }

      Get.snackbar(
        "Registration Failed",
        message,
        snackPosition:
            SnackPosition.BOTTOM,
      );

    } catch (e) {
      debugPrint(
        "Registration error: $e",
      );

      Get.snackbar(
        "Error",
        "Something went wrong while creating your account.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

    } finally {
      isLoading.value = false;
    }
  }

  // ============================================================
  // RESET PASSWORD
  // ============================================================

  Future<void> resetPassword(
    String email,
  ) async {
    final String cleanEmail =
        email.trim();

    if (cleanEmail.isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email first.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(
        email: cleanEmail,
      );

      Get.snackbar(
        "Success",
        "Password reset email sent.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

    } on FirebaseAuthException catch (e) {
      debugPrint(
        "Password reset error: ${e.code}",
      );

      Get.snackbar(
        "Error",
        e.message ??
            "Unable to send password reset email.",
        snackPosition:
            SnackPosition.BOTTOM,
      );

    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      await _auth.signOut();

      // Clear login fields
      emailController.clear();
      passwordController.clear();

      Get.offAllNamed('/login');

    } catch (e) {
      debugPrint(
        "Logout error: $e",
      );

      Get.snackbar(
        "Error",
        "Unable to logout.",
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.onClose();
  }
}