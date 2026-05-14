import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/step_progress_indicator.dart';
import '../../../data/model/training_config_model.dart';
import '../bloc/training_wizard_bloc.dart';
import '../bloc/training_wizard_event.dart';
import '../bloc/training_wizard_state.dart';
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

  // Step 1 state
  String? _selectedFilePath;
  String? _selectedFileName;

  // Step 2 state
  List<String> _selectedFeatures = [];

  // Step 3 state
  String? _selectedUseCase;

  // Step 4 state
  final _modelNameController = TextEditingController(text: 'XGBoost_v1.2_prod');
  final _trainSplitController = TextEditingController(text: '0.8');
  int _cvFold = 5;
  String? _modelNameError;
  String? _trainSplitError;

  final List<Map<String, dynamic>> _defaultHyperparameters = [
    {'name': 'learning_rate', 'value': 0.01},
    {'name': 'max_depth', 'value': 6},
    {'name': 'n_estimators', 'value': 100},
    {'name': 'subsample', 'value': 0.8},
    {'name': 'colsample_bytree', 'value': 0.8},
  ];

  Set<String> _selectedHyperparameters = {'learning_rate', 'max_depth', 'subsample'};

  @override
  void initState() {
    super.initState();
    _bloc = GetIt.instance<TrainingWizardBloc>();
    _bloc.add(const StartWizard());
  }

  @override
  void dispose() {
    _modelNameController.dispose();
    _trainSplitController.dispose();
    super.dispose();
  }

  int _getCurrentStep(TrainingWizardState state) {
    if (state is WizardStep1) return 1;
    if (state is WizardStep2) return 2;
    if (state is WizardStep3) return 3;
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
            Navigator.of(context).pop();
            widget.onComplete();
            AppSnackbar.showSuccess(context, 'Training started successfully!');
          }
          if (state is WizardStep4 && state.error != null) {
            AppSnackbar.showError(context, state.error!);
          }
          if (state is WizardStep2) {
            _selectedFeatures = List<String>.from(state.selectedFeatures);
          }
        },
        builder: (context, state) {
          final currentStep = _getCurrentStep(state);
          final isStep4 = state is WizardStep4;
          final isSubmitting = (state is WizardStep1 && state.isUploading) ||
              (state is WizardStep2 && state.isSubmitting) ||
              (state is WizardStep4 && state.isSubmitting);

          double maxWidth = isStep4 ? 900 : AppDimensions.wizardModalWidth;
          if (isMobile) {
            maxWidth = screenSize.width * 0.95;
          }

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
                maxHeight: isMobile ? screenSize.height * 0.9 : AppDimensions.wizardModalMaxH + (isStep4 ? 100 : 0),
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
                            style: AppTextStyles.sectionTitle.copyWith(
                              fontSize: isMobile ? 18 : 22,
                            ),
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

                    // Step indicator
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

                    // Navigation
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
        isUploading: state.isUploading,
        error: state.error,
        onFilePicked: (path) {
          setState(() {
            _selectedFilePath = path;
            _selectedFileName = path.split('/').last.split('\\').last;
          });
        },
        onRemoveFile: () {
          setState(() {
            _selectedFilePath = null;
            _selectedFileName = null;
          });
        },
      );
    }

    if (state is WizardStep2) {
      return Step2Features(
        features: state.session.columns,
        selectedFeatures: _selectedFeatures,
        onSelectionChanged: (features) {
          setState(() => _selectedFeatures = features);
        },
        error: state.error,
      );
    }

    if (state is WizardStep3) {
      return Step3UseCase(
        selectedUseCase: _selectedUseCase,
        onSelected: (useCase) {
          setState(() => _selectedUseCase = useCase);
        },
        error: state.error,
      );
    }

    if (state is WizardStep4) {
      return Step4Configuration(
        modelNameController: _modelNameController,
        cvFold: _cvFold,
        trainSplitController: _trainSplitController,
        onCvFoldChanged: (val) {
          if (val != null) setState(() => _cvFold = val);
        },
        hyperparameters: _defaultHyperparameters,
        selectedHyperparameters: _selectedHyperparameters,
        onToggleHyperparameter: (name) {
          setState(() {
            if (_selectedHyperparameters.contains(name)) {
              _selectedHyperparameters.remove(name);
            } else {
              _selectedHyperparameters.add(name);
            }
          });
        },
        onSelectAllHyperparameters: () {
          setState(() {
            _selectedHyperparameters = _defaultHyperparameters.map((p) => p['name'] as String).toSet();
          });
        },
        modelNameError: _modelNameError,
        trainSplitError: _trainSplitError,
        enabled: !state.isSubmitting,
      );
    }

    return const SizedBox.shrink();
  }

  void _handleNext(TrainingWizardState state) {
    if (state is WizardStep1) {
      if (_selectedFilePath == null) return;
      _bloc.add(UploadFile(filePath: _selectedFilePath!, fileName: _selectedFileName!));
    }

    if (state is WizardStep2) {
      if (_selectedFeatures.isEmpty) return;
      _bloc.add(ConfirmFeatures(_selectedFeatures));
    }

    if (state is WizardStep3) {
      if (_selectedUseCase == null) return;
      _bloc.add(ConfirmUseCase(_selectedUseCase!));
    }

    if (state is WizardStep4) {
      final nameError = Validators.validateModelName(_modelNameController.text);
      final splitError = Validators.validateTrainSplit(_trainSplitController.text);

      setState(() {
        _modelNameError = nameError;
        _trainSplitError = splitError;
      });

      if (nameError != null || splitError != null) return;
      if (_selectedHyperparameters.isEmpty) {
        AppSnackbar.showError(context, 'Select at least one hyperparameter');
        return;
      }

      final hparams = <String, dynamic>{};
      for (final param in _defaultHyperparameters) {
        if (_selectedHyperparameters.contains(param['name'])) {
          hparams[param['name'] as String] = param['value'];
        }
      }

      _bloc.add(SubmitTraining(TrainingConfigModel(
        sessionId: state.sessionId,
        modelName: _modelNameController.text,
        cvFold: _cvFold,
        trainSplit: double.parse(_trainSplitController.text),
        hyperparameters: hparams,
      )));
    }
  }
}
