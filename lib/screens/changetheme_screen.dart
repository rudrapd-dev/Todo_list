import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controller/theme_controller.dart';

class ThemeSelectorScreen extends StatelessWidget {
  final String category;

  ThemeSelectorScreen({
    super.key,
    required this.category,
  });

  final ThemeController controller =
      Get.find<ThemeController>();

  // ============================================================
  // DEFAULT THEMES
  // ============================================================

  final List<String> defaultThemes = [
    "assets/themes/theme1.jpg",
    "assets/themes/theme2.jpg",
    "assets/themes/theme3.jpg",
    "assets/themes/theme4.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        centerTitle: true,

        title: Text(
          "Choose Theme",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          children: [

            // ==================================================
            // CURRENT LIST
            // ==================================================

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Theme for $category",
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ==================================================
            // DEFAULT THEMES TITLE
            // ==================================================

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Default Themes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // DEFAULT THEMES
            // ==================================================

            SizedBox(
              height: 180,

              child: GridView.builder(
                itemCount: defaultThemes.length,

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),

                itemBuilder: (context, index) {
                  final String theme =
                      defaultThemes[index];

                  return Obx(() {

                    // ------------------------------------------
                    // CHECK IF THIS THEME IS SELECTED
                    // FOR THIS CATEGORY
                    // ------------------------------------------

                    final bool isSelected =
                        controller.selectedThemes[category] ==
                            theme;

                    return GestureDetector(
                      onTap: () async {

                        // --------------------------------------
                        // APPLY DEFAULT THEME ONLY TO THIS
                        // CATEGORY
                        // --------------------------------------
                        await controller.selectDefaultTheme(
                          category,
                          theme,
                        );

                        Get.snackbar(
                          "Theme Changed",
                          "$category theme updated",
                          snackPosition:
                              SnackPosition.TOP,
                              backgroundColor: Colors.green,
                          duration:
                              const Duration(seconds: 2),
                        );
                      },

                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(14),

                          border: Border.all(
                            color: isSelected
                                ? Colors.green
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),

                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(11),

                          child: Stack(
                            fit: StackFit.expand,

                            children: [

                              // ==============================
                              // IMAGE
                              // ==============================

                              Image.asset(
                                theme,
                                fit: BoxFit.cover,
                              ),

                              // ==============================
                              // DARK GRADIENT
                              // ==============================

                              Container(
                                decoration:
                                    const BoxDecoration(
                                  gradient:
                                      LinearGradient(
                                    begin:
                                        Alignment.topCenter,
                                    end:
                                        Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black87,
                                    ],
                                  ),
                                ),
                              ),

                              // ==============================
                              // THEME NAME
                              // ==============================

                              Align(
                                alignment:
                                    Alignment.bottomCenter,

                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(6),

                                  child: Text(
                                    "Theme ${index + 1}",
                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              // ==============================
                              // SELECTED ICON
                              // ==============================

                              if (isSelected)
                                const Positioned(
                                  top: 5,
                                  right: 5,

                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundColor:
                                        Colors.green,

                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 25),

            // ==================================================
            // CUSTOM THEMES TITLE
            // ==================================================

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "My Themes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // CUSTOM LOCAL IMAGES
            // ==================================================

            Expanded(
              child: Obx(() {

                // ----------------------------------------------
                // NO CUSTOM IMAGES
                // ----------------------------------------------

                if (controller.themeImages.isEmpty) {
                  return const Center(
                    child: Text(
                      "No custom themes added",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                // ----------------------------------------------
                // CUSTOM IMAGE GRID
                // ----------------------------------------------

                return GridView.builder(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),

                  itemCount:
                      controller.themeImages.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),

                  itemBuilder: (context, index) {

                    final File image =
                        controller.themeImages[index];

                    return Obx(() {

                      // ----------------------------------------
                      // CHECK IF THIS IMAGE IS SELECTED FOR
                      // THIS CATEGORY
                      // ----------------------------------------

                      final bool isSelected =
                          controller
                                  .selectedImages[category] ==
                              image.path;

                      return GestureDetector(
                        onTap: () async {

                          // ------------------------------------
                          // APPLY IMAGE ONLY TO THIS CATEGORY
                          // ------------------------------------

                          await controller.setBackground(
                            category,
                            image,
                          );

                          Get.snackbar(
                            "Theme Changed",
                            "$category theme updated",
                            snackPosition:
                                SnackPosition.TOP,
                                backgroundColor: Colors.green,
                            duration:
                                const Duration(seconds: 2),
                          );
                        },

                        child: Card(
                          elevation: 6,
                          clipBehavior:
                              Clip.antiAlias,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(18),

                            side: BorderSide(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),

                          child: Stack(
                            fit: StackFit.expand,

                            children: [

                              // ==========================
                              // CUSTOM IMAGE
                              // ==========================

                              Image.file(
                                image,
                                fit: BoxFit.cover,
                              ),

                              // ==========================
                              // DARK GRADIENT
                              // ==========================

                              Container(
                                decoration:
                                    const BoxDecoration(
                                  gradient:
                                      LinearGradient(
                                    begin:
                                        Alignment.topCenter,
                                    end:
                                        Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black87,
                                    ],
                                  ),
                                ),
                              ),

                              // ==========================
                              // IMAGE NAME
                              // ==========================

                              Align(
                                alignment:
                                    Alignment.bottomCenter,

                                child: Padding(
                                  padding:
                                      const EdgeInsets.all(10),

                                  child: Text(
                                    "My Theme ${index + 1}",
                                    style:
                                        const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              // ==========================
                              // SELECTED ICON
                              // ==========================

                              if (isSelected)
                                const Positioned(
                                  top: 10,
                                  right: 10,

                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor:
                                        Colors.green,

                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 15),

            // ==================================================
            // ADD CUSTOM IMAGE BUTTON
            // ==================================================

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF4E7BFF),

                  foregroundColor: Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                onPressed: () {

                  // --------------------------------------------
                  // CAMERA / GALLERY
                  // --------------------------------------------

                  controller.showImagePickerSheet(
                    category,
                  );
                },

                icon: const Icon(
                  Icons.add_photo_alternate,
                ),

                label: const Text(
                  "Add Custom Image",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}