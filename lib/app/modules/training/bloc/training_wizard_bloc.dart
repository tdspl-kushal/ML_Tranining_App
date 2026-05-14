import 'package:flutter_bloc/flutter_bloc.dart';
import 'training_wizard_event.dart';
import 'training_wizard_state.dart';
import '../repository/training_repository.dart';
import '../../../data/model/upload_session_model.dart';

class TrainingWizardBloc extends Bloc<TrainingWizardEvent, TrainingWizardState> {
  final ITrainingRepository _repository;

  TrainingWizardBloc(this._repository) : super(const WizardInitial()) {
    on<StartWizard>(_onStartWizard);
    on<UploadFile>(_onUploadFile);
    on<ConfirmFeatures>(_onConfirmFeatures);
    on<ConfirmUseCase>(_onConfirmUseCase);
    on<SubmitTraining>(_onSubmitTraining);
    on<GoToStep>(_onGoToStep);
    on<CancelWizard>(_onCancelWizard);
  }

  // Store session data across steps
  UploadSessionModel? _session;
  String? _featureSchemaId;
  List<String> _tags = [];

  void _onStartWizard(StartWizard event, Emitter<TrainingWizardState> emit) {
    _session = null;
    _featureSchemaId = null;
    _tags = [];
    emit(const WizardStep1());
  }

  Future<void> _onUploadFile(UploadFile event, Emitter<TrainingWizardState> emit) async {
    emit(WizardStep1(isUploading: true, fileName: event.fileName));

    final result = await _repository.uploadFile(event.filePath);
    result.fold(
      (failure) => emit(WizardStep1(
        isUploading: false,
        error: failure.message,
        fileName: event.fileName,
      )),
      (session) {
        _session = session;
        // Move to step 2 with all columns selected by default
        emit(WizardStep2(
          session: session,
          selectedFeatures: List<String>.from(session.columns),
        ));
      },
    );
  }

  Future<void> _onConfirmFeatures(ConfirmFeatures event, Emitter<TrainingWizardState> emit) async {
    if (_session == null) return;

    emit(WizardStep2(
      session: _session!,
      selectedFeatures: event.features,
      isSubmitting: true,
    ));

    final result = await _repository.extractFeatures(_session!.sessionId);
    result.fold(
      (failure) => emit(WizardStep2(
        session: _session!,
        selectedFeatures: event.features,
        isSubmitting: false,
        error: failure.message,
      )),
      (data) {
        _featureSchemaId = data['feature_schema_id']?.toString();
        _tags = List<String>.from(data['tags'] ?? []);
        emit(WizardStep3(
          sessionId: _session!.sessionId,
          featureSchemaId: _featureSchemaId,
          features: event.features,
          tags: _tags,
        ));
      },
    );
  }

  Future<void> _onConfirmUseCase(ConfirmUseCase event, Emitter<TrainingWizardState> emit) async {
    if (_session == null) return;

    final currentState = state;
    List<String> features = [];
    if (currentState is WizardStep3) {
      features = currentState.features;
    }

    emit(WizardStep4(
      sessionId: _session!.sessionId,
      featureSchemaId: _featureSchemaId,
      features: features,
      tags: _tags,
      useCase: event.useCase,
    ));
  }

  Future<void> _onSubmitTraining(SubmitTraining event, Emitter<TrainingWizardState> emit) async {
    final currentState = state;
    if (currentState is! WizardStep4) return;

    emit(WizardStep4(
      sessionId: currentState.sessionId,
      featureSchemaId: currentState.featureSchemaId,
      features: currentState.features,
      tags: currentState.tags,
      useCase: currentState.useCase,
      isSubmitting: true,
    ));

    final result = await _repository.trainModel(
      datasetId: currentState.sessionId,
      featureSchemaId: currentState.featureSchemaId ?? '',
      modelName: event.config.modelName,
      useCase: currentState.useCase,
      tags: currentState.tags,
      mandatoryFeatures: currentState.features.where((f) => ['raw', 'roc_1', 'roll_mean', 'roll_std'].contains(f)).toList(),
      optionalFeatures: currentState.features.where((f) => !['raw', 'roc_1', 'roll_mean', 'roll_std'].contains(f)).toList(),
      trainSplit: event.config.trainSplit,
      cvFolds: event.config.cvFold,
      hparams: event.config.hyperparameters,
    );

    result.fold(
      (failure) => emit(WizardStep4(
        sessionId: currentState.sessionId,
        featureSchemaId: currentState.featureSchemaId,
        features: currentState.features,
        tags: currentState.tags,
        useCase: currentState.useCase,
        isSubmitting: false,
        error: failure.message,
      )),
      (trainingResult) => emit(WizardSuccess(trainingResult)),
    );
  }

  void _onGoToStep(GoToStep event, Emitter<TrainingWizardState> emit) {
    // Allow navigating back to previous steps
    switch (event.step) {
      case 1:
        emit(WizardStep1(fileName: _session != null ? 'uploaded_file.parquet' : null));
        break;
      case 2:
        if (_session != null) {
          emit(WizardStep2(
            session: _session!,
            selectedFeatures: List<String>.from(_session!.columns),
          ));
        }
        break;
      case 3:
        if (_session != null) {
          emit(WizardStep3(
            sessionId: _session!.sessionId,
            featureSchemaId: _featureSchemaId,
            features: _session!.columns,
            tags: _tags,
          ));
        }
        break;
    }
  }

  void _onCancelWizard(CancelWizard event, Emitter<TrainingWizardState> emit) {
    _session = null;
    _featureSchemaId = null;
    _tags = [];
    emit(const WizardInitial());
  }
}
