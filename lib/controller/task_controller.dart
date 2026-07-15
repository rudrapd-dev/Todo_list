import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  String get uid =>
      FirebaseAuth.instance.currentUser!.uid;

  /// ADD TASK
  Future<void> addTask({
    required String title,
    required String description,
    required String category,
  }) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .add({
      'title': title,
      'description': description,
      'category': category,
      'completed': false,
      'createdAt': Timestamp.now(),
    });
  }

  /// SOFT DELETE TASK
  Future<void> deleteTask(String taskId) async {
    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .get();

    if (doc.exists) {
      await firestore
          .collection('users')
          .doc(uid)
          .collection('deleted_tasks')
          .doc(taskId)
          .set({
        ...doc.data()!,
        'deletedAt': Timestamp.now(),
      });

      await firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .delete();
    }
  }

  /// RESTORE TASK
  Future<void> restoreTask(
      String taskId) async {
    final doc = await firestore
        .collection('users')
        .doc(uid)
        .collection('deleted_tasks')
        .doc(taskId)
        .get();

    if (doc.exists) {
      Map<String, dynamic> data =
          doc.data()!;

      data.remove('deletedAt');

      await firestore
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .doc(taskId)
          .set(data);

      await firestore
          .collection('users')
          .doc(uid)
          .collection('deleted_tasks')
          .doc(taskId)
          .delete();
    }
  }

  /// PERMANENT DELETE
  Future<void> permanentlyDeleteTask(
      String taskId) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('deleted_tasks')
        .doc(taskId)
        .delete();
  }

  /// DELETED TASKS STREAM
  Stream<QuerySnapshot> getDeletedTasks() {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('deleted_tasks')
        .orderBy(
          'deletedAt',
          descending: true,
        )
        .snapshots();
  }

  /// TOGGLE COMPLETED
  Future<void> toggleTask(
    String taskId,
    bool completed,
  ) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .update({
      'completed': !completed,
    });
  }

  /// GET TASKS BY CATEGORY
  Stream<QuerySnapshot> getTasks(
      String category) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .where(
          'category',
          isEqualTo: category,
        )
        .orderBy(
          'createdAt',
          descending: true,
        )
        .snapshots();
  }
}