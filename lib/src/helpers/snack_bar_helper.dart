import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showMessage(BuildContext context, String messsage) {
    final snackBar = SnackBar(
      content: Text(messsage),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
