import 'package:flutter/material.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';

class WizardNavigationBar extends StatelessWidget {
  final int currentStep;
  final bool isSubmitting;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final VoidCallback onCancel;
  final bool isFinalStep;

  const WizardNavigationBar({
    super.key,
    required this.currentStep,
    this.isSubmitting = false,
    this.onNext,
    this.onBack,
    required this.onCancel,
    this.isFinalStep = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          if (currentStep > 1)
            AppButton(
              label: AppStrings.back,
              isOutlined: true,
              onPressed: isSubmitting ? null : onBack,
            )
          else
            TextButton(
              onPressed: isSubmitting ? null : onCancel,
              child: const Text(AppStrings.cancel),
            ),
          const Spacer(),
          AppButton(
            label: isFinalStep ? AppStrings.trainModel : AppStrings.next,
            prefixIcon: isFinalStep ? Icons.play_arrow : Icons.arrow_forward,
            isLoading: isSubmitting,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
