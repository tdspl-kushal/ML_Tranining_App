import 'package:flutter/material.dart';

import '../values/app_colors.dart';

class ProfileWidget extends StatelessWidget {
  final String? imagePath;
  final bool isEdit;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    return Container(
      width: 120.0,
      height: 120.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imagePath == "" ? const AssetImage('images/avatar_placeholder.png') : NetworkImage(imagePath!) as ImageProvider,
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(60.0)),
        border: Border.all(
          color: AppColors.colorAccent,
          width: 2.0,
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => InkWell(
        onTap: onClicked,
        child: buildCircle(
          color: Colors.white,
          all: 2,
          child: buildCircle(
            color: color,
            all: 5,
            child: Icon(
              isEdit ? Icons.add_a_photo : Icons.edit,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
