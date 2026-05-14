import 'package:equatable/equatable.dart';
import '../../../data/model/training_config_model.dart';

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

class ConfirmFeatures extends TrainingWizardEvent {
  final List<String> features;

  const ConfirmFeatures(this.features);

  @override
  List<Object?> get props => [features];
}

class ConfirmUseCase extends TrainingWizardEvent {
  final String useCase;

  const ConfirmUseCase(this.useCase);

  @override
  List<Object?> get props => [useCase];
}

class SubmitTraining extends TrainingWizardEvent {
  final TrainingConfigModel config;

  const SubmitTraining(this.config);

  @override
  List<Object?> get props => [config];
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
