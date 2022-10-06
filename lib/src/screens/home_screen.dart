import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'take_picture_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
          ),
        ),
        body: Center(
          child: FutureBuilder(
            future: availableCameras(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final cameras = snapshot.data!;

                return ElevatedButton.icon(
                  onPressed: () async => _goToTakePictureView(context, cameras),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                  ),
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                  ),
                  label: const Text(
                    'Take picture',
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _goToTakePictureView(
    BuildContext context,
    List<CameraDescription> cameras,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(
          cameras: cameras,
        ),
      ),
    );
  }
}
