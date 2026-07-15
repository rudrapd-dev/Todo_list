import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  User? get currentUser => _auth.currentUser;
  @override
  void onReady() {
    super.onReady();

    _auth.authStateChanges().listen((User? user) {
      Future.delayed(const Duration(seconds: 2), () {
        if (user == null) {
          Get.offAllNamed('/login');
        } else {
          Get.offAllNamed('/home');
        }
      });
    });
  }
  /// ===========================
  /// Register
  /// ===========================
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      await credential.user!.updateDisplayName(name);

      await _firestore
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'name': name,
        'email': email,
        'phone': '',
        'bio': '',
        'profileImage': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar(
        "Success",
        "Account created successfully",
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Registration failed");
    } finally {
      isLoading.value = false;
    }
  }

  /// ===========================
  /// Login
  /// ===========================
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      Get.snackbar(
        "Success",
        "Login Successful",
      );
      Get.to(HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "Login failed");
    } finally {
      isLoading.value = false;
    }
  }

  /// ===========================
  /// Google Sign In
  /// ===========================
  // Future<void> signInWithGoogle() async {
  //   try {
  //     isLoading.value = true;

  //     final GoogleSignInAccount? googleUser =
  //         await _googleSignIn.signIn();

  //     if (googleUser == null) {
  //       isLoading.value = false;
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final userCredential =
  //         await _auth.signInWithCredential(credential);

  //     final doc = _firestore
  //         .collection('users')
  //         .doc(userCredential.user!.uid);

  //     if (!(await doc.get()).exists) {
  //       await doc.set({
  //         'uid': userCredential.user!.uid,
  //         'name': userCredential.user!.displayName ?? '',
  //         'email': userCredential.user!.email ?? '',
  //         'phone': '',
  //         'bio': '',
  //         'profileImage':
  //             userCredential.user!.photoURL ?? '',
  //         'createdAt': FieldValue.serverTimestamp(),
  //       });
  //     }

  //     Get.snackbar(
  //       "Success",
  //       "Google Sign-In Successful",
  //     );
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }

  //     Get.snackbar(
  //       "Error",
  //       e.toString(),
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// ===========================
  /// Reset Password
  /// ===========================
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: email.trim(),
      );

      Get.snackbar(
        "Success",
        "Password reset email sent",
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message ?? "",
      );
    }
  }

  /// ===========================
  /// Logout
  /// ===========================
  // Future<void> logout() async {
  //   await _googleSignIn.signOut();
  //   await _auth.signOut();
  // }
}