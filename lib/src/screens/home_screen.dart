import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../helpers/navigator_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pictures = <File>[];

  @override
  Widget build(BuildContext constext) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: FutureBuilder(
            future: availableCameras(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final cameras = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(
                      text: 'Custom camera',
                      icon: Icons.camera_alt_outlined,
                      onPressed: () async =>
                          NavigatorHelper.openCustomPicturePickerScreen(
                        context,
                        cameras,
                        _pictures,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildButton(
                      text: 'Native camera',
                      icon: Icons.camera_alt_outlined,
                      onPressed: () async =>
                          NavigatorHelper.openNativePicturePickerScreen(
                        context,
                        _pictures,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildButton(
                      text: 'QR generator',
                      icon: Icons.qr_code_2,
                      onPressed: () async =>
                          NavigatorHelper.openQrGeneratorScreen(context),
                    ),
                  ],
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

  Widget _buildButton({
    required String text,
    IconData? icon,
    void Function()? onPressed,
  }) {
    return SizedBox(
      width: 200,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 10,
          ),
        ),
        icon: Icon(icon),
        label: Text(text),
      ),
    );
  }
}
