import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../widgets/use_case_selector.dart';

class Step3UseCase extends StatelessWidget {
  final String? selectedUseCase;
  final ValueChanged<String> onSelected;
  final String? error;

  const Step3UseCase({
    super.key,
    this.selectedUseCase,
    required this.onSelected,
    this.error,
  });

  static const _useCases = [
    'failure_prediction',
    'rul',
    'anomaly_multivariate',
    'risk_scoring',
    'kpi_prediction',
    'next_interval',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Use Case', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 4),
        Text(
          'Choose the prediction objective for your model.',
          style: AppTextStyles.pageSubtitle,
        ),
        const SizedBox(height: 20),
        UseCaseSelector(
          useCases: _useCases,
          selectedUseCase: selectedUseCase,
          onSelected: onSelected,
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!, style: GoogleFonts.inter(fontSize: 12, color: Colors.red)),
        ],
      ],
    );
  }
}
