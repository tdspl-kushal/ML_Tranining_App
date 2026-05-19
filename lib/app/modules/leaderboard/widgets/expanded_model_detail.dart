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
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth),
          child: ClipRect(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.expandedRowBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (entry.hparamsUsed.isNotEmpty) _HyperparamsAccordion(entry: entry),
                    _MetricsAccordion(entry: entry),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HyperparamsAccordion extends StatelessWidget {
  final LeaderboardEntryModel entry;
  const _HyperparamsAccordion({required this.entry});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        'Hyperparameters',
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                '${param.key.replaceAll('_', ' ')}: ${_formatValue(param.value)}',
                style: AppTextStyles.paramChip,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _MetricsAccordion extends StatelessWidget {
  final LeaderboardEntryModel entry;
  const _MetricsAccordion({required this.entry});

  Widget _buildMetricWidget(String key, dynamic value) {
    final label = key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? w.capitalize : '')
        .join(' ');

    if (value is Map) {
      return Theme(
        data: ThemeData(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(left: 16, bottom: 8),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          shape: const Border(),
          collapsedShape: const Border(),
          children: value.entries.map((e) {
            return _buildMetricWidget(e.key.toString(), e.value);
          }).toList(),
        ),
      );
    } else {
      return MetricCell(
        label: label,
        value: _formatValue(value),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    
    final metricsWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entry.metrics == null || entry.metrics!.isEmpty)
          ...[
            const MetricCell(label: 'Precision', value: '—'),
            const MetricCell(label: 'Accuracy', value: '—'),
            const MetricCell(label: 'Recall', value: '—'),
            const MetricCell(label: 'F1', value: '—'),
          ]
        else
          ...entry.metrics!.entries.expand((metric) {
            final keyLower = metric.key.toLowerCase().replaceAll('_', '');
            if (keyLower == 'imp') {
              final list = <Widget>[];
              if (metric.value is Map) {
                final map = metric.value as Map;
                for (final e in map.entries) {
                  final subKey = e.key.toString();
                  final subKeyLower = subKey.toLowerCase().replaceAll('_', '');
                  if (subKeyLower == 'deploymenthealth' ||
                      subKeyLower == 'modelfitanalysis') {
                    list.add(_buildMetricWidget(subKey, e.value));
                  }
                }
              }
              return list;
            }
            if (keyLower == 'generalizationmetrics') {
              if (metric.value is Map) {
                final originalMap = metric.value as Map;
                final filteredMap = Map.from(originalMap)..removeWhere((k, v) {
                  final kStr = k.toString().toLowerCase().replaceAll('_', '').replaceAll(' ', '');
                  return kStr == 'isunderfit';
                });
                if (filteredMap.isEmpty) {
                  return <Widget>[];
                }
                return [_buildMetricWidget(metric.key, filteredMap)];
              }
            }
            return [_buildMetricWidget(metric.key, metric.value)];
          }),
      ],
    );

    final featureImportanceWidget = entry.featureImportance != null && entry.featureImportance!.isNotEmpty
        ? Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              title: Text(
                'Feature Importance',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(left: 0, bottom: 8),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              shape: const Border(),
              collapsedShape: const Border(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: entry.featureImportance!.entries.map((fi) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.tableBorder),
                        ),
                        child: Text(
                          '${fi.key.replaceAll('_', ' ')}: ${_formatValue(fi.value)}',
                          style: AppTextStyles.paramChip,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();

    final infoWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (entry.trainingDurationSeconds != null)
          MetricCell(
            label: 'Duration',
            value: '${entry.trainingDurationSeconds!.toStringAsFixed(2)}s',
          ),
        if (entry.tagsUsed.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            'Tags',
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: entry.tagsUsed.map((t) => DatasetChip(fileName: t)).toList(),
          ),
        ],
      ],
    );

    return ExpansionTile(
      title: Text(
        'Metrics & Info',
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              metricsWidget,
              const SizedBox(height: 16),
              featureImportanceWidget,
              const SizedBox(height: 16),
              infoWidget,
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: metricsWidget),
              const SizedBox(width: 24),
              Expanded(child: featureImportanceWidget),
              const SizedBox(width: 24),
              Expanded(child: infoWidget),
            ],
          ),
      ],
    );
  }
}

String _formatValue(dynamic val) {
  if (val is double) {
    return val.toStringAsFixed(4);
  } else if (val is Map) {
    // Nested dictionaries handled gracefully
    final entries = val.entries.map((e) => '${e.key.toString().replaceAll('_', ' ')}: ${_formatValue(e.value)}').join(', ');
    return '{$entries}';
  } else if (val is List) {
    final entries = val.map((e) => _formatValue(e)).join(', ');
    return '[$entries]';
  }
  return val.toString().replaceAll('_', ' ');
}

class MetricCell extends StatelessWidget {
  final String label;
  final String value;

  const MetricCell({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
