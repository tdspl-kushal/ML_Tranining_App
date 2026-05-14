import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/app_colors.dart';

class ITDialogs {
  static defaultDialog(String content, {String? title, String? okButtonText,
    String? cancelButtonText, VoidCallback? onConfirm,VoidCallback? onCancel}){
    // return Get.defaultDialog(
    //     title: title??'',
    //     middleText: content,
    //     // backgroundColor: Colors.green,
    //     // titleStyle: TextStyle(color: Colors.white),
    //     // middleTextStyle: TextStyle(color: Colors.white),
    //     textConfirm: okButtonText ?? 'OK',
    //     textCancel: cancelButtonText ?? "Cancel",
    //     // cancelTextColor: Colors.white,
    //     // confirmTextColor: Colors.white,
    //     // buttonColor: Colors.red,
    //     // barrierDismissible: false,
    //     // radius: 50,
    //     onConfirm: onConfirm,
    //     onCancel:onCancel
    // );
    return showDialog(
      context: Get.context!,
      builder: (context) =>
          AlertDialog(
            title: Text(title??''),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: onConfirm ?? () => Navigator.pop(context),
                child: const Text('Ok', style: TextStyle(color: AppColors.colorPrimary),),
              ),
            ],
          ),
    );
  }
}
