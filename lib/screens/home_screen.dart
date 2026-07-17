import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/screens/recentlydeleted_screen.dart';

import '../controller/list_controller.dart';
import '../screens_common/category_screen.dart';
import 'account_screen.dart';
import 'assigned_screen.dart';
import 'flagged_screen.dart';
import 'important_screen.dart';
import 'my_day_screen.dart';
import 'plannedtask_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final User? user = FirebaseAuth.instance.currentUser;

  final ListController listController =
      Get.find<ListController>();

  final TextEditingController listNameController =
      TextEditingController();

  final List<Map<String, dynamic>> menuItems = [
    {
      "icon": Icons.wb_sunny_outlined,
      "title": "My Day",
      "color": Colors.grey,
    },
    {
      "icon": Icons.star_border,
      "title": "Important",
      "color": Colors.pinkAccent,
    },
    {
      "icon": Icons.calendar_today_outlined,
      "title": "Planned",
      "color": Colors.cyanAccent,
    },
    {
      "icon": Icons.person_outline,
      "title": "Assigned to me",
      "color": Colors.tealAccent,
    },
    {
      "icon": Icons.outlined_flag,
      "title": "Flagged email",
      "color": Colors.orangeAccent,
    },
    {
      "icon": Icons.home_outlined,
      "title": "Tasks",
      "color": Colors.indigoAccent,
    },
    {
  "icon": Icons.delete_outline,
  "title": "Recently Deleted",
  "color": Colors.redAccent,
},
  ];

  void navigateToPage(String title) {
    switch (title) {
      case "My Day":
        Get.to(() => MyDayScreen());
        break;

      case "Important":
        Get.to(() => ImportantScreen());
        break;

      case "Planned":
        Get.to(() => PlannedScreen());
        break;

      case "Assigned to me":
        Get.to(() => AssignedScreen());
        break;

      case "Flagged email":
        Get.to(() => FlaggedScreen());
        break;
      case"Recently Deleted":
        Get.to((RecentlyDeletedScreen()));
        break;

      case "Tasks":
        Get.to(
          () => CategoryScreen(
            title: "Tasks",
            category: "Tasks",
            titleColor: Colors.indigoAccent,
          ),
        );
        break;
    }
  }

  void showCreateListDialog() {
  listNameController.clear();

  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        "Create New List",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      content: TextField(
        controller: listNameController,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: "List Name",
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.white24,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          onPressed: () async {
            final name =
                listNameController.text.trim();

            if (name.isEmpty) {
              Get.snackbar(
                "Error",
                "Please enter a list name",
                snackPosition:
                    SnackPosition.BOTTOM,
              );
              return;
            }

            final exists =
                await listController.listExists(
              name,
            );

            if (exists) {
              Get.snackbar(
                "Error",
                "List already exists",
                snackPosition:
                    SnackPosition.BOTTOM,
              );
              return;
            }

            await listController.addList(name);

            listNameController.clear();

            Get.back();

            Get.snackbar(
              "Success",
              "List created successfully",
              snackPosition:
                  SnackPosition.BOTTOM,
            );
          },
          child: const Text("Create"),
        ),
      ],
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                children: [
                  /// PROFILE HEADER
                  InkWell(
                    onTap: () {
                      Get.to(
                        () =>  AccountScreen(),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor:
                              Colors.grey.shade800,
                          backgroundImage:
                              user?.photoURL != null
                                  ? NetworkImage(
                                      user!.photoURL!,
                                    )
                                  : null,
                          child: user?.photoURL == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            user?.email ?? "User",
                            overflow:
                                TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white70,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// DEFAULT LISTS
                  ...menuItems.map(
                    (item) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 25,
                      ),
                      child: InkWell(
                        onTap: () =>
                            navigateToPage(
                          item["title"],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item["icon"],
                              color: item["color"],
                              size: 34,
                            ),

                            const SizedBox(
                              width: 22,
                            ),

                            Text(
                              item["title"],
                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 24,
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Divider(
                    color: Colors.grey.shade900,
                    thickness: 2,
                  ),

                  const SizedBox(height: 20),

                  /// CUSTOM LISTS
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        listController.getLists(),
                    builder:
                        (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox();
                      }

                      final lists =
                          snapshot.data!.docs;

                      return Column(
                        children:
                            lists.map((list) {
                          return Padding(
                            padding:
                                const EdgeInsets
                                    .only(
                              bottom: 18,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(
                                        () =>
                                            CategoryScreen(
                                          title: list[
                                              'name'],
                                          category:
                                              list[
                                                  'name'],
                                          titleColor:
                                              Colors
                                                  .indigoAccent,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons
                                              .format_list_bulleted,
                                          color: Colors
                                              .indigoAccent,
                                          size: 34,
                                        ),

                                        const SizedBox(
                                          width: 22,
                                        ),

                                        Expanded(
                                          child:
                                              Text(
                                            list[
                                                'name'],
                                            style:
                                                const TextStyle(
                                              color:
                                                  Colors.white,
                                              fontSize:
                                                  22,
                                              fontWeight:
                                                  FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                IconButton(
  icon: const Icon(
    Icons.delete,
    color: Colors.red,
  ),
  onPressed: () async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: Colors.black,
        title: const Text(
          "Delete List",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          "Delete ${list['name']} ?",
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Get.back(result: false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () =>
                Get.back(result: true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await listController.deleteList(
        list.id,
      );
    }
  },
),
                                
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// BOTTOM BAR
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color:
                        Colors.grey.shade900,
                  ),
                ),
              ),
              child: InkWell(
                onTap: showCreateListDialog,
                child: Row(
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white70,
                      size: 35,
                    ),

                    const SizedBox(width: 15),

                    Text(
                      "New List",
                      style: TextStyle(
                        color:
                            Colors.grey.shade500,
                        fontSize: 22,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const Spacer(),

                    const Icon(
                      Icons.playlist_add,
                      color: Colors.white70,
                      size: 35,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}