import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;
  final bool useProgressBar;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabels,
    this.useProgressBar = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useProgressBar) {
      return _buildProgressBar();
    }
    return _buildCircleStepper();
  }

  Widget _buildProgressBar() {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isActive = index == currentStep - 1;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
                decoration: BoxDecoration(
                  color: isCompleted || isActive
                      ? AppColors.primary
                      : AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Step $currentStep: ${stepLabels[currentStep - 1]}',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleStepper() {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isOdd) {
          // Connector line
          final stepBefore = index ~/ 2;
          final isCompleted = stepBefore < currentStep - 1;
          return Expanded(
            child: Container(
              height: 2,
              color: isCompleted ? AppColors.primary : AppColors.divider,
            ),
          );
        }

        final stepIndex = index ~/ 2;
        final isCompleted = stepIndex < currentStep - 1;
        final isActive = stepIndex == currentStep - 1;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppDimensions.stepCircleSize,
              height: AppDimensions.stepCircleSize,
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? AppColors.primary
                    : AppColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted || isActive
                      ? AppColors.primary
                      : AppColors.divider,
                  width: 2,
                ),
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.white,
                      )
                    : Text(
                        '${stepIndex + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? AppColors.white
                              : AppColors.textTertiary,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              stepLabels[stepIndex],
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? AppColors.primary
                    : isCompleted
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
              ),
            ),
          ],
        );
      }),
    );
  }
}
