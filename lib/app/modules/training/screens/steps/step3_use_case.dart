import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../bloc/training_wizard_bloc.dart';
import '../../bloc/training_wizard_event.dart';
import '../../bloc/training_wizard_state.dart';

class Step3UseCase extends StatelessWidget {
  const Step3UseCase({super.key});

  static const _options = [
    (slug: 'failure_prediction', label: 'Failure Prediction', icon: Icons.warning_amber_rounded),
    (slug: 'rul',                label: 'RUL',                icon: Icons.timelapse_rounded),
    (slug: 'anomaly_multivariate', label: 'Anomaly Multivariate', icon: Icons.scatter_plot_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrainingWizardBloc, TrainingWizardState>(
      listener: (context, state) {
        if (state is WizardStep3 && state.error != null) {
          AppSnackbar.showError(context, state.error!);
        }
      },
      builder: (context, state) {
        final isLoading = state is WizardStep3Loading;
        final selectedUseCase = state is WizardStep3
            ? state.selectedUseCase
            : state is WizardStep3Loading
                ? state.selectedUseCase
                : null;
        final error = state is WizardStep3 ? state.error : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Use Case', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 4),
            Text(
              'Choose the prediction objective for your model.',
              style: AppTextStyles.pageSubtitle,
            ),
            const SizedBox(height: 24),

            if (isLoading)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _options.map((opt) {
                  final isSelected = selectedUseCase == opt.slug;
                  return _UseCaseCard(
                    slug: opt.slug,
                    label: opt.label,
                    icon: opt.icon,
                    isSelected: isSelected,
                    onTap: () => context.read<TrainingWizardBloc>().add(SelectUseCase(opt.slug)),
                  );
                }).toList(),
              ),

            if (error != null && !isLoading) ...[
              const SizedBox(height: 12),
              Text(
                error,
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _UseCaseCard extends StatelessWidget {
  final String slug;
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _UseCaseCard({
    required this.slug,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.inputBorder,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.primary.withAlpha(30), blurRadius: 8, offset: const Offset(0, 2))]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 32, color: isSelected ? AppColors.primary : AppColors.textSecondary),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 13, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
