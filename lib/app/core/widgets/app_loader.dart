import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
