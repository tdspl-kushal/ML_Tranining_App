import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HyperparameterTable extends StatelessWidget {
  final List<Map<String, dynamic>> parameters;
  final Set<String> selectedParameters;
  final ValueChanged<String> onToggle;
  final VoidCallback onSelectAll;

  const HyperparameterTable({
    super.key,
    required this.parameters,
    required this.selectedParameters,
    required this.onToggle,
    required this.onSelectAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Hyperparameters', style: AppTextStyles.sectionTitle)),
            TextButton(
              onPressed: onSelectAll,
              child: Text(
                'Select All',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.tableBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.tableBorder)),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Text('Parameter', style: AppTextStyles.tableHeader),
                    ),
                    SizedBox(
                      width: 90,
                      child: Text(
                        'Default',
                        style: AppTextStyles.tableHeader.copyWith(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              // Rows
              ...parameters.map((param) {
                final name = param['name'] as String;
                final isSelected = selectedParameters.contains(name);
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.tableBorder)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (_) => onToggle(name),
                            activeColor: AppColors.checkboxActive,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            name,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              fontFeatures: [const FontFeature.tabularFigures()],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 90,
                          child: Text(
                            '${param['value']}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
