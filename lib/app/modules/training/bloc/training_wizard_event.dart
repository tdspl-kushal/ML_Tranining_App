import 'package:equatable/equatable.dart';

abstract class TrainingWizardEvent extends Equatable {
  const TrainingWizardEvent();

  @override
  List<Object?> get props => [];
}

class StartWizard extends TrainingWizardEvent {
  const StartWizard();
}

class UploadFile extends TrainingWizardEvent {
  final String filePath;
  final String fileName;

  const UploadFile({required this.filePath, required this.fileName});

  @override
  List<Object?> get props => [filePath, fileName];
}

// Step 2 events
class FetchFeatures extends TrainingWizardEvent {
  final String datasetId;
  const FetchFeatures(this.datasetId);

  @override
  List<Object?> get props => [datasetId];
}

class ToggleOptionalFeature extends TrainingWizardEvent {
  final String feature;
  const ToggleOptionalFeature(this.feature);

  @override
  List<Object?> get props => [feature];
}

class ToggleCrossTagFeature extends TrainingWizardEvent {
  final String feature;
  const ToggleCrossTagFeature(this.feature);

  @override
  List<Object?> get props => [feature];
}

// Step 3 events
class SelectUseCase extends TrainingWizardEvent {
  final String useCase;
  const SelectUseCase(this.useCase);

  @override
  List<Object?> get props => [useCase];
}

class FetchHparams extends TrainingWizardEvent {
  final String useCase;
  const FetchHparams(this.useCase);

  @override
  List<Object?> get props => [useCase];
}

// Step 4 events
class ToggleHparam extends TrainingWizardEvent {
  final String key;
  const ToggleHparam(this.key);

  @override
  List<Object?> get props => [key];
}

class UpdateHparamValue extends TrainingWizardEvent {
  final String key;
  final String value;
  const UpdateHparamValue(this.key, this.value);

  @override
  List<Object?> get props => [key, value];
}

class SelectAllHparams extends TrainingWizardEvent {
  const SelectAllHparams();
}

class SubmitTraining extends TrainingWizardEvent {
  final String modelName;
  final double trainSplit;
  final int cvFolds;

  const SubmitTraining({
    required this.modelName,
    required this.trainSplit,
    required this.cvFolds,
  });

  @override
  List<Object?> get props => [modelName, trainSplit, cvFolds];
}

class GoToStep extends TrainingWizardEvent {
  final int step;

  const GoToStep(this.step);

  @override
  List<Object?> get props => [step];
}

class CancelWizard extends TrainingWizardEvent {
  const CancelWizard();
}
