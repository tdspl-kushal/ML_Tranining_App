import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../widgets/feature_selection_list.dart';

class Step2Features extends StatelessWidget {
  final List<String> features;
  final List<String> selectedFeatures;
  final ValueChanged<List<String>> onSelectionChanged;
  final String? error;

  const Step2Features({
    super.key,
    required this.features,
    required this.selectedFeatures,
    required this.onSelectionChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Features', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 4),
        Text(
          'Choose the features to include in model training.',
          style: AppTextStyles.pageSubtitle,
        ),
        const SizedBox(height: 8),
        Text(
          '${selectedFeatures.length} of ${features.length} selected',
          style: GoogleFonts.inter(fontSize: 12, color: AppTextStyles.pageSubtitle.color),
        ),
        const SizedBox(height: 16),
        FeatureSelectionList(
          features: features,
          selectedFeatures: selectedFeatures,
          onSelectionChanged: onSelectionChanged,
        ),
        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!, style: GoogleFonts.inter(fontSize: 12, color: Colors.red)),
        ],
      ],
    );
  }
}
