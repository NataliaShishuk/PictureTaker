import 'package:flutter/material.dart';

import 'src/screens/home_screen.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const PictureTakerApp());
}

class PictureTakerApp extends StatelessWidget {
  const PictureTakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Picture taker',
      theme: ThemeData.dark(),
      home: const HomeScreen(
        title: 'Picture taker',
      ),
    );
  }
}
