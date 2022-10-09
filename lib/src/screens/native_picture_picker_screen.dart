import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/navigator_helper.dart';
import '../helpers/snack_bar_helper.dart';

class NativePicturePickerScreen extends StatefulWidget {
  const NativePicturePickerScreen({
    super.key,
    required this.pictures,
  });

  final List<File> pictures;

  @override
  State<NativePicturePickerScreen> createState() =>
      _NativePicturePickerScreenState();
}

class _NativePicturePickerScreenState extends State<NativePicturePickerScreen> {
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Native camera'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Last picture:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () async => NavigatorHelper.openPictureGalleryScreen(
                context,
                widget.pictures,
              ),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                  image: widget.pictures.isNotEmpty
                      ? DecorationImage(
                          image: FileImage(widget.pictures.first),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () async => NavigatorHelper.openPictureGalleryScreen(
                context,
                widget.pictures,
              ),
              child: const Text(
                'See all',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => _onTakePicture(context),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.camera_alt,
          size: 30,
        ),
      ),
    );
  }

  Future<void> _onTakePicture(BuildContext context) async {
    try {
      final picture = await _picker.pickImage(source: ImageSource.camera);

      if (picture != null) {
        setState(() {
          widget.pictures.insert(0, File(picture.path));
        });
      }
    } catch (e) {
      SnackBarHelper.showMessage(context, e.toString());
    }
  }
}
