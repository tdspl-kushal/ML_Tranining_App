import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import '../bloc/leaderboard_bloc.dart';
import '../bloc/leaderboard_event.dart';
import '../bloc/leaderboard_state.dart';
import 'expanded_model_detail.dart';

class LeaderboardRow extends StatefulWidget {
  final LeaderboardEntryModel entry;
  final String? activeFilter;
  final bool isExpanded;
  final VoidCallback onToggle;

  const LeaderboardRow({
    super.key,
    required this.entry,
    this.activeFilter,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  State<LeaderboardRow> createState() => _LeaderboardRowState();
}

class _LeaderboardRowState extends State<LeaderboardRow> {
  bool _isHovered = false;

  void _showDeleteConfirmation(
      BuildContext context, String modelId, String modelName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Model'),
        content: Text(
          'Are you sure you want to delete "$modelName"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<LeaderboardBloc>().add(DeleteModel(modelId));
            },
            child:
                const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDynamicMetric(double? val) {
    if (val == null) return '—';
    return val.toMetric();
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final displayName = entry.displayName;
    final downloadName = entry.modelName ?? 'model_v${entry.version}';
    final bool isAll = widget.activeFilter == null;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primaryLight.withOpacity(0.3)
                  : AppColors.white,
              border: Border(
                bottom: const BorderSide(color: AppColors.tableBorder),
                left: BorderSide(
                  color: _isHovered ? AppColors.primary : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Expand toggle
                SizedBox(
                  width: 40,
                  child: IconButton(
                    onPressed: widget.onToggle,
                    icon: Icon(
                      widget.isExpanded
                          ? Icons.indeterminate_check_box_outlined
                          : Icons.add_box_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                // Model name with status dot
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: entry.status == 'completed'
                              ? AppColors.statusActive
                              : entry.status == 'training'
                                  ? Colors.amber
                                  : entry.status == 'error'
                                      ? AppColors.error
                                      : AppColors.statusInactive,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          displayName,
                          style: AppTextStyles.tableRow,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Use case — use toUseCaseLabel()
                if (isAll)
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.useCase.toUseCaseLabel(),
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.textSecondary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                // Col 1
                if (!isAll)
                  SizedBox(
                    width: 100,
                    child: Text(
                        _formatDynamicMetric(entry.impPrimaryValue),
                        style: AppTextStyles.metricValue),
                  ),
                // Col 2
                if (!isAll)
                  SizedBox(
                    width: 100,
                    child: Text(
                        _formatDynamicMetric(entry.impSecondaryValue),
                        style: AppTextStyles.metricValue),
                  ),
                // Col 3
                if (!isAll)
                  SizedBox(
                    width: 100,
                    child: Text(
                        _formatDynamicMetric(entry.impTertiaryValue),
                        style: AppTextStyles.metricValue),
                  ),
                // Actions
                SizedBox(
                  width: 100,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: _isHovered ? 1.0 : 0.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocConsumer<LeaderboardBloc, LeaderboardState>(
                          listener: (context, state) {
                            if (state is ModelDownloadSuccess) {
                              AppSnackbar.showSuccess(
                                  context, 'Model saved to ${state.filePath}');
                              OpenFile.open(state.filePath);
                            }
                            if (state is ModelDownloadError) {
                              AppSnackbar.showError(context, state.message);
                            }
                            if (state is ModelDeleteSuccess) {
                              AppSnackbar.showSuccess(
                                  context, 'Model deleted successfully');
                            }
                            if (state is ModelDeleteError) {
                              AppSnackbar.showError(context, state.message);
                            }
                          },
                          builder: (context, state) {
                            final isDownloading = state is ModelDownloading &&
                                state.modelId == entry.id;

                            return isDownloading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.download_outlined,
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    tooltip: 'Download model',
                                    onPressed: _isHovered
                                        ? () => context
                                            .read<LeaderboardBloc>()
                                            .add(DownloadModel(
                                                entry.id, downloadName))
                                        : null,
                                  );
                          },
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              size: 20, color: AppColors.textSecondary),
                          tooltip: 'Delete model',
                          onPressed: _isHovered
                              ? () => _showDeleteConfirmation(
                                  context, entry.id, displayName)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded detail
          if (widget.isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ExpandedModelDetail(entry: entry),
            ),
        ],
      ),
    );
  }
}
