import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  String get uid =>
      FirebaseAuth.instance.currentUser!.uid;

  /// Create List
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

  /// Get User Lists
  Stream<QuerySnapshot> getLists() {
    return firestore
        .collection('lists')
        .where('userUid', isEqualTo: uid)
        .orderBy('createdAt')
        .snapshots();
  }

  /// Delete List
  Future<void> deleteList(String listId) async {
  try {
    final listDoc = await firestore
        .collection('lists')
        .doc(listId)
        .get();

    final category = listDoc['name'];

    final tasks = await firestore
        .collection('tasks')
        .where('category', isEqualTo: category)
        .where('userUid', isEqualTo: uid)
        .get();

    for (final task in tasks.docs) {
      await task.reference.delete();
    }

    await firestore
        .collection('lists')
        .doc(listId)
        .delete();

  } catch (e) {
    print(e);
  }
}

  /// Rename List
  Future<void> renameList({
    required String listId,
    required String newName,
  }) async {
    try {
      await firestore
          .collection('lists')
          .doc(listId)
          .update({
        'name': newName,
      });

      Get.snackbar(
        "Success",
        "List renamed",
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
      );
    }
  }
}