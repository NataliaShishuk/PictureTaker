import 'package:flutter/material.dart';
import 'package:picture_taker/src/home_page.dart';

void main() {
  runApp(const PictureTakerApp());
}

class PictureTakerApp extends StatelessWidget {
  const PictureTakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picture taker',
      theme: ThemeData.dark(),
      home: const HomePage(
        title: 'Picture taker',
      ),
    );
  }
}
