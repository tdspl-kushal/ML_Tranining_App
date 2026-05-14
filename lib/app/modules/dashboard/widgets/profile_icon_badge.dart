import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';

class ProfileIconBadge extends StatelessWidget {
  final String iconType;

  const ProfileIconBadge({super.key, required this.iconType});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.iconBadgeSize,
      height: AppDimensions.iconBadgeSize,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getIcon(iconType),
        color: AppColors.primary,
        size: 20,
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type.toLowerCase()) {
      case 'car':
        return Icons.directions_car_rounded;
      case 'bus':
        return Icons.directions_bus_rounded;
      case 'truck':
        return Icons.local_shipping_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
