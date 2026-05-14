import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

class FeatureSelectionList extends StatelessWidget {
  final List<String> features;
  final List<String> selectedFeatures;
  final ValueChanged<List<String>> onSelectionChanged;

  const FeatureSelectionList({
    super.key,
    required this.features,
    required this.selectedFeatures,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: features.map((feature) {
        final isSelected = selectedFeatures.contains(feature);
        return CheckboxListTile(
          value: isSelected,
          onChanged: (checked) {
            final updated = List<String>.from(selectedFeatures);
            if (checked == true) {
              updated.add(feature);
            } else {
              updated.remove(feature);
            }
            onSelectionChanged(updated);
          },
          title: Text(
            feature,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            _inferDataType(feature),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textTertiary,
            ),
          ),
          activeColor: AppColors.checkboxActive,
          controlAffinity: ListTileControlAffinity.leading,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        );
      }).toList(),
    );
  }

  String _inferDataType(String feature) {
    final lower = feature.toLowerCase();
    if (lower.contains('timestamp') || lower.contains('date') || lower.contains('time')) {
      return 'datetime';
    }
    if (lower.contains('id') || lower.contains('tag') || lower.contains('name')) {
      return 'categorical';
    }
    return 'numeric';
  }
}
