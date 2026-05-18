import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    // Hparams chips
    final hparamsSection = entry.hparamsUsed.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Hyperparameters'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: entry.hparamsUsed.entries.map((param) {
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
          )
        : const SizedBox.shrink();

    // Metrics key-value rows
    final metricsSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Metrics'),
        const SizedBox(height: 10),
        if (entry.metrics == null || entry.metrics!.isEmpty)
          ...[
            const MetricCell(label: 'Precision', value: '—'),
            const MetricCell(label: 'Accuracy', value: '—'),
            const MetricCell(label: 'Recall', value: '—'),
            const MetricCell(label: 'F1', value: '—'),
          ]
        else
          ...entry.metrics!.entries.map((metric) {
            final label = metric.key
                .replaceAll('_', ' ')
                .split(' ')
                .map((w) => w.capitalize)
                .join(' ');
            final val = metric.value;
            final display = val is double
                ? val.toMetric()
                : val.toString();
            return MetricCell(label: label, value: display);
          }),
      ],
    );

    // Feature importance chips
    final featureImportanceSection =
        entry.featureImportance != null && entry.featureImportance!.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Feature Importance'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.featureImportance!.entries.map((fi) {
                      return Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.tableBorder),
                        ),
                        child: Text(
                          '${fi.key}: ${fi.value.toStringAsFixed(4)}',
                          style: AppTextStyles.paramChip,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : const SizedBox.shrink();

    final infoSection = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Info'),
        const SizedBox(height: 10),
        if (entry.trainingDurationSeconds != null) ...[
          MetricCell(
            label: 'Duration',
            value: '${entry.trainingDurationSeconds!.toStringAsFixed(2)}s',
          ),
        ],
        if (entry.tagsUsed.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSectionTitle('Tags'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: entry.tagsUsed
                .map((t) => DatasetChip(fileName: t))
                .toList(),
          ),
        ],
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
                if (entry.hparamsUsed.isNotEmpty) ...[
                  hparamsSection,
                  const SizedBox(height: 24),
                ],
                metricsSection,
                if (entry.featureImportance != null &&
                    entry.featureImportance!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  featureImportanceSection,
                ],
                const SizedBox(height: 24),
                infoSection,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (entry.hparamsUsed.isNotEmpty) ...[
                  Expanded(child: hparamsSection),
                  const SizedBox(width: 32),
                ],
                Expanded(child: metricsSection),
                if (entry.featureImportance != null &&
                    entry.featureImportance!.isNotEmpty) ...[
                  const SizedBox(width: 32),
                  Expanded(child: featureImportanceSection),
                ],
                const SizedBox(width: 32),
                Expanded(child: infoSection),
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
