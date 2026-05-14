import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/utils/extensions.dart';

class GeneralSettingsForm extends StatelessWidget {
  final TextEditingController modelNameController;
  final int cvFold;
  final TextEditingController trainSplitController;
  final ValueChanged<int?> onCvFoldChanged;
  final String? modelNameError;
  final String? trainSplitError;
  final bool enabled;

  const GeneralSettingsForm({
    super.key,
    required this.modelNameController,
    required this.cvFold,
    required this.trainSplitController,
    required this.onCvFoldChanged,
    this.modelNameError,
    this.trainSplitError,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    final fieldsRow = Row(
      children: [
        Expanded(child: _buildCvFoldField()),
        const SizedBox(width: 16),
        Expanded(child: _buildTrainSplitField()),
      ],
    );

    final fieldsColumn = Column(
      children: [
        _buildCvFoldField(),
        const SizedBox(height: 16),
        _buildTrainSplitField(),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Settings', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 4),
        Text(
          'Define the foundational parameters for your model run.',
          style: AppTextStyles.pageSubtitle,
        ),
        const SizedBox(height: 20),
        AppTextField(
          label: 'Model Name',
          controller: modelNameController,
          hintText: 'XGBoost_v1.2_prod',
          errorText: modelNameError,
          enabled: enabled,
        ),
        const SizedBox(height: 16),
        isMobile ? fieldsColumn : fieldsRow,
      ],
    );
  }

  Widget _buildCvFoldField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('CV Fold', style: AppTextStyles.formLabel),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: cvFold,
          items: [3, 5, 10]
              .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
              .toList(),
          onChanged: enabled ? onCvFoldChanged : null,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTrainSplitField() {
    return AppTextField(
      label: 'Train Split',
      controller: trainSplitController,
      hintText: '0.8',
      suffixText: '%',
      errorText: trainSplitError,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: enabled,
    );
  }
}
