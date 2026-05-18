import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/step_progress_indicator.dart';
import '../bloc/streaming_bloc.dart';
import '../bloc/streaming_event.dart';
import '../bloc/training_wizard_bloc.dart';
import '../bloc/training_wizard_event.dart';
import '../bloc/training_wizard_state.dart';
import '../repository/training_repository.dart';
import '../widgets/training_stream_modal.dart';
import '../widgets/wizard_navigation_bar.dart';
import 'steps/step1_data_source.dart';
import 'steps/step2_features.dart';
import 'steps/step3_use_case.dart';
import 'steps/step4_configuration.dart';

class TrainingWizardScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const TrainingWizardScreen({super.key, required this.onComplete});

  @override
  State<TrainingWizardScreen> createState() => _TrainingWizardScreenState();
}

class _TrainingWizardScreenState extends State<TrainingWizardScreen> {
  late final TrainingWizardBloc _bloc;

  // Step 1 state (local, before bloc handles it)
  String? _selectedFilePath;
  String? _selectedFileName;

  // Step 4 controllers
  final _modelNameController = TextEditingController(text: '');
  final _cvFoldsController = TextEditingController(text: '5');
  final _trainSplitController = TextEditingController(text: '0.8');

  // Validation flag — only show errors after first submit attempt
  bool _showValidationErrors = false;

  // Validation error for step 3 (no use case selected)


  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<TrainingWizardBloc>();
    _bloc.add(const StartWizard());
  }

  @override
  void dispose() {
    _modelNameController.dispose();
    _cvFoldsController.dispose();
    _trainSplitController.dispose();
    super.dispose();
  }

  int _getCurrentStep(TrainingWizardState state) {
    if (state is WizardStep1) return 1;
    if (state is WizardStep2) return 2;
    if (state is WizardStep3 || state is WizardStep3Loading) return 3;
    if (state is WizardStep4) return 4;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final screenSize = MediaQuery.of(context).size;

    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<TrainingWizardBloc, TrainingWizardState>(
        listener: (context, state) {
          if (state is WizardSuccess) {
            final initialResult = state.result;
            // Close the wizard
            Navigator.of(context).pop();
            widget.onComplete();
            // Open the streaming modal scoped with its own StreamingBloc
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => BlocProvider(
                create: (_) => StreamingBloc(
                  GetIt.instance<ITrainingRepository>(),
                )..add(StartStreaming(initialResult)),
                child: const TrainingStreamModal(),
              ),
            );
          }
          if (state is WizardStep4 && state.error != null) {
            AppSnackbar.showError(
                context, 'Failed to start training: ${state.error!}');
          }
          if (state is WizardStep3 && state.error != null) {
            AppSnackbar.showError(context, state.error!);
          }
          if (state is WizardStep2 && state.error != null) {
            AppSnackbar.showError(
                context, 'Failed to extract features: ${state.error!}');
          }
        },
        builder: (context, state) {
          final currentStep = _getCurrentStep(state);
          final isStep4 = state is WizardStep4;

          final isSubmitting =
              (state is WizardStep1 && state.isUploading) ||
              (state is WizardStep2 && state.isLoading) ||
              (state is WizardStep3Loading) ||
              (state is WizardStep4 && state.isSubmitting);

          double maxWidth = isStep4 ? 900 : AppDimensions.wizardModalWidth;
          if (isMobile) maxWidth = screenSize.width * 0.95;

          return Dialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 40,
              vertical: isMobile ? 24 : 40,
            ),
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
                maxHeight: isMobile
                    ? screenSize.height * 0.9
                    : AppDimensions.wizardModalMaxH + (isStep4 ? 100 : 0),
              ),
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 16 : 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isStep4 ? AppStrings.newModelTraining : AppStrings.modelTrainingConfig,
                            style: AppTextStyles.sectionTitle.copyWith(fontSize: isMobile ? 18 : 22),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close, color: AppColors.textSecondary),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    StepProgressIndicator(
                      currentStep: currentStep,
                      totalSteps: 4,
                      stepLabels: const [
                        AppStrings.dataSource,
                        AppStrings.features,
                        AppStrings.useCase,
                        AppStrings.configuration,
                      ],
                      useProgressBar: isMobile || isStep4,
                    ),
                    const SizedBox(height: 24),

                    // Content
                    Flexible(
                      child: SingleChildScrollView(
                        child: _buildStepContent(state),
                      ),
                    ),

                    const SizedBox(height: 12),

                    WizardNavigationBar(
                      currentStep: currentStep,
                      isSubmitting: isSubmitting,
                      isFinalStep: isStep4,
                      onCancel: () => Navigator.of(context).pop(),
                      onBack: currentStep > 1
                          ? () => _bloc.add(GoToStep(currentStep - 1))
                          : null,
                      onNext: isSubmitting ? null : () => _handleNext(state),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepContent(TrainingWizardState state) {
    if (state is WizardStep1) {
      return Step1DataSource(
        fileName: _selectedFileName ?? state.fileName,
        filePath: _selectedFilePath ?? state.filePath,
        isUploading: state.isUploading,
        error: state.error,
        datasetId: state.datasetId,
        onFilePicked: (path) {
          final name = path.split('/').last.split('\\').last;
          setState(() {
            _selectedFilePath = path;
            _selectedFileName = name;
          });
          // Auto-upload as soon as the file is picked.
          _bloc.add(UploadFile(filePath: path, fileName: name));
        },
        onRemoveFile: () {
          setState(() {
            _selectedFilePath = null;
            _selectedFileName = null;
          });
          // Also reset the BLoC so datasetId and preview are cleared.
          _bloc.add(const StartWizard());
        },
      );
    }

    if (state is WizardStep2) {
      // The Step2Features widget dispatches FetchFeatures(datasetId) on mount
      return Step2Features(datasetId: state.datasetId);
    }

    if (state is WizardStep3 || state is WizardStep3Loading) {
      return const Step3UseCase();
    }

    if (state is WizardStep4) {
      return Step4Configuration(
        modelNameController: _modelNameController,
        cvFoldsController: _cvFoldsController,
        trainSplitController: _trainSplitController,
        enabled: !state.isSubmitting,
        showValidationErrors: _showValidationErrors,
      );
    }

    return const SizedBox.shrink();
  }

  void _handleNext(TrainingWizardState state) {
    if (state is WizardStep1) {
      if (_selectedFilePath == null && state.filePath == null) return;
      // If the upload already succeeded (datasetId present), go straight to Step 2.
      if (state.datasetId != null) {
        _bloc.add(FetchFeatures(state.datasetId!));
        return;
      }
      if (_selectedFilePath == null) return;
      _bloc.add(UploadFile(filePath: _selectedFilePath!, fileName: _selectedFileName!));
    }

    if (state is WizardStep2) {
      // No validation needed — mandatory features always exist
      // If still loading, Next is disabled anyway
      _bloc.add(GoToStep(3));
    }

    if (state is WizardStep3) {
      if (state.selectedUseCase == null) {
        AppSnackbar.showError(context, 'Please select a use case.');
        return;
      }
      _bloc.add(FetchHparams(state.selectedUseCase!));
    }

    if (state is WizardStep4) {
      setState(() => _showValidationErrors = true);

      final name = _modelNameController.text.trim();
      final cvText = _cvFoldsController.text.trim();
      final splitText = _trainSplitController.text.trim();

      // Validate
      if (name.isEmpty || name.length < 3 || name.length > 64 || name.contains(' ')) return;
      final cvFolds = int.tryParse(cvText);
      if (cvFolds == null || cvFolds < 3 || cvFolds > 5000) return;
      final trainSplit = double.tryParse(splitText);
      if (trainSplit == null || trainSplit < 0.1 || trainSplit > 0.99) return;

      // Ensure at least one hparam selected
      final hasSelected = state.selectedParams.values.any((v) => v);
      if (!hasSelected) {
        AppSnackbar.showError(context, 'Select at least one hyperparameter.');
        return;
      }

      // Validate selected hparam values
      final allParams = {...state.hparams.tier1, ...state.hparams.tier2, ...state.hparams.tier3};
      for (final entry in allParams.entries) {
        if (state.selectedParams[entry.key] != true) continue;
        final raw = state.paramValues[entry.key] ?? '';
        if (raw.isEmpty) { AppSnackbar.showError(context, '${entry.key}: value required.'); return; }
        if (entry.value.type == 'int') {
          final n = int.tryParse(raw);
          if (n == null) { AppSnackbar.showError(context, '${entry.key}: must be integer.'); return; }
          if (entry.value.min != null && n < entry.value.min!) { AppSnackbar.showError(context, '${entry.key}: min ${entry.value.min!.toInt()}.'); return; }
          if (entry.value.max != null && n > entry.value.max!) { AppSnackbar.showError(context, '${entry.key}: max ${entry.value.max!.toInt()}.'); return; }
        } else if (entry.value.type == 'float') {
          final n = double.tryParse(raw);
          if (n == null) { AppSnackbar.showError(context, '${entry.key}: must be number.'); return; }
          if (entry.value.min != null && n < entry.value.min!) { AppSnackbar.showError(context, '${entry.key}: min ${entry.value.min}.'); return; }
          if (entry.value.max != null && n > entry.value.max!) { AppSnackbar.showError(context, '${entry.key}: max ${entry.value.max}.'); return; }
        }
      }

      _bloc.add(SubmitTraining(
        modelName: name,
        trainSplit: trainSplit,
        cvFolds: cvFolds,
      ));
    }
  }
}
