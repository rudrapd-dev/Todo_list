import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class TaskController extends GetxController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth auth =
      FirebaseAuth.instance;

  final Uuid uuid = Uuid();

  String get uid => auth.currentUser!.uid;

  /// ================= ADD TASK =================
  Future<void> addTask({
  required String title,
  required String description,
  required String category,
  required DateTime dueDate,
}) async {
  final id = uuid.v1();

  await firestore.collection('tasks').doc(id).set({
    'uid': id,
    'title': title,
    'description': description,
    'category': category,
    'completed': false,
    'isDeleted': false,
    'createdAt': Timestamp.now(),
    'deletedAt': null,
    'userUid': uid,
    'dueDate': Timestamp.fromDate(dueDate),
  });
}

  /// ================= CATEGORY TASKS =================
  Stream<QuerySnapshot> getTasks(
    String category,
  ) {
    return firestore
        .collection('tasks')
        .where(
          'category',
          isEqualTo: category,
        )
        .where(
          'userUid',
          isEqualTo: uid,
        )
        .where(
          'isDeleted',
          isEqualTo: false,
        )
        .snapshots();
  }

  /// ================= PLANNED TASKS =================
  Stream<QuerySnapshot> getPlannedTasks() {
    return firestore
        .collection('tasks')
        .where(
          'category',
          isEqualTo: 'Planned',
        )
        .where(
          'userUid',
          isEqualTo: uid,
        )
        .where(
          'isDeleted',
          isEqualTo: false,
        )
        .orderBy('dueDate')
        .snapshots();
  }

  /// ================= TASKS FOR A SPECIFIC DATE =================
  Stream<QuerySnapshot> getTasksByDate(
    DateTime day,
  ) {
    final start = DateTime(
      day.year,
      day.month,
      day.day,
    );

    final end = start.add(
      const Duration(days: 1),
    );

    return firestore
        .collection('tasks')
        .where(
          'category',
          isEqualTo: 'Planned',
        )
        .where(
          'userUid',
          isEqualTo: uid,
        )
        .where(
          'isDeleted',
          isEqualTo: false,
        )
        .where(
          'dueDate',
          isGreaterThanOrEqualTo:
              Timestamp.fromDate(start),
        )
        .where(
          'dueDate',
          isLessThan:
              Timestamp.fromDate(end),
        )
        .snapshots();
  }

  /// ================= TOGGLE COMPLETE =================
  Future<void> toggleTask(
    String taskId,
    bool completed,
  ) async {
    try {
      await firestore
          .collection('tasks')
          .doc(taskId)
          .update({
        'completed': !completed,
      });
    } catch (e) {
      print(e);
    }
  }

  /// ================= MOVE TO TRASH =================
  Future<void> deleteTask(
    String taskId,
  ) async {
    try {
      await firestore
          .collection('tasks')
          .doc(taskId)
          .update({
        'isDeleted': true,
        'deletedAt': Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  /// ================= RESTORE =================
  Future<void> restoreTask(
    String taskId,
  ) async {
    try {
      await firestore
          .collection('tasks')
          .doc(taskId)
          .update({
        'isDeleted': false,
        'deletedAt': null,
      });
    } catch (e) {
      print(e);
    }
  }

  /// ================= DELETE FOREVER =================
  Future<void> permanentlyDeleteTask(
    String taskId,
  ) async {
    try {
      await firestore
          .collection('tasks')
          .doc(taskId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  /// ================= TRASH =================
  Stream<QuerySnapshot> getDeletedTasks() {
    return firestore
        .collection('tasks')
        .where(
          'userUid',
          isEqualTo: uid,
        )
        .where(
          'isDeleted',
          isEqualTo: true,
        )
        .snapshots();
  }
}