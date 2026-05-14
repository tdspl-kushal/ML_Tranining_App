import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class CtLoading extends StatelessWidget {
  const CtLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(top: 100.0),
          //   child: Container(
          //     child: Text("Loading...", style: sub_title.copyWith(color: Colors.white)),
          //   ),
          // ),

          const SizedBox(
            height: 50.0,
            width: 50.0,
            child: CircularProgressIndicator(
              strokeWidth: 4.0,
              color: AppColors.appPrimary_green,
            ),
          ),
          Container(
            child: Image.asset(
              "images/logo_mini.png",
              scale: 6,
            ),
          ),

        ],
      ),
    );
  }
}
