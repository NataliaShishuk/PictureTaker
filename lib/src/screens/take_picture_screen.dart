import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'picture_gallery_screen.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.cameras,
  });

  final List<CameraDescription> cameras;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  int _currentCameraIndex = 0;
  bool _isTakePictureButtonDisabled = false;

  final List<File> _capturedPictures = [];

  @override
  void initState() {
    super.initState();

    _initializeCamera(_currentCameraIndex);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: _initializeControllerFuture,
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.done
                  ? _buildBody(context)
                  : _buildLoading(context),
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        CameraPreview(_controller),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildBottomPanel(context),
        ),
      ],
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.17,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            iconSize: 45,
            onPressed: () => _onSwitchCamera(context),
            icon: const Icon(Icons.flip_camera_android_outlined),
          ),
          GestureDetector(
            onTap: () async =>
                _isTakePictureButtonDisabled ? null : _onTakePicture(context),
            child: Container(
              height: 60,
              width: 60,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _goToPictureGalleryScreen(context),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white),
                image: _capturedPictures.isNotEmpty
                    ? DecorationImage(
                        image: FileImage(_capturedPictures.first),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initializeCamera(int cameraIndex) {
    _controller = CameraController(
      widget.cameras[cameraIndex],
      ResolutionPreset.max,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  void _showSnachBarMessage(BuildContext context, String messsage) {
    final snackBar = SnackBar(
      content: Text(messsage),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onSwitchCamera(BuildContext context) {
    if (widget.cameras.length > 1) {
      setState(() {
        _currentCameraIndex = _currentCameraIndex == 0 ? 1 : 0;

        _initializeCamera(_currentCameraIndex);
      });
    } else {
      _showSnachBarMessage(
        context,
        'No secondary camera found',
      );
    }
  }

  Future<void> _onTakePicture(BuildContext context) async {
    try {
      await _initializeControllerFuture;

      setState(() {
        _isTakePictureButtonDisabled = true;
      });

      final picture = await _controller.takePicture();

      setState(() {
        _capturedPictures.insert(0, File(picture.path));
      });
    } catch (e) {
      _showSnachBarMessage(context, e.toString());
    } finally {
      setState(() {
        _isTakePictureButtonDisabled = false;
      });
    }
  }

  void _goToPictureGalleryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PictureGalleryScreen(pictures: _capturedPictures),
      ),
    );
  }
}
