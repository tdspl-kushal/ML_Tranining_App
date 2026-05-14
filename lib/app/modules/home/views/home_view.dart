import 'package:flutter/material.dart';
// import 'package:flutter_app_template/app/core/utils/extensions/datetime_extension.dart';
// import 'package:flutter_app_template/app/core/utils/extensions/strings_extension.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
