import 'dart:io';
import 'package:file_picker/file_picker.dart';

class NumberUtil {
  static double? getRound(double number) {
    return double.parse((number).toStringAsFixed(2));
  }

  static double calculateFilesSize(FilePickerResult? resultLocal) {
    int sum = 0;
    for (var element in resultLocal!.files) {
      sum += element.size;
    }

    return (sum / 1024) / 1024;
  }

  static double calculateFileSize(FilePickerResult? resultLocal) {
    int sum = 0;
    for (var element in resultLocal!.files) {
      sum += element.size;
    }

    return (sum / 1024) / 1024;
  }

  static bool isFileSizeLessThen_1MB(File resultLocal) {
    return ((resultLocal.lengthSync() / 1024) / 1024) > 1 ? false : true;
  }
  static bool isFileSizeLessThen_5MB(File resultLocal) {
    return ((resultLocal.lengthSync() / 1024) / 1024) > 5 ? false : true;
  }
}
