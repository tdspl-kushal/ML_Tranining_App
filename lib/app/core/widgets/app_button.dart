import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? prefixIcon;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.prefixIcon,
    this.width,
    this.height = 44,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (prefixIcon != null) ...[
                Icon(prefixIcon, size: 18),
                const SizedBox(width: 6),
              ],
              Text(label),
            ],
          );

    final style = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            minimumSize: Size(width ?? 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            minimumSize: Size(width ?? 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.buttonRadius),
            ),
            elevation: 0,
          );

    final effectiveOnPressed = isLoading ? null : onPressed;

    if (isOutlined) {
      return Opacity(
        opacity: effectiveOnPressed == null && !isLoading ? 0.5 : 1.0,
        child: OutlinedButton(
          onPressed: effectiveOnPressed,
          style: style,
          child: child,
        ),
      );
    }

    return Opacity(
      opacity: effectiveOnPressed == null && !isLoading ? 0.5 : 1.0,
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      ),
    );
  }
}
