import 'package:equatable/equatable.dart';
import '../../../data/model/upload_session_model.dart';
import '../../../data/model/training_result_model.dart';

abstract class TrainingWizardState extends Equatable {
  const TrainingWizardState();

  @override
  List<Object?> get props => [];
}

class WizardInitial extends TrainingWizardState {
  const WizardInitial();
}

class WizardStep1 extends TrainingWizardState {
  final bool isUploading;
  final String? error;
  final String? fileName;

  const WizardStep1({
    this.isUploading = false,
    this.error,
    this.fileName,
  });

  WizardStep1 copyWith({bool? isUploading, String? error, String? fileName}) {
    return WizardStep1(
      isUploading: isUploading ?? this.isUploading,
      error: error,
      fileName: fileName ?? this.fileName,
    );
  }

  @override
  List<Object?> get props => [isUploading, error, fileName];
}

class WizardStep2 extends TrainingWizardState {
  final UploadSessionModel session;
  final List<String> selectedFeatures;
  final bool isSubmitting;
  final String? error;

  const WizardStep2({
    required this.session,
    required this.selectedFeatures,
    this.isSubmitting = false,
    this.error,
  });

  @override
  List<Object?> get props => [session, selectedFeatures, isSubmitting, error];
}

class WizardStep3 extends TrainingWizardState {
  final String sessionId;
  final String? featureSchemaId;
  final List<String> features;
  final List<String> tags;
  final String? selectedUseCase;
  final bool isSubmitting;
  final String? error;

  const WizardStep3({
    required this.sessionId,
    this.featureSchemaId,
    required this.features,
    this.tags = const [],
    this.selectedUseCase,
    this.isSubmitting = false,
    this.error,
  });

  @override
  List<Object?> get props => [sessionId, featureSchemaId, features, tags, selectedUseCase, isSubmitting, error];
}

class WizardStep4 extends TrainingWizardState {
  final String sessionId;
  final String? featureSchemaId;
  final List<String> features;
  final List<String> tags;
  final String useCase;
  final bool isSubmitting;
  final String? error;

  const WizardStep4({
    required this.sessionId,
    this.featureSchemaId,
    required this.features,
    this.tags = const [],
    required this.useCase,
    this.isSubmitting = false,
    this.error,
  });

  @override
  List<Object?> get props => [sessionId, featureSchemaId, features, tags, useCase, isSubmitting, error];
}

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
