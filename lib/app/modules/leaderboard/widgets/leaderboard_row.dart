import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import 'expanded_model_detail.dart';

class LeaderboardRow extends StatefulWidget {
  final LeaderboardEntryModel entry;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LeaderboardRow({
    super.key,
    required this.entry,
    required this.isExpanded,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<LeaderboardRow> createState() => _LeaderboardRowState();
}

class _LeaderboardRowState extends State<LeaderboardRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.scaffoldBg : Colors.transparent,
              border: const Border(bottom: BorderSide(color: AppColors.tableBorder)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                // Expand toggle
                SizedBox(
                  width: 40,
                  child: IconButton(
                    onPressed: widget.onToggle,
                    icon: Icon(
                      widget.isExpanded ? Icons.indeterminate_check_box_outlined : Icons.add_box_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                // Model name with status dot
                SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: widget.entry.status == 'active' || widget.entry.status == 'completed'
                              ? AppColors.statusActive
                              : AppColors.statusInactive,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.entry.name,
                          style: AppTextStyles.tableRow,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                // Use case
                SizedBox(
                  width: 200,
                  child: Text(
                    widget.entry.useCase.replaceAll('_', ' ').split(' ').map((w) => w.capitalize).join(' '),
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Precision
                SizedBox(
                  width: 100,
                  child: Text(widget.entry.precision.toMetric(), style: AppTextStyles.metricValue),
                ),
                // Accuracy
                SizedBox(
                  width: 100,
                  child: Text(widget.entry.accuracy.toMetric(), style: AppTextStyles.metricValue),
                ),
                // Recall
                SizedBox(
                  width: 100,
                  child: Text(widget.entry.recall.toMetric(), style: AppTextStyles.metricValue),
                ),
                // Actions
                SizedBox(
                  width: 60,
                  child: _isHovered
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: widget.onEdit,
                              child: const Icon(Icons.edit_outlined, size: 20, color: AppColors.primary),
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: widget.onDelete,
                              child: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          // Expanded detail
          if (widget.isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ExpandedModelDetail(entry: widget.entry),
            ),
        ],
      ),
    );
  }
}
