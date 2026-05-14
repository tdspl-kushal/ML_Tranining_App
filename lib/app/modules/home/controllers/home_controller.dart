import 'package:flutter_app_template/app/core/utils/extensions/datetime_extension.dart';
import 'package:flutter_app_template/app/core/utils/extensions/strings_extension.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    count.value = 10;
    var dateStr = '2024-01-24T12:12:12';
    print(dateStr.date); // String to date
    print(dateStr.date?.stringDateEEEE); // string to date to string
    print(dateStr.date?.stringDateOnly_dd_mm);
    print(dateStr.date?.stringDateMMMM_D_AM_PM);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
