import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../screens/native_picture_picker_screen.dart';
import '../screens/picture_gallery_screen.dart';
import '../screens/custom_picture_picker_screen.dart';

class NavigatorHelper {
  static Future<void> openNativePicturePickerScreen(
    BuildContext context,
    List<File> pictures,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NativePicturePickerScreen(pictures: pictures),
      ),
    );
  }

  static Future<void> openCustomPicturePickerScreen(
    BuildContext context,
    List<CameraDescription> cameras,
    List<File> pictures,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomPicturePickerScreen(
          cameras: cameras,
          pictures: pictures,
        ),
      ),
    );
  }

  static Future<void> openPictureGalleryScreen(
    BuildContext context,
    List<File> pictures,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PictureGalleryScreen(pictures: pictures),
      ),
    );
  }
}
