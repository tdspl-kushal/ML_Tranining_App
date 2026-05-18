import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class DatasetChip extends StatelessWidget {
  final String fileName;
  final VoidCallback? onTap;

  const DatasetChip({
    super.key,
    required this.fileName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.tableBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file_outlined,
                size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              fileName,
              style: AppTextStyles.paramChip,
            ),
          ],
        ),
      ),
    );
  }
}
