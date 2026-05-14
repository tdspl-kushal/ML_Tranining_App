import 'dart:io';
import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class UserImageHolder extends StatelessWidget {
  final String? imageUrl;
  final double imageSize;
  final File? imageFile;

  const UserImageHolder({
    Key? key,
    required this.imageUrl,
    required this.imageSize,
    this.imageFile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.colorAccent,
      maxRadius: imageSize + 0.5,
      child: imageFile == null
          ? CircleAvatar(
              backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  // ? NetworkImage(AppConstant.BASEURL + imageUrl!)
                  : const AssetImage("images/ic_king.png") as ImageProvider,
              backgroundColor: AppColors.pageBackground,
              maxRadius: imageSize,
            )
          : Image.file(imageFile!),
    );
  }
}
