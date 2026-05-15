import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../data/model/hparams_model.dart';
import '../../bloc/training_wizard_bloc.dart';
import '../../bloc/training_wizard_event.dart';
import '../../bloc/training_wizard_state.dart';

class Step4Configuration extends StatefulWidget {
  final TextEditingController modelNameController;
  final TextEditingController cvFoldsController;
  final TextEditingController trainSplitController;
  final bool enabled;
  final bool showValidationErrors;

  const Step4Configuration({
    super.key,
    required this.modelNameController,
    required this.cvFoldsController,
    required this.trainSplitController,
    this.enabled = true,
    this.showValidationErrors = false,
  });

  @override
  State<Step4Configuration> createState() => _Step4ConfigurationState();
}

class _Step4ConfigurationState extends State<Step4Configuration> {
  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return BlocBuilder<TrainingWizardBloc, TrainingWizardState>(
      builder: (context, state) {
        if (state is! WizardStep4) return const SizedBox.shrink();

        final left = _GeneralSettingsForm(
          modelNameController: widget.modelNameController,
          cvFoldsController: widget.cvFoldsController,
          trainSplitController: widget.trainSplitController,
          enabled: widget.enabled,
          showErrors: widget.showValidationErrors,
        );

        final right = _HyperparameterPanel(
          hparams: state.hparams,
          selectedParams: state.selectedParams,
          paramValues: state.paramValues,
          enabled: widget.enabled,
          showErrors: widget.showValidationErrors,
        );

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: 32),
              Expanded(child: right),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [left, const SizedBox(height: 32), right],
        );
      },
    );
  }
}

// ── General Settings ─────────────────────────────────────────────────────────

class _GeneralSettingsForm extends StatelessWidget {
  final TextEditingController modelNameController;
  final TextEditingController cvFoldsController;
  final TextEditingController trainSplitController;
  final bool enabled;
  final bool showErrors;

  const _GeneralSettingsForm({
    required this.modelNameController,
    required this.cvFoldsController,
    required this.trainSplitController,
    required this.enabled,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('General Settings', style: AppTextStyles.sectionTitle),
        const SizedBox(height: 20),

        // Model Name
        _FieldLabel('Model Name'),
        const SizedBox(height: 6),
        _StyledField(
          controller: modelNameController,
          hintText: 'e.g. XGBoost_failure_v1',
          enabled: enabled,
          errorText: showErrors ? _validateModelName(modelNameController.text) : null,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r' '))],
        ),
        const SizedBox(height: 20),

        // CV Folds
        _FieldLabel('CV Folds'),
        const SizedBox(height: 6),
        _StyledField(
          controller: cvFoldsController,
          hintText: '5',
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          errorText: showErrors ? _validateCvFolds(cvFoldsController.text) : null,
        ),
        const SizedBox(height: 20),

        // Train Split
        _FieldLabel('Train Split'),
        const SizedBox(height: 6),
        _StyledField(
          controller: trainSplitController,
          hintText: '0.8',
          enabled: enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          suffix: '%',
          errorText: showErrors ? _validateTrainSplit(trainSplitController.text) : null,
        ),
      ],
    );
  }

  String? _validateModelName(String v) {
    if (v.isEmpty) return 'Required';
    if (v.length < 3) return 'Min 3 characters';
    if (v.length > 64) return 'Max 64 characters';
    if (v.contains(' ')) return 'No spaces allowed';
    return null;
  }

  String? _validateCvFolds(String v) {
    if (v.isEmpty) return 'Required';
    final n = int.tryParse(v);
    if (n == null) return 'Must be a whole number';
    if (n < 3 || n > 5000) return 'Must be between 3 and 5000';
    return null;
  }

  String? _validateTrainSplit(String v) {
    if (v.isEmpty) return 'Required';
    final n = double.tryParse(v);
    if (n == null) return 'Must be a decimal number';
    if (n < 0.1 || n > 0.99) return 'Must be between 0.1 and 0.99';
    return null;
  }
}

// ── Hyperparameter Panel ─────────────────────────────────────────────────────

class _HyperparameterPanel extends StatelessWidget {
  final HparamsModel hparams;
  final Map<String, bool> selectedParams;
  final Map<String, String> paramValues;
  final bool enabled;
  final bool showErrors;

  const _HyperparameterPanel({
    required this.hparams,
    required this.selectedParams,
    required this.paramValues,
    required this.enabled,
    required this.showErrors,
  });

  @override
  Widget build(BuildContext context) {
    final allKeys = {...hparams.tier1.keys, ...hparams.tier2.keys, ...hparams.tier3.keys};
    final allSelected = allKeys.isNotEmpty && allKeys.every((k) => selectedParams[k] == true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Hyperparameters', style: AppTextStyles.sectionTitle)),
            TextButton(
              onPressed: enabled
                  ? () => context.read<TrainingWizardBloc>().add(const SelectAllHparams())
                  : null,
              child: Text(
                allSelected ? 'Reset to Default' : 'Select All',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
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
              if (hparams.tier1.isNotEmpty) ...[
                _TierDivider('Tier 1'),
                ...hparams.tier1.entries.map((e) => _HparamRow(
                  paramKey: e.key,
                  definition: e.value,
                  isSelected: selectedParams[e.key] ?? true,
                  currentValue: paramValues[e.key] ?? e.value.value.toString(),
                  enabled: enabled,
                  showError: showErrors,
                )),
              ],
              if (hparams.tier2.isNotEmpty) ...[
                _TierDivider('Tier 2'),
                ...hparams.tier2.entries.map((e) => _HparamRow(
                  paramKey: e.key,
                  definition: e.value,
                  isSelected: selectedParams[e.key] ?? false,
                  currentValue: paramValues[e.key] ?? e.value.value.toString(),
                  enabled: enabled,
                  showError: showErrors,
                )),
              ],
              if (hparams.tier3.isNotEmpty) ...[
                _TierDivider('Tier 3'),
                ...hparams.tier3.entries.map((e) => _HparamRow(
                  paramKey: e.key,
                  definition: e.value,
                  isSelected: selectedParams[e.key] ?? false,
                  currentValue: paramValues[e.key] ?? e.value.value.toString(),
                  enabled: enabled,
                  showError: showErrors,
                )),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TierDivider extends StatelessWidget {
  final String label;
  const _TierDivider(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: const BoxDecoration(
        color: AppColors.scaffoldBg,
        border: Border(bottom: BorderSide(color: AppColors.tableBorder)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondary, letterSpacing: 0.5),
      ),
    );
  }
}

class _HparamRow extends StatefulWidget {
  final String paramKey;
  final HparamDefinition definition;
  final bool isSelected;
  final String currentValue;
  final bool enabled;
  final bool showError;

  const _HparamRow({
    required this.paramKey,
    required this.definition,
    required this.isSelected,
    required this.currentValue,
    required this.enabled,
    required this.showError,
  });

  @override
  State<_HparamRow> createState() => _HparamRowState();
}

class _HparamRowState extends State<_HparamRow> {
  late final TextEditingController _ctrl;
  String? _error;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.currentValue);
  }

  @override
  void didUpdateWidget(_HparamRow old) {
    super.didUpdateWidget(old);
    if (old.currentValue != widget.currentValue && _ctrl.text != widget.currentValue) {
      _ctrl.text = widget.currentValue;
    }
    if (widget.showError) _validate(_ctrl.text);
  }

  void _validate(String v) {
    setState(() {
      if (v.isEmpty) { _error = 'Required'; return; }
      final def = widget.definition;
      if (def.type == 'int') {
        final n = int.tryParse(v);
        if (n == null) { _error = 'Must be integer'; return; }
        if (def.min != null && n < def.min!) { _error = 'Min ${def.min!.toInt()}'; return; }
        if (def.max != null && n > def.max!) { _error = 'Max ${def.max!.toInt()}'; return; }
      } else if (def.type == 'float') {
        final n = double.tryParse(v);
        if (n == null) { _error = 'Must be number'; return; }
        if (def.min != null && n < def.min!) { _error = 'Min ${def.min}'; return; }
        if (def.max != null && n > def.max!) { _error = 'Max ${def.max}'; return; }
      }
      _error = null;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.tableBorder))),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            child: Checkbox(
              value: widget.isSelected,
              onChanged: widget.enabled
                  ? (_) => context.read<TrainingWizardBloc>().add(ToggleHparam(widget.paramKey))
                  : null,
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.paramKey,
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                ),
                if (widget.definition.description.isNotEmpty)
                  Text(
                    widget.definition.description,
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (widget.isSelected)
            SizedBox(
              width: 120,
              child: TextField(
                controller: _ctrl,
                enabled: widget.enabled,
                keyboardType: widget.definition.type == 'int'
                    ? TextInputType.number
                    : widget.definition.type == 'float'
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.text,
                inputFormatters: widget.definition.type == 'int'
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                style: GoogleFonts.inter(fontSize: 13),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: _error != null ? AppColors.error : AppColors.inputBorder,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  errorText: _error,
                  errorStyle: GoogleFonts.inter(fontSize: 10),
                ),
                onChanged: (v) {
                  if (widget.showError) _validate(v);
                  context.read<TrainingWizardBloc>().add(UpdateHparamValue(widget.paramKey, v));
                },
              ),
            ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary));
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool enabled;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? suffix;

  const _StyledField({
    required this.controller,
    required this.hintText,
    this.enabled = true,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: GoogleFonts.inter(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
        suffixText: suffix,
        errorText: errorText,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),
    );
  }
}
