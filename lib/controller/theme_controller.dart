import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeController extends GetxController {
  
  // ============================================================
  // IMAGE PICKER
  // ============================================================

  final ImagePicker picker = ImagePicker();

  // ============================================================
  // CUSTOM IMAGES STORED LOCALLY
  // ============================================================

  final RxList<File> themeImages = <File>[].obs;

  // ============================================================
  // SELECTED DEFAULT THEME FOR EACH CATEGORY
  //
  // Example:
  // Important -> assets/themes/theme1.jpg
  // Planned   -> assets/themes/theme2.jpg
  // ============================================================

  final RxMap<String, String> selectedThemes =
      <String, String>{}.obs;

  // ============================================================
  // SELECTED CUSTOM IMAGE FOR EACH CATEGORY
  //
  // Example:
  // Important -> /local/path/image.jpg
  // ============================================================

  final RxMap<String, String> selectedImages =
      <String, String>{}.obs;

  // ============================================================
  // INIT
  // ============================================================
 final RxMap<String, int> selectedCardColors =
    <String, int>{}.obs;
  @override
  void onInit() {
    super.onInit();

    loadImages();
    loadCategoryThemes();
    loadCardColors();
  }

  // ============================================================
  // LOAD CUSTOM IMAGES
  // ============================================================

  Future<void> loadImages() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final List<String> paths =
          prefs.getStringList("theme_images") ?? [];

      themeImages.clear();

      for (final path in paths) {
        final file = File(path);

        if (await file.exists()) {
          themeImages.add(file);
        }
      }

      themeImages.refresh();
    } catch (e) {
      debugPrint(
        "Error loading custom images: $e",
      );
    }
  }

  // ============================================================
  // SELECT DEFAULT THEME FOR A CATEGORY
  // ============================================================

  Future<void> selectDefaultTheme(
    String category,
    String assetPath,
  ) async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      // Set default theme for this category
      selectedThemes[category] = assetPath;

      // Remove custom image from this category
      selectedImages.remove(category);

      // Save default theme
      await prefs.setString(
        "theme_$category",
        assetPath,
      );

      // Remove custom image
      await prefs.remove(
        "image_$category",
      );

      selectedThemes.refresh();
      selectedImages.refresh();
    } catch (e) {
      debugPrint(
        "Error selecting default theme: $e",
      );
    }
  }

  // ============================================================
  // SELECT CUSTOM IMAGE FOR A CATEGORY
  // ============================================================

  Future<void> setBackground(
    String category,
    File image,
  ) async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      // Set custom image for this category
      selectedImages[category] = image.path;

      // Remove default theme
      selectedThemes.remove(category);

      // Save custom image path
      await prefs.setString(
        "image_$category",
        image.path,
      );

      // Remove default theme
      await prefs.remove(
        "theme_$category",
      );

      selectedImages.refresh();
      selectedThemes.refresh();
    } catch (e) {
      debugPrint(
        "Error setting background: $e",
      );
    }
  }

  // ============================================================
  // LOAD SAVED CATEGORY THEMES
  // ============================================================

  Future<void> loadCategoryThemes() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      const List<String> categories = [
        "My Day",
        "Important",
        "Planned",
        "Assigned",
        "Flagged",
        "Tasks",
        "Recently Deleted",
        "new",
      ];

      selectedThemes.clear();
      selectedImages.clear();

      for (final category in categories) {
        final String? theme =
            prefs.getString(
          "theme_$category",
        );

        final String? image =
            prefs.getString(
          "image_$category",
        );

        // ------------------------------------------------------
        // DEFAULT THEME
        // ------------------------------------------------------

        if (theme != null && theme.isNotEmpty) {
          selectedThemes[category] = theme;
        }

        // ------------------------------------------------------
        // CUSTOM IMAGE
        // ------------------------------------------------------

        if (image != null && image.isNotEmpty) {
          final file = File(image);

          if (await file.exists()) {
            selectedImages[category] = image;
          } else {
            // Remove invalid image path
            await prefs.remove(
              "image_$category",
            );
          }
        }
      }

      selectedThemes.refresh();
      selectedImages.refresh();
    } catch (e) {
      debugPrint(
        "Error loading category themes: $e",
      );
    }
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> pickImage(
    String category,
    ImageSource source,
  ) async {
    try {
      // --------------------------------------------------------
      // OPEN CAMERA / GALLERY
      // --------------------------------------------------------

      final XFile? pickedImage =
          await picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      // User cancelled
      if (pickedImage == null) {
        return;
      }

      // --------------------------------------------------------
      // GET APP DOCUMENT DIRECTORY
      // --------------------------------------------------------

      final Directory directory =
          await getApplicationDocumentsDirectory();

      // --------------------------------------------------------
      // CREATE UNIQUE FILE NAME
      // --------------------------------------------------------

      final String fileName =
          "${DateTime.now().millisecondsSinceEpoch}.jpg";

      final File savedFile = File(
        "${directory.path}/$fileName",
      );

      // --------------------------------------------------------
      // COPY IMAGE TO APP STORAGE
      // --------------------------------------------------------

      await File(pickedImage.path).copy(
        savedFile.path,
      );

      // --------------------------------------------------------
      // ADD IMAGE TO LOCAL IMAGE LIST
      // --------------------------------------------------------

      if (!themeImages.any(
        (file) => file.path == savedFile.path,
      )) {
        themeImages.add(savedFile);
      }

      themeImages.refresh();

      // --------------------------------------------------------
      // SAVE IMAGE LIST
      // --------------------------------------------------------

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setStringList(
        "theme_images",
        themeImages
            .map(
              (file) => file.path,
            )
            .toList(),
      );

      // --------------------------------------------------------
      // APPLY IMAGE ONLY TO SELECTED CATEGORY
      // --------------------------------------------------------

      await setBackground(
        category,
        savedFile,
      );

      // --------------------------------------------------------
      // SUCCESS MESSAGE
      // --------------------------------------------------------

      Get.snackbar(
        "Theme Changed",
        "$category theme updated",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(
          seconds: 2,
        ),
      );
    } catch (e) {
      debugPrint(
        "Error picking image: $e",
      );

      Get.snackbar(
        "Error",
        "Unable to select image",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ============================================================
  // SELECT CAMERA OR GALLERY
  // ============================================================

  Future<void> selectImageSource(
    String category,
    ImageSource source,
  ) async {
    Get.back();

    await pickImage(
      category,
      source,
    );
  }

  // ============================================================
  // IMAGE PICKER BOTTOM SHEET
  // ============================================================

  void showImagePickerSheet(
    String category,
  ) {
    Get.bottomSheet(
      Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: const BoxDecoration(
            color: Color(0xFF1F1F1F),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================================
                // TITLE
                // ==================================================

                const Text(
                  "Add Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // CAMERA
                // ==================================================

                Material(
                  color: Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(12),
                  child: ListTile(
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    leading: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),

                    title: const Text(
                      "Camera",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    onTap: () {
                      selectImageSource(
                        category,
                        ImageSource.camera,
                      );
                    },
                  ),
                ),

                // ==================================================
                // GALLERY
                // ==================================================

                Material(
                  color: Colors.transparent,
                  borderRadius:
                      BorderRadius.circular(12),
                  child: ListTile(
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),

                    leading: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                    ),

                    title: const Text(
                      "Gallery",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    onTap: () {
                      selectImageSource(
                        category,
                        ImageSource.gallery,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),

      isScrollControlled: true,
    );
  }
  Future<void> loadCardColors() async {
  final prefs = await SharedPreferences.getInstance();

  final Map<String, int> loadedColors = {};

  for (final key in prefs.getKeys()) {
    if (key.startsWith("card_color_")) {
      final category =
          key.replaceFirst("card_color_", "");

      final colorValue = prefs.getInt(key);

      if (colorValue != null) {
        loadedColors[category] = colorValue;
      }
    }
  }

  selectedCardColors.assignAll(loadedColors);
}
Future<void> selectCardColor(
  String category,
  Color color,
) async {
  final prefs = await SharedPreferences.getInstance();

  selectedCardColors[category] = color.value;

  selectedCardColors.refresh();

  await prefs.setInt(
    "card_color_$category",
    color.value,
  );
}Color getCardColor(String category) {
  final colorValue =
      selectedCardColors[category];

  if (colorValue == null) {
    return const Color(0xFF2A2A2A);
  }

  return Color(colorValue);
}

}
