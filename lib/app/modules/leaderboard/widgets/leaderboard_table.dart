import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import 'leaderboard_row.dart';

class LeaderboardTable extends StatelessWidget {
  final List<LeaderboardEntryModel> entries;
  final Set<String> expandedIds;
  final ValueChanged<String> onToggleExpansion;

  const LeaderboardTable({
    super.key,
    required this.entries,
    required this.expandedIds,
    required this.onToggleExpansion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.tableBorder),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 
              (context.isMobile ? 32 : (AppDimensions.sidebarWidth + 64)),
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.tableBorder)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 40), // expand toggle space
                      SizedBox(width: 250, child: Text('Model Name', style: AppTextStyles.tableHeader)),
                      SizedBox(width: 200, child: Text('Use Case', style: AppTextStyles.tableHeader)),
                      SizedBox(width: 100, child: Text('Precision', style: AppTextStyles.tableHeader)),
                      SizedBox(width: 100, child: Text('Accuracy', style: AppTextStyles.tableHeader)),
                      SizedBox(width: 100, child: Text('Recall', style: AppTextStyles.tableHeader)),
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
                      isExpanded: expandedIds.contains(entry.id),
                      onToggle: () => onToggleExpansion(entry.id),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

