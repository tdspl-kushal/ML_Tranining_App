import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/utils/extensions.dart';
import '../bloc/leaderboard_bloc.dart';
import '../bloc/leaderboard_event.dart';
import '../bloc/leaderboard_state.dart';
import '../../../data/model/leaderboard_entry_model.dart';
import '../widgets/leaderboard_table.dart';

class LeaderboardScreen extends StatefulWidget {
  final String profileId;
  final String profileName;

  const LeaderboardScreen({
    super.key,
    required this.profileId,
    required this.profileName,
  });

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<LeaderboardBloc>().add(LoadLeaderboard(widget.profileId));
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(context),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : AppDimensions.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildTable(context),
                const SizedBox(height: 40),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      height: AppDimensions.topBarHeight,
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Row(
        children: [
          Text(
            AppStrings.appBarTitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 24),
          if (!isMobile)
            Expanded(
              child: SizedBox(
                height: 36,
                child: TextField(
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search resources...',
                    prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.textTertiary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    filled: true,
                    fillColor: AppColors.scaffoldBg,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textSecondary),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          if (!isMobile)
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, size: 18, color: AppColors.primary),
            )
          else
            const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, size: 16, color: AppColors.primary),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = context.isMobile;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/'),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              Text(AppStrings.leaderboards, style: AppTextStyles.pageTitle),
            ],
          ),
          const SizedBox(height: 4),
          Text(AppStrings.leaderboardSubtitle, style: AppTextStyles.pageSubtitle),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, size: 18),
            label: const Text('Filter Models'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.inputBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.leaderboards, style: AppTextStyles.pageTitle),
              const SizedBox(height: 4),
              Text(AppStrings.leaderboardSubtitle, style: AppTextStyles.pageSubtitle),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.filter_list, size: 18),
          label: Text(
            AppStrings.filter,
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.inputBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildTable(BuildContext context) {
    return BlocBuilder<LeaderboardBloc, LeaderboardState>(
      builder: (context, state) {
        if (state is LeaderboardLoading) {
          return const AppLoader();
        }

        if (state is LeaderboardError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () => context.read<LeaderboardBloc>().add(LoadLeaderboard(widget.profileId)),
          );
        }

        if (state is LeaderboardLoaded) {
          return LeaderboardTable(
            entries: state.entries,
            expandedIds: state.expandedIds,
            onToggleExpansion: (id) => context.read<LeaderboardBloc>().add(ToggleModelExpansion(id)),
            onEdit: (entry) => _showEditDialog(context, entry),
            onDelete: (entry) => _showDeleteDialog(context, entry),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = context.isMobile;

    if (isMobile) {
      return Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Text(
            AppStrings.copyright,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _footerLink(AppStrings.privacyPolicy),
              _footerLink(AppStrings.termsOfService),
              _footerLink(AppStrings.documentation),
            ],
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Text(
            AppStrings.copyright,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
          ),
          const Spacer(),
          _footerLink(AppStrings.privacyPolicy),
          const SizedBox(width: 24),
          _footerLink(AppStrings.termsOfService),
          const SizedBox(width: 24),
          _footerLink(AppStrings.documentation),
        ],
      ),
    );
  }

  Widget _footerLink(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _showEditDialog(BuildContext context, LeaderboardEntryModel entry) {
    final TextEditingController controller = TextEditingController(text: entry.name);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Rename Model', style: AppTextStyles.sectionTitle),
          content: TextField(
            controller: controller,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter new model name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  context.read<LeaderboardBloc>().add(RenameModel(
                        profileId: widget.profileId,
                        modelId: entry.id,
                        newName: newName,
                      ));
                }
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, LeaderboardEntryModel entry) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Delete Model', style: AppTextStyles.sectionTitle),
          content: Text(
            'Are you sure you want to delete ${entry.name}? This action cannot be undone.',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<LeaderboardBloc>().add(DeleteModel(entry.id));
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
