import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../bloc/training_wizard_bloc.dart';
import '../../bloc/training_wizard_event.dart';
import '../../bloc/training_wizard_state.dart';

class Step2Features extends StatefulWidget {
  final String datasetId;

  const Step2Features({super.key, required this.datasetId});

  @override
  State<Step2Features> createState() => _Step2FeaturesState();
}

class _Step2FeaturesState extends State<Step2Features> {
  @override
  void initState() {
    super.initState();
    // Fire immediately on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrainingWizardBloc>().add(FetchFeatures(widget.datasetId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrainingWizardBloc, TrainingWizardState>(
      builder: (context, state) {
        if (state is! WizardStep2) return const SizedBox.shrink();

        if (state.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null && state.featureData == null) {
          return _ErrorRetry(
            message: state.error!,
            onRetry: () => context.read<TrainingWizardBloc>().add(FetchFeatures(widget.datasetId)),
          );
        }

        final featureData = state.featureData;
        if (featureData == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Feature Selection', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 4),
            Text(
              'Review the features extracted from your dataset.',
              style: AppTextStyles.pageSubtitle,
            ),
            const SizedBox(height: 24),

            // ── Section 1: Mandatory Features ─────────────────────────────
            _SectionHeader(
              title: 'Mandatory Features',
              subtitle: 'Included automatically in every training run. Cannot be deselected.',
            ),
            const SizedBox(height: 12),
            ...featureData.mandatoryFeatures.map((f) => _FeatureRow(
              feature: f,
              isSelected: true,
              isDisabled: true,
              trailingChip: _Chip(label: 'Mandatory', color: Colors.grey.shade400),
              onChanged: null,
            )),

            const SizedBox(height: 24),

            // ── Section 2: Optional Features ──────────────────────────────
            _SectionHeader(
              title: 'Optional Features',
              subtitle: 'Select additional per-tag features to include.',
            ),
            const SizedBox(height: 12),
            if (featureData.optionalFeatures.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'No optional features available.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ...featureData.optionalFeatures.map((f) => _FeatureRow(
                feature: f,
                isSelected: state.selectedOptionalFeatures.contains(f),
                isDisabled: false,
                onChanged: (_) => context.read<TrainingWizardBloc>().add(ToggleOptionalFeature(f)),
              )),

            const SizedBox(height: 24),

            // ── Section 3: Cross-Tag Features ─────────────────────────────
            _SectionHeader(
              title: 'Cross-Tag Features',
              subtitle: 'System-level features computed across all tags.',
            ),
            const SizedBox(height: 12),
            if (featureData.crossTagAvailable.isEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'No cross-tag features available.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            else
              ...featureData.crossTagAvailable.map((f) {
                final presentInData = featureData.crossTagPresentInData.contains(f);
                return _FeatureRow(
                  feature: f,
                  isSelected: state.selectedCrossTagFeatures.contains(f),
                  isDisabled: false,
                  trailingChip: presentInData
                      ? _Chip(label: 'Present in data', color: Colors.green.shade400)
                      : null,
                  onChanged: (_) => context.read<TrainingWizardBloc>().add(ToggleCrossTagFeature(f)),
                );
              }),
          ],
        );
      },
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String feature;
  final bool isSelected;
  final bool isDisabled;
  final Widget? trailingChip;
  final ValueChanged<bool?>? onChanged;

  const _FeatureRow({
    required this.feature,
    required this.isSelected,
    required this.isDisabled,
    this.trailingChip,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: Checkbox(
              value: isSelected,
              onChanged: isDisabled ? null : onChanged,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: isDisabled ? AppColors.textSecondary : AppColors.textPrimary,
              ),
            ),
          ),
          if (trailingChip != null) trailingChip!,
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 40),
            const SizedBox(height: 12),
            Text(message, style: GoogleFonts.inter(fontSize: 13, color: AppColors.error), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
