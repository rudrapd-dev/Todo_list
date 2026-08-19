import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortByScreen extends StatefulWidget {
  final String category;

  const SortByScreen({
    super.key,
    required this.category,
  });

  @override
  State<SortByScreen> createState() => _SortByScreenState();
}

class _SortByScreenState extends State<SortByScreen> {
  String selectedSort = "Manual";

  final List<Map<String, dynamic>> sortOptions = [
    {
      "title": "Manual",
      "subtitle": "Arrange tasks manually",
      "icon": Icons.drag_handle,
      "value": "Manual",
    },
    {
      "title": "Title — A to Z",
      "subtitle": "Alphabetical order",
      "icon": Icons.sort_by_alpha,
      "value": "Title A-Z",
    },
    {
      "title": "Title — Z to A",
      "subtitle": "Reverse alphabetical order",
      "icon": Icons.sort_by_alpha,
      "value": "Title Z-A",
    },
    {
      "title": "Date Added — Newest First",
      "subtitle": "Recently added tasks first",
      "icon": Icons.arrow_downward,
      "value": "Newest",
    },
    {
      "title": "Date Added — Oldest First",
      "subtitle": "Oldest tasks first",
      "icon": Icons.arrow_upward,
      "value": "Oldest",
    },
    {
      "title": "Due Date — Earliest First",
      "subtitle": "Tasks with closest due date first",
      "icon": Icons.event,
      "value": "Due Earliest",
    },
    {
      "title": "Due Date — Latest First",
      "subtitle": "Tasks with latest due date first",
      "icon": Icons.event_available,
      "value": "Due Latest",
    },
    {
      "title": "Incomplete First",
      "subtitle": "Show unfinished tasks first",
      "icon": Icons.radio_button_unchecked,
      "value": "Incomplete",
    },
    {
      "title": "Completed First",
      "subtitle": "Show completed tasks first",
      "icon": Icons.check_circle_outline,
      "value": "Completed",
    },
  ];

  @override
  void initState() {
    super.initState();

    // If you later save the selected sort using SharedPreferences,
    // load it here.
  }

  void selectSort(String value) {
    setState(() {
      selectedSort = value;
    });
  }

  void applySort() {
    Get.back(result: selectedSort);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),

        title: const Text(
          "Sort By",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          TextButton(
            onPressed: applySort,
            child: const Text(
              "Done",
              style: TextStyle(
                color: Color(0xFF4E7BFF),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              15,
              20,
              10,
            ),
            child: Text(
              "SORT TASKS",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              itemCount: sortOptions.length,
              itemBuilder: (context, index) {
                final option = sortOptions[index];

                final bool isSelected =
                    selectedSort == option["value"];

                return _sortTile(
                  title: option["title"],
                  subtitle: option["subtitle"],
                  icon: option["icon"],
                  selected: isSelected,
                  onTap: () {
                    selectSort(option["value"]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.white10,

        child: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 4,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 14,
          ),

          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF292929)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),

          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,

                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF4E7BFF)
                          .withOpacity(0.15)
                      : Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,
                  color: selected
                      ? const Color(0xFF4E7BFF)
                      : Colors.white70,
                  size: 25,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 200),

                width: 24,
                height: 24,

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? const Color(0xFF4E7BFF)
                        : Colors.white38,
                    width: 2,
                  ),
                  color: selected
                      ? const Color(0xFF4E7BFF)
                      : Colors.transparent,
                ),

                child: selected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}