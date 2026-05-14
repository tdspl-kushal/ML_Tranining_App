import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../values/app_colors.dart';
import '../values/app_constant.dart';

// TYPE CROP (1 : 1) type 1, (3:2), type 2 (2:3)
class ImageUtil {
  static Future<void> captureImage(BuildContext context, Function(File) callBackF, int type, {imageSource, errorCallBack}) async {
    try {
      if (imageSource != null) {
        await pickImage(context, imageSource, callBackF, type);
      } else {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext bc) {
              return SafeArea(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Photo Library'),
                        onTap: () async {
                          await pickImage(context, ImageSource.gallery, callBackF, type);
                          Get.back();
                        }),
                    ListTile(
                      // cropImage,
                      leading: const Icon(Icons.photo_camera),
                      title: const Text('Camera'),
                      onTap: () async {
                        await pickImage(context, ImageSource.camera, callBackF, type);
                        Navigator.of(context).pop();
                        Get.back();
                      },
                    ),
                  ],
                ),
              );
            });
      }
    } catch (e) {
      errorCallBack(e);
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // static pickScreenshot(context, Function(File) callBackF, {imageSource, errorCallBack}) {
  //   pickImageWithOutCrop(context, ImageSource.gallery, callBackF);
  //   Navigator.of(context).pop();
  // }
  //
  // static pickImageWithOutCrop(context, ImageSource source, Function(File) callBackF) async {
  //   final ImagePicker _picker = ImagePicker();
  //   final pickedFile = await _picker.pickImage(source: source);
  //   if (pickedFile != null) {
  //     final croppedFile = await cropImage(context, pickedFile.path, type);
  //     callBackF(croppedFile);
  //   }
  // }

  static Future<void> pickImage(BuildContext context,ImageSource source, Function(File) callBackF, int type) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      (_picker.pickImage(source: source));
      // final croppedFile = await cropImage(context, pickedFile.path, type);
      // callBackF(crFuture<CroppedFile?>       callBackF( File(pickedFile.path));
    }
  }

  static Future<CroppedFile?> cropImage(BuildContext context, String filePath, int type) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        compressQuality: 70,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets:  type == 0
                ? Platform.isAndroid
                ? [CropAspectRatioPreset.square]
                : [CropAspectRatioPreset.square]
                : type == 2
                ? Platform.isAndroid
                ? [CropAspectRatioPreset.original]
                : [CropAspectRatioPreset.original]
                : Platform.isAndroid
                ? [CropAspectRatioPreset.ratio3x2]
                : [CropAspectRatioPreset.ratio3x2],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets:  type == 0
                ? Platform.isAndroid
                ? [CropAspectRatioPreset.square]
                : [CropAspectRatioPreset.square]
                : type == 2
                ? Platform.isAndroid
                ? [CropAspectRatioPreset.original]
                : [CropAspectRatioPreset.original]
                : Platform.isAndroid
                ? [CropAspectRatioPreset.ratio3x2]
                : [CropAspectRatioPreset.ratio3x2],
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );

      return croppedFile;
    } catch (e) {
      if (kDebugMode) {
        print('Error while cropping image: $e');
      }
      return null;
    }
  }

  static thumbnailImage(File file) {
    final extension = p.extension(file.path);

    return extension.endsWith('.png') || extension.endsWith('.jpg') || extension.endsWith('.jpeg') || extension.endsWith('.gif')
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
                errorBuilder: (context, object, error) => const Icon(Icons.broken_image_outlined, color: AppColors.redColor),
                image: FileImage(file),
                fit: BoxFit.fitWidth,
                width: 45,
                height: 45,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }

                  return AnimatedOpacity(child: child, opacity: frame == null ? 0 : 1, duration: const Duration(milliseconds: 300));
                },
                alignment: Alignment.topLeft),
          )
        : Image.asset(
            ImageUtil.getExtension(extension),
            height: 45,
            fit: BoxFit.fitWidth,
            width: 45,
          );
  }

  static thumbnailImageNetwork(String path, {double? size}) {
    final extension = p.extension(path);

    return extension.endsWith('.png') || extension.endsWith('.jpg') || extension.endsWith('.jpeg') || extension.endsWith('.gif')
        ? ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              AppConstant.BASEURL + path,
              width: size ?? 45,
              height: size ?? 45,
              fit: BoxFit.fitWidth,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              ImageUtil.getExtension(extension),
              width: size ?? 45,
              height: size ?? 45,
              fit: BoxFit.fitWidth,
            ),
          );
  }

  static getExtension(String extension) {
    if (extension.endsWith('.wav') || extension.endsWith('.aac') || extension.endsWith('.mp3')) {
      return 'images/ic_music.png';
    } else if (extension.endsWith('.ppt') || extension.endsWith('.pptx')) {
      return 'images/ic_ppt.png';
    } else if (extension.endsWith('.txt')) {
      return 'images/ic_txt.png';
    } else if (extension.endsWith('.pdf')) {
      return 'images/ic_pdf.png';
    } else if (extension.endsWith('.doc') || extension.endsWith('.docx')) {
      return 'images/ic_doc.png';
    } else if (extension.endsWith('.xls') || extension.endsWith('.xlsx') || extension.endsWith('.csv')) {
      return 'images/ic_xls.png';
    } else if (extension.endsWith('.zip') || extension.endsWith('.rar')) {
      return 'images/ic_zip.png';
    } else {
      return 'images/ic_file.png';
    }
  }

  static getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      Permission.storage.request();
    } else {
      Permission.storage.request();
    }

    return false;
  }
}
