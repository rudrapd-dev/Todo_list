import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  String get uid =>
      FirebaseAuth.instance.currentUser!.uid;

  /// CREATE LIST
  Future<void> addList(String name) async {
    try {
      await firestore.collection('lists').add({
        'name': name,
        'userUid': uid,
        'createdAt': Timestamp.now(),
      });

      Get.snackbar(
        "Success",
        "List created successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// GET ALL USER LISTS
  Stream<QuerySnapshot> getLists() {
    return firestore
        .collection('lists')
        .where('userUid', isEqualTo: uid)
        .orderBy('createdAt')
        .snapshots();
  }

  /// DELETE LIST
  /// Moves all tasks of that list to Recently Deleted
  Future<void> deleteList(String listId) async {
    try {
      final listDoc = await firestore
          .collection('lists')
          .doc(listId)
          .get();

      if (!listDoc.exists) {
        return;
      }

      final category = listDoc['name'];

      /// Find tasks belonging to this list
      final tasks = await firestore
          .collection('tasks')
          .where('category', isEqualTo: category)
          .where('userUid', isEqualTo: uid)
          .get();

      /// Move tasks to Recently Deleted
      for (final task in tasks.docs) {
        await task.reference.update({
          'isDeleted': true,
          'deletedAt': Timestamp.now(),
        });
      }

      /// Delete the list document
      await firestore
          .collection('lists')
          .doc(listId)
          .delete();

      Get.snackbar(
        "Deleted",
        "$category deleted successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// RENAME LIST
  Future<void> renameList({
    required String listId,
    required String newName,
  }) async {
    try {
      final listDoc = await firestore
          .collection('lists')
          .doc(listId)
          .get();

      if (!listDoc.exists) return;

      final oldName = listDoc['name'];

      /// Update list name
      await firestore
          .collection('lists')
          .doc(listId)
          .update({
        'name': newName,
      });

      /// Update category of existing tasks
      final tasks = await firestore
          .collection('tasks')
          .where('category', isEqualTo: oldName)
          .where('userUid', isEqualTo: uid)
          .get();

      for (final task in tasks.docs) {
        await task.reference.update({
          'category': newName,
        });
      }

      Get.snackbar(
        "Success",
        "List renamed successfully",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }

  /// CHECK IF LIST EXISTS
  Future<bool> listExists(String name) async {
    final result = await firestore
        .collection('lists')
        .where('userUid', isEqualTo: uid)
        .where('name', isEqualTo: name)
        .get();

    return result.docs.isNotEmpty;
  }
}