import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../values/text_styles.dart';
import '../widget/custom_button.dart';

class DialogUtils {
  static showAlertDialog(String message) {
    Get.dialog(AlertDialog(
      title: const Text('Error', style: title_bold),
      content: Text(message, style: title_light),
      actions: [CTButton(width: 130, height: 45, title: "OK", onTap: () => Get.back())],
      actionsPadding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
    ));
  }
}
