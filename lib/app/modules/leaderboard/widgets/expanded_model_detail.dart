import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import 'dataset_chip.dart';

class ExpandedModelDetail extends StatelessWidget {
  final LeaderboardEntryModel entry;

  const ExpandedModelDetail({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final parametersSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Parameter'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: entry.parameters.entries.map((param) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.tableBorder),
              ),
              child: Text(
                '${param.key}: ${param.value}',
                style: AppTextStyles.paramChip,
              ),
            );
          }).toList(),
        ),
      ],
    );

    final metricsSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Metrics'),
        const SizedBox(height: 10),
        ...entry.metrics.entries.map((metric) {
          final label = metric.key
              .replaceAll('_', ' ')
              .split(' ')
              .map((w) => w.capitalize)
              .join(' ');
          return MetricCell(
            label: label,
            value: metric.value.toMetric(),
          );
        }),
      ],
    );

    final fileSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('File trained on'),
        const SizedBox(height: 10),
        DatasetChip(fileName: entry.trainedOnFile),
      ],
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.expandedRowBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                parametersSection,
                const SizedBox(height: 24),
                metricsSection,
                const SizedBox(height: 24),
                fileSection,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: parametersSection),
                const SizedBox(width: 32),
                Expanded(child: metricsSection),
                const SizedBox(width: 32),
                Expanded(child: fileSection),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class MetricCell extends StatelessWidget {
  final String label;
  final String value;

  const MetricCell({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
