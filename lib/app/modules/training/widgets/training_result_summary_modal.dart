import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/model/training_result_model.dart';
import '../../leaderboard/bloc/leaderboard_bloc.dart';
import '../../leaderboard/bloc/leaderboard_event.dart';

class TrainingResultSummaryModal extends StatelessWidget {
  final TrainingResultModel result;

  const TrainingResultSummaryModal({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Training Successful',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Fields
              _InfoRow(
                label: 'Model Name',
                value: result.modelName.isNotEmpty
                    ? result.modelName
                    : result.modelId,
              ),
              _InfoRow(
                label: 'Status',
                value: result.status.isNotEmpty
                    ? '${result.status[0].toUpperCase()}${result.status.substring(1)}'
                    : '—',
              ),
              _InfoRow(
                label: 'Use Case',
                value: result.useCase.isNotEmpty
                    ? result.useCase.toUseCaseLabel()
                    : '—',
              ),
              if (result.trainingDurationSeconds != null)
                _InfoRow(
                  label: 'Duration',
                  value:
                      '${result.trainingDurationSeconds!.toStringAsFixed(2)}s',
                ),

              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),

              // Close button
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Dispatch RefreshLeaderboard — respects active filter
                    try {
                      context
                          .read<LeaderboardBloc>()
                          .add(const RefreshLeaderboard());
                    } catch (_) {
                      // LeaderboardBloc may not be in scope — that's fine
                    }
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
