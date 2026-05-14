
import 'package:flutter/material.dart';

import '../values/app_colors.dart';
import '../values/app_values.dart';
import '../values/text_styles.dart';

class CTButton extends StatelessWidget {
  final double width;
  final double height;
  final Function()? onTap;
  final String title;
  final double? fontSize;
  final bool isEnabled;
  final IconData? icon;
  final double? iconSize;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double borderRadius;

  const CTButton({
    Key? key,
    required this.width,
    required this.height,
    required this.title,
    required this.onTap,
    this.icon,
    this.fontSize,
    this.isEnabled = true,
    this.backgroundColor = AppColors.appPrimary_black,
    this.textColor = AppColors.colorWhite,
    this.borderColor = AppColors.appPrimary_black,
    this.iconSize = AppValues.iconSize_18,
    this.borderRadius = AppValues.radius_10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    EdgeInsetsGeometry edgeInsets = const EdgeInsets.all(0);
    if (height == null) {
      edgeInsets = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
    }

    return Padding(
      padding: edgeInsets,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        child: AbsorbPointer(
          absorbing: isEnabled,
          child: Container(
            width: width,
            height: height,
            padding: edgeInsets,
            decoration: BoxDecoration(
                color: backgroundColor,
                // border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: backgroundColor.withOpacity(AppValues.opacity_2),
                    blurRadius: 1,
                    spreadRadius: AppValues.radius_half,
                    offset: const Offset(2.0, 2.0),
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTitle(_theme),
                  _buildIcon(_theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData _theme) {
    return Text(title, style: btn_text.copyWith(color: textColor, fontWeight : FontWeight.w600, fontSize: fontSize != null ? fontSize! : 18));
  }

  Widget _buildIcon(ThemeData theme) {
    if (icon != null) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 2.0,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: AppColors.colorWhite,
        ),
      );
    }

    return const SizedBox();
  }
}
