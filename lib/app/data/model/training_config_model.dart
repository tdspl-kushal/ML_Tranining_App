import 'package:equatable/equatable.dart';

class TrainingConfigModel extends Equatable {
  final String sessionId;
  final String modelName;
  final int cvFold;
  final double trainSplit;
  final Map<String, dynamic> hyperparameters;

  const TrainingConfigModel({
    required this.sessionId,
    required this.modelName,
    required this.cvFold,
    required this.trainSplit,
    required this.hyperparameters,
  });

  factory TrainingConfigModel.fromJson(Map<String, dynamic> json) {
    return TrainingConfigModel(
      sessionId: json['session_id'] ?? '',
      modelName: json['model_name'] ?? '',
      cvFold: json['cv_fold'] ?? json['cv_folds'] ?? 5,
      trainSplit: (json['train_split'] ?? 0.8).toDouble(),
      hyperparameters: Map<String, dynamic>.from(json['hyperparameters'] ?? json['hparams'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_name': modelName,
      'cv_fold': cvFold,
      'train_split': trainSplit,
      'hyperparameters': hyperparameters,
    };
  }

  TrainingConfigModel copyWith({
    String? sessionId,
    String? modelName,
    int? cvFold,
    double? trainSplit,
    Map<String, dynamic>? hyperparameters,
  }) {
    return TrainingConfigModel(
      sessionId: sessionId ?? this.sessionId,
      modelName: modelName ?? this.modelName,
      cvFold: cvFold ?? this.cvFold,
      trainSplit: trainSplit ?? this.trainSplit,
      hyperparameters: hyperparameters ?? this.hyperparameters,
    );
  }

  @override
  List<Object?> get props => [sessionId, modelName, cvFold, trainSplit, hyperparameters];
}
