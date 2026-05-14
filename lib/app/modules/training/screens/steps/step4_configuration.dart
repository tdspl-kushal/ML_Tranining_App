import 'package:flutter/material.dart';
import '../../../../core/utils/extensions.dart';
import '../../widgets/general_settings_form.dart';
import '../../widgets/hyperparameter_table.dart';

class Step4Configuration extends StatelessWidget {
  final TextEditingController modelNameController;
  final int cvFold;
  final TextEditingController trainSplitController;
  final ValueChanged<int?> onCvFoldChanged;
  final List<Map<String, dynamic>> hyperparameters;
  final Set<String> selectedHyperparameters;
  final ValueChanged<String> onToggleHyperparameter;
  final VoidCallback onSelectAllHyperparameters;
  final String? modelNameError;
  final String? trainSplitError;
  final bool enabled;

  const Step4Configuration({
    super.key,
    required this.modelNameController,
    required this.cvFold,
    required this.trainSplitController,
    required this.onCvFoldChanged,
    required this.hyperparameters,
    required this.selectedHyperparameters,
    required this.onToggleHyperparameter,
    required this.onSelectAllHyperparameters,
    this.modelNameError,
    this.trainSplitError,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GeneralSettingsForm(
              modelNameController: modelNameController,
              cvFold: cvFold,
              trainSplitController: trainSplitController,
              onCvFoldChanged: onCvFoldChanged,
              modelNameError: modelNameError,
              trainSplitError: trainSplitError,
              enabled: enabled,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: HyperparameterTable(
              parameters: hyperparameters,
              selectedParameters: selectedHyperparameters,
              onToggle: onToggleHyperparameter,
              onSelectAll: onSelectAllHyperparameters,
            ),
          ),
        ],
      );
    }

    // Stacked for tablet/mobile
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GeneralSettingsForm(
          modelNameController: modelNameController,
          cvFold: cvFold,
          trainSplitController: trainSplitController,
          onCvFoldChanged: onCvFoldChanged,
          modelNameError: modelNameError,
          trainSplitError: trainSplitError,
          enabled: enabled,
        ),
        const SizedBox(height: 32),
        HyperparameterTable(
          parameters: hyperparameters,
          selectedParameters: selectedHyperparameters,
          onToggle: onToggleHyperparameter,
          onSelectAll: onSelectAllHyperparameters,
        ),
      ],
    );
  }
}
