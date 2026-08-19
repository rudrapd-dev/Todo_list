import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controller/theme_controller.dart';

class CardColorScreen extends StatelessWidget {
  final String category;

  CardColorScreen({
    super.key,
    required this.category,
  });

  final ThemeController controller =
      Get.find<ThemeController>();

  final List<Map<String, dynamic>> colors = [
    {
      "name": "Default",
      "color": Color(0xFF2A2A2A),
    },
    {
      "name": "Blue",
      "color": Color(0xFF3158A8),
    },
    {
      "name": "Purple",
      "color": Color(0xFF6A4BBC),
    },
    {
      "name": "Pink",
      "color": Color(0xFFB84C72),
    },
    {
      "name": "Red",
      "color": Color(0xFF9E3F3F),
    },
    {
      "name": "Orange",
      "color": Color(0xFFB86525),
    },
    {
      "name": "Yellow",
      "color": Color(0xFF8F7A28),
    },
    {
      "name": "Green",
      "color": Color(0xFF347A59),
    },
    {
      "name": "Teal",
      "color": Color(0xFF287C7C),
    },
    {
      "name": "Cyan",
      "color": Color(0xFF287A91),
    },
    {
      "name": "Indigo",
      "color": Color(0xFF4653A5),
    },
    {
      "name": "Grey",
      "color": Color(0xFF555555),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),

        title: const Text(
          "Task Card Color",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
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

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              "Color for $category",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "TASK CARD COLORS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Choose a color for the task cards in this list.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: 
              // Obx(
              //   () =>
                 GridView.builder(
                  itemCount: colors.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1,
                  ),

                  itemBuilder: (context, index) {
                    final Color color =
                        colors[index]["color"];

                    final String name =
                        colors[index]["name"];

                    final int? selectedColor =
                        controller
                            .selectedCardColors[
                                category];

                    final bool isSelected =
                        selectedColor ==
                        color.value;

                    return GestureDetector(
                      onTap: () async {
                        await controller
                            .selectCardColor(
                          category,
                          color,
                        );

                        Get.snackbar(
                          "Color Changed",
                          "$category task card color updated",
                          snackPosition:
                              SnackPosition.TOP,
                          backgroundColor:
                              Colors.green,
                          colorText: Colors.white,
                          duration:
                              const Duration(
                            seconds: 2,
                          ),
                        );
                      },

                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius:
                              BorderRadius.circular(
                            18,
                          ),

                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 3,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.25),
                              blurRadius: 8,
                              offset:
                                  const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                name,
                                style:
                                    const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),

                            if (isSelected)
                              const Positioned(
                                top: 8,
                                right: 8,

                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor:
                                      Colors.white,

                                  child: Icon(
                                    Icons.check,
                                    color:
                                        Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            // ),
          ],
        ),
      ),
    );
  }
}