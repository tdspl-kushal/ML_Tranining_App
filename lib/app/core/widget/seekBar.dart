import 'package:flutter/material.dart';

showSnackBar(context, String? text) {
  final snackBar = SnackBar(
    content: Text('$text'),
    duration: const Duration(seconds: 4),
    action: SnackBarAction(
      label: "Close",
      onPressed: () {
        null;
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
