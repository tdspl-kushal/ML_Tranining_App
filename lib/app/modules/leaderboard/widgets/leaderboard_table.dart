import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import 'leaderboard_row.dart';

class LeaderboardTable extends StatelessWidget {
  final List<LeaderboardEntryModel> entries;
  final Set<String> expandedIds;
  final String? activeFilter;
  final ValueChanged<String> onToggleExpansion;

  const LeaderboardTable({
    super.key,
    required this.entries,
    required this.expandedIds,
    this.activeFilter,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAll = activeFilter == null;
    final firstEntry = entries.isNotEmpty ? entries.first : null;

    final String col1 = isAll ? 'Precision' : (firstEntry?.impPrimaryMetric ?? 'Primary Metric');
    final String col2 = isAll ? 'Accuracy' : (firstEntry?.impSecondaryMetric ?? 'Secondary Metric');
    final String col3 = isAll ? 'Recall' : (firstEntry?.impTertiaryMetric ?? 'Tertiary Metric');

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.tableBorder),
                        bottom: BorderSide(color: AppColors.tableBorder),
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 40), // expand toggle space
                        Expanded(flex: 3, child: Text('Model Name', style: AppTextStyles.tableHeader)),
                        if (isAll) Expanded(flex: 2, child: Text('Use Case', style: AppTextStyles.tableHeader)),
                        if (!isAll) SizedBox(width: 100, child: Text(col1, style: AppTextStyles.tableHeader)),
                        if (!isAll) SizedBox(width: 100, child: Text(col2, style: AppTextStyles.tableHeader)),
                        if (!isAll) SizedBox(width: 100, child: Text(col3, style: AppTextStyles.tableHeader)),
                        SizedBox(width: 100, child: Text('Actions', style: AppTextStyles.tableHeader)),
                      ],
                    ),
                  ),
                  // Rows
                  if (entries.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(48),
                      child: Center(
                        child: Text(
                          AppStrings.noModelsFound,
                          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ...entries.map((entry) {
                      return LeaderboardRow(
                        entry: entry,
                        activeFilter: activeFilter,
                        isExpanded: expandedIds.contains(entry.id),
                        onToggle: () => onToggleExpansion(entry.id),
                      );
                    }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
