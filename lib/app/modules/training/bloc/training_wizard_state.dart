import 'package:equatable/equatable.dart';
import '../../../data/model/feature_extract_model.dart';
import '../../../data/model/hparams_model.dart';
import '../../../data/model/training_result_model.dart';

abstract class TrainingWizardState extends Equatable {
  const TrainingWizardState();

  @override
  List<Object?> get props => [];
}

class WizardInitial extends TrainingWizardState {
  const WizardInitial();
}

// ─── Step 1: File Upload ────────────────────────────────────────────────────
class WizardStep1 extends TrainingWizardState {
  final bool isUploading;
  final String? error;
  final String? fileName;
  final String? filePath;
  /// Populated after a successful ingest — enables the preview grid.
  final String? datasetId;

  const WizardStep1({
    this.isUploading = false,
    this.error,
    this.fileName,
    this.filePath,
    this.datasetId,
  });

  WizardStep1 copyWith({
    bool? isUploading,
    String? error,
    String? fileName,
    String? filePath,
    String? datasetId,
  }) {
    return WizardStep1(
      isUploading: isUploading ?? this.isUploading,
      error: error,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      datasetId: datasetId ?? this.datasetId,
    );
  }

  @override
  List<Object?> get props => [isUploading, error, fileName, filePath, datasetId];
}

// ─── Step 2: Feature Selection ──────────────────────────────────────────────
class WizardStep2 extends TrainingWizardState {
  final String datasetId;
  final FeatureExtractModel? featureData;
  final List<String> selectedOptionalFeatures;
  final List<String> selectedCrossTagFeatures;
  final bool isLoading;
  final String? error;

  const WizardStep2({
    required this.datasetId,
    this.featureData,
    this.selectedOptionalFeatures = const [],
    this.selectedCrossTagFeatures = const [],
    this.isLoading = false,
    this.error,
  });

  WizardStep2 copyWith({
    String? datasetId,
    FeatureExtractModel? featureData,
    List<String>? selectedOptionalFeatures,
    List<String>? selectedCrossTagFeatures,
    bool? isLoading,
    String? error,
  }) {
    return WizardStep2(
      datasetId: datasetId ?? this.datasetId,
      featureData: featureData ?? this.featureData,
      selectedOptionalFeatures: selectedOptionalFeatures ?? this.selectedOptionalFeatures,
      selectedCrossTagFeatures: selectedCrossTagFeatures ?? this.selectedCrossTagFeatures,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [datasetId, featureData, selectedOptionalFeatures, selectedCrossTagFeatures, isLoading, error];
}

// ─── Step 3: Use Case Selection ─────────────────────────────────────────────
class WizardStep3 extends TrainingWizardState {
  final String? selectedUseCase;
  final String? error;

  const WizardStep3({
    this.selectedUseCase,
    this.error,
  });

  WizardStep3 copyWith({String? selectedUseCase, String? error}) {
    return WizardStep3(
      selectedUseCase: selectedUseCase ?? this.selectedUseCase,
      error: error,
    );
  }

  @override
  List<Object?> get props => [selectedUseCase, error];
}

class WizardStep3Loading extends TrainingWizardState {
  final String selectedUseCase;
  const WizardStep3Loading(this.selectedUseCase);

  @override
  List<Object?> get props => [selectedUseCase];
}

// ─── Step 4: Configuration ──────────────────────────────────────────────────
class WizardStep4 extends TrainingWizardState {
  final HparamsModel hparams;
  final Map<String, bool> selectedParams;
  final Map<String, String> paramValues;
  final String modelName;
  final int cvFolds;
  final double trainSplit;
  final bool isSubmitting;
  final String? error;
  // Carry-forward from steps 1–3
  final String datasetId;
  final String featureSchemaId;
  final String useCase;
  final List<String> tags;
  final List<String> mandatoryFeatures;
  final List<String> optionalFeatures;
  final List<String> crossTagFeatures;
  final String targetCol;

  const WizardStep4({
    required this.hparams,
    required this.selectedParams,
    required this.paramValues,
    this.modelName = '',
    this.cvFolds = 5,
    this.trainSplit = 0.8,
    this.isSubmitting = false,
    this.error,
    required this.datasetId,
    required this.featureSchemaId,
    required this.useCase,
    required this.tags,
    required this.mandatoryFeatures,
    required this.optionalFeatures,
    required this.crossTagFeatures,
    required this.targetCol,
  });

  WizardStep4 copyWith({
    HparamsModel? hparams,
    Map<String, bool>? selectedParams,
    Map<String, String>? paramValues,
    String? modelName,
    int? cvFolds,
    double? trainSplit,
    bool? isSubmitting,
    String? error,
  }) {
    return WizardStep4(
      hparams: hparams ?? this.hparams,
      selectedParams: selectedParams ?? this.selectedParams,
      paramValues: paramValues ?? this.paramValues,
      modelName: modelName ?? this.modelName,
      cvFolds: cvFolds ?? this.cvFolds,
      trainSplit: trainSplit ?? this.trainSplit,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      datasetId: datasetId,
      featureSchemaId: featureSchemaId,
      useCase: useCase,
      tags: tags,
      mandatoryFeatures: mandatoryFeatures,
      optionalFeatures: optionalFeatures,
      crossTagFeatures: crossTagFeatures,
      targetCol: targetCol,
    );
  }

  @override
  List<Object?> get props => [
        hparams, selectedParams, paramValues, modelName, cvFolds, trainSplit,
        isSubmitting, error, datasetId, featureSchemaId, useCase, tags,
        mandatoryFeatures, optionalFeatures, crossTagFeatures, targetCol,
      ];
}

// ─── Terminal States ─────────────────────────────────────────────────────────
class WizardSuccess extends TrainingWizardState {
  final TrainingResultModel result;

  const WizardSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class WizardError extends TrainingWizardState {
  final String message;

  const WizardError(this.message);

  @override
  List<Object?> get props => [message];
}
