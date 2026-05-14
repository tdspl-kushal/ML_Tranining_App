import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            const Icon(Icons.insert_drive_file_outlined, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              fileName,
              style: AppTextStyles.paramChip,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class MetricCell extends StatelessWidget {
  final String label;
  final String value;

  const MetricCell({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label:',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            value,
            style: AppTextStyles.metricValue,
          ),
        ],
      ),
    );
  }
}
