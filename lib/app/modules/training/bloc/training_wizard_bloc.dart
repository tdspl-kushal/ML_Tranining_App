import 'package:flutter_bloc/flutter_bloc.dart';
import 'training_wizard_event.dart';
import 'training_wizard_state.dart';
import '../repository/training_repository.dart';
import '../../../data/model/feature_extract_model.dart';

import '../../../data/model/upload_session_model.dart';

class TrainingWizardBloc extends Bloc<TrainingWizardEvent, TrainingWizardState> {
  final ITrainingRepository _repository;

  TrainingWizardBloc(this._repository) : super(const WizardInitial()) {
    on<StartWizard>(_onStartWizard);
    on<UploadFile>(_onUploadFile);
    on<FetchFeatures>(_onFetchFeatures);
    on<ToggleOptionalFeature>(_onToggleOptionalFeature);
    on<ToggleCrossTagFeature>(_onToggleCrossTagFeature);
    on<SelectUseCase>(_onSelectUseCase);
    on<FetchHparams>(_onFetchHparams);
    on<ToggleHparam>(_onToggleHparam);
    on<UpdateHparamValue>(_onUpdateHparamValue);
    on<SelectAllHparams>(_onSelectAllHparams);
    on<SubmitTraining>(_onSubmitTraining);
    on<GoToStep>(_onGoToStep);
    on<CancelWizard>(_onCancelWizard);
  }

  // Stored across steps
  UploadSessionModel? _session;
  FeatureExtractModel? _featureData;
  List<String> _selectedOptionalFeatures = [];
  List<String> _selectedCrossTagFeatures = [];
  String? _filePath;
  String? _selectedUseCase;

  void _onStartWizard(StartWizard event, Emitter<TrainingWizardState> emit) {
    _session = null;
    _featureData = null;
    _selectedOptionalFeatures = [];
    _selectedCrossTagFeatures = [];
    _filePath = null;
    _selectedUseCase = null;
    emit(const WizardStep1());
  }

  Future<void> _onUploadFile(UploadFile event, Emitter<TrainingWizardState> emit) async {
    _filePath = event.filePath;
    emit(WizardStep1(isUploading: true, fileName: event.fileName, filePath: event.filePath));

    final result = await _repository.uploadFile(event.filePath);
    result.fold(
      (failure) => emit(WizardStep1(
        isUploading: false,
        error: failure.message,
        fileName: event.fileName,
        filePath: event.filePath,
      )),
      (session) {
        _session = session;
        // Stay on Step 1 with the datasetId so the preview grid is shown.
        // The user clicks Next to advance to Step 2 / feature extraction.
        emit(WizardStep1(
          isUploading: false,
          fileName: event.fileName,
          filePath: event.filePath,
          datasetId: session.sessionId,
        ));
      },
    );
  }

  Future<void> _onFetchFeatures(FetchFeatures event, Emitter<TrainingWizardState> emit) async {
    emit(WizardStep2(datasetId: event.datasetId, isLoading: true));

    final result = await _repository.extractFeatures(event.datasetId);
    result.fold(
      (failure) => emit(WizardStep2(datasetId: event.datasetId, isLoading: false, error: failure.message)),
      (featureData) {
        _featureData = featureData;
        _selectedOptionalFeatures = [];
        _selectedCrossTagFeatures = [];
        emit(WizardStep2(
          datasetId: event.datasetId,
          featureData: featureData,
          selectedOptionalFeatures: const [],
          selectedCrossTagFeatures: const [],
          isLoading: false,
        ));
      },
    );
  }

  void _onToggleOptionalFeature(ToggleOptionalFeature event, Emitter<TrainingWizardState> emit) {
    if (state is! WizardStep2) return;
    final s = state as WizardStep2;
    final updated = List<String>.from(s.selectedOptionalFeatures);
    if (updated.contains(event.feature)) {
      updated.remove(event.feature);
    } else {
      updated.add(event.feature);
    }
    _selectedOptionalFeatures = updated;
    emit(s.copyWith(selectedOptionalFeatures: updated));
  }

  void _onToggleCrossTagFeature(ToggleCrossTagFeature event, Emitter<TrainingWizardState> emit) {
    if (state is! WizardStep2) return;
    final s = state as WizardStep2;
    final updated = List<String>.from(s.selectedCrossTagFeatures);
    if (updated.contains(event.feature)) {
      updated.remove(event.feature);
    } else {
      updated.add(event.feature);
    }
    _selectedCrossTagFeatures = updated;
    emit(s.copyWith(selectedCrossTagFeatures: updated));
  }

  void _onSelectUseCase(SelectUseCase event, Emitter<TrainingWizardState> emit) {
    _selectedUseCase = event.useCase;
    emit(WizardStep3(selectedUseCase: event.useCase));
  }

  Future<void> _onFetchHparams(FetchHparams event, Emitter<TrainingWizardState> emit) async {
    _selectedUseCase = event.useCase;
    emit(WizardStep3Loading(event.useCase));

    final result = await _repository.getHparams(event.useCase);
    result.fold(
      (failure) => emit(WizardStep3(selectedUseCase: event.useCase, error: failure.message)),
      (hparams) {
        // Initialize selectedParams: tier1 all true, tier2/tier3 false
        final selectedParams = <String, bool>{};
        final paramValues = <String, String>{};

        for (final e in hparams.tier1.entries) {
          selectedParams[e.key] = true;
          paramValues[e.key] = e.value.value.toString();
        }
        for (final e in hparams.tier2.entries) {
          selectedParams[e.key] = false;
          paramValues[e.key] = e.value.value.toString();
        }
        for (final e in hparams.tier3.entries) {
          selectedParams[e.key] = false;
          paramValues[e.key] = e.value.value.toString();
        }

        emit(WizardStep4(
          hparams: hparams,
          selectedParams: selectedParams,
          paramValues: paramValues,
          datasetId: _session?.sessionId ?? '',
          featureSchemaId: _featureData?.featureSchemaId ?? '',
          useCase: event.useCase,
          tags: _featureData?.tags ?? [],
          mandatoryFeatures: _featureData?.mandatoryFeatures ?? [],
          optionalFeatures: _selectedOptionalFeatures,
          crossTagFeatures: _selectedCrossTagFeatures,
          targetCol: _featureData?.targetCol ?? '',
        ));
      },
    );
  }

  void _onToggleHparam(ToggleHparam event, Emitter<TrainingWizardState> emit) {
    if (state is! WizardStep4) return;
    final s = state as WizardStep4;
    final updated = Map<String, bool>.from(s.selectedParams);
    updated[event.key] = !(updated[event.key] ?? false);
    emit(s.copyWith(selectedParams: updated));
  }

  void _onUpdateHparamValue(UpdateHparamValue event, Emitter<TrainingWizardState> emit) {
    if (state is! WizardStep4) return;
    final s = state as WizardStep4;
    final updated = Map<String, String>.from(s.paramValues);
    updated[event.key] = event.value;
    emit(s.copyWith(paramValues: updated));
  }

  void _onSelectAllHparams(SelectAllHparams event, Emitter<TrainingWizardState> emit) {
    if (state is! WizardStep4) return;
    final s = state as WizardStep4;
    final allKeys = {
      ...s.hparams.tier1.keys,
      ...s.hparams.tier2.keys,
      ...s.hparams.tier3.keys,
    };
    // If all selected → reset to tier1 only; otherwise → select all
    final allSelected = allKeys.every((k) => s.selectedParams[k] == true);
    final updated = <String, bool>{};
    for (final k in allKeys) {
      updated[k] = allSelected ? s.hparams.tier1.containsKey(k) : true;
    }
    emit(s.copyWith(selectedParams: updated));
  }

  Future<void> _onSubmitTraining(SubmitTraining event, Emitter<TrainingWizardState> emit) async {
    if (state is! WizardStep4) return;
    final s = state as WizardStep4;

    emit(s.copyWith(isSubmitting: true, error: null));

    // Build hparams payload — only selected, cast to correct type
    final hparams = <String, dynamic>{};
    final allParams = {
      ...s.hparams.tier1,
      ...s.hparams.tier2,
      ...s.hparams.tier3,
    };
    for (final entry in allParams.entries) {
      if (s.selectedParams[entry.key] == true) {
        final raw = s.paramValues[entry.key] ?? entry.value.value.toString();
        if (entry.value.type == 'int') {
          hparams[entry.key] = int.tryParse(raw) ?? entry.value.value;
        } else if (entry.value.type == 'float') {
          hparams[entry.key] = double.tryParse(raw) ?? entry.value.value;
        } else {
          hparams[entry.key] = raw;
        }
      }
    }

    final payload = {
      'dataset_id': s.datasetId,
      'feature_schema_id': s.featureSchemaId,
      'model_name': event.modelName,
      'use_case': s.useCase,
      'tags': s.tags,
      'mandatory_features': s.mandatoryFeatures,
      'optional_features': s.optionalFeatures,
      'cross_tag_features': s.crossTagFeatures,
      'include_cross_tag_features': s.crossTagFeatures.isNotEmpty,
      'target_col': s.targetCol,
      'train_split': event.trainSplit,
      'cv_folds': event.cvFolds,
      'hparams': hparams,
    };

    final result = await _repository.trainModel(payload);
    result.fold(
      (failure) => emit(s.copyWith(isSubmitting: false, error: failure.message)),
      (trainingResult) => emit(WizardSuccess(trainingResult)),
    );
  }

  void _onGoToStep(GoToStep event, Emitter<TrainingWizardState> emit) {
    switch (event.step) {
      case 1:
        emit(WizardStep1(
          fileName: _session != null ? 'uploaded_file.parquet' : null,
          filePath: _filePath,
        ));
        break;
      case 2:
        if (_featureData != null) {
          emit(WizardStep2(
            datasetId: _session?.sessionId ?? '',
            featureData: _featureData,
            selectedOptionalFeatures: _selectedOptionalFeatures,
            selectedCrossTagFeatures: _selectedCrossTagFeatures,
          ));
        } else if (_session != null) {
          emit(WizardStep2(datasetId: _session!.sessionId));
        }
        break;
      case 3:
        emit(WizardStep3(selectedUseCase: _selectedUseCase));
        break;
    }
  }

  void _onCancelWizard(CancelWizard event, Emitter<TrainingWizardState> emit) {
    _session = null;
    _featureData = null;
    _selectedOptionalFeatures = [];
    _selectedCrossTagFeatures = [];
    _filePath = null;
    _selectedUseCase = null;
    emit(const WizardInitial());
  }
}
