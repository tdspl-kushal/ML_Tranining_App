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
  final String activeFilter;
  final ValueChanged<String> onToggleExpansion;

  const LeaderboardTable({
    super.key,
    required this.entries,
    required this.expandedIds,
    required this.activeFilter,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    final firstEntry = entries.isNotEmpty ? entries.first : null;

    final String col1 = (firstEntry?.impPrimaryMetric ?? 'Primary Metric').replaceAll('_', ' ');
    final String col2 = (firstEntry?.impSecondaryMetric ?? 'Secondary Metric').replaceAll('_', ' ');
    final String col3 = (firstEntry?.impTertiaryMetric ?? 'Tertiary Metric').replaceAll('_', ' ');

    return LayoutBuilder(
      builder: (context, constraints) {
        // Safe minimum width for the table columns to avoid wrapping of names
        const double minTableWidth = 720.0;
        final double tableWidth = constraints.maxWidth > minTableWidth 
            ? constraints.maxWidth 
            : minTableWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
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
                      Expanded(
                        flex: 3, 
                        child: Text(
                          'Model Name', 
                          style: AppTextStyles.tableHeader,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 120, 
                        child: firstEntry?.impPrimaryDirection != null 
                            ? Tooltip(
                                message: firstEntry!.impPrimaryDirection!.replaceAll('_', ' '),
                                preferBelow: false,
                                child: Text(
                                  col1, 
                                  style: AppTextStyles.tableHeader, 
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : Text(
                                col1, 
                                style: AppTextStyles.tableHeader, 
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      SizedBox(
                        width: 120, 
                        child: firstEntry?.impSecondaryDirection != null 
                            ? Tooltip(
                                message: firstEntry!.impSecondaryDirection!.replaceAll('_', ' '),
                                preferBelow: false,
                                child: Text(
                                  col2, 
                                  style: AppTextStyles.tableHeader, 
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : Text(
                                col2, 
                                style: AppTextStyles.tableHeader, 
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      SizedBox(
                        width: 120, 
                        child: firstEntry?.impTertiaryDirection != null 
                            ? Tooltip(
                                message: firstEntry!.impTertiaryDirection!.replaceAll('_', ' '),
                                preferBelow: false,
                                child: Text(
                                  col3, 
                                  style: AppTextStyles.tableHeader, 
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : Text(
                                col3, 
                                style: AppTextStyles.tableHeader, 
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                      SizedBox(
                        width: 80, 
                        child: Text(
                          'Actions', 
                          style: AppTextStyles.tableHeader, 
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
        );
      },
    );
  }
}
