import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';

class MetricCellWidget extends StatelessWidget {
  final double value;

  const MetricCellWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Text(
      value.toMetric(),
      style: AppTextStyles.metricValue,
    );
  }
}
