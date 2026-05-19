import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/asset_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/utils/extensions.dart';
import '../bloc/leaderboard_bloc.dart';
import '../bloc/leaderboard_event.dart';
import '../bloc/leaderboard_state.dart';
import '../widgets/leaderboard_table.dart';
import '../../dashboard/widgets/user_profile_dialog.dart';

// ── Filter options ────────────────────────────────────────────────────────────

class _FilterOption {
  final String label;
  final String useCase;

  const _FilterOption(this.label, this.useCase);
}

const _filterOptions = [
  _FilterOption('Failure Prediction', 'failure_prediction'),
  _FilterOption('RUL', 'rul'),
  _FilterOption('Anomaly Multivariate', 'anomaly_multivariate'),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class LeaderboardScreen extends StatefulWidget {
  // profileId kept for back-nav; no longer used for data fetching
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
    // Load initial filter state
    context
        .read<LeaderboardBloc>()
        .add(const FilterByUseCase('failure_prediction'));
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
            padding:
                EdgeInsets.all(isMobile ? 16.0 : AppDimensions.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 20),
                _buildFilterRow(context),
                const SizedBox(height: 16),
                _buildTable(context),
                // const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        _buildFooter(context),
      ],
    );
  }

  void _showProfileDropdown(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.01),
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: AppDimensions.topBarHeight + 8,
              right: context.isMobile ? 16 : 24,
              child: const Material(
                color: Colors.transparent,
                child: UserProfileDialog(),
              ),
            ),
          ],
        );
      },
    );
  }

  // ── Top bar ────────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      height: AppDimensions.topBarHeight,
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Row(
        children: [
          SvgPicture.asset(
            AssetConstants.logoPath,
            height: 28,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showProfileDropdown(context),
            child: !isMobile
                ? const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 18, color: AppColors.primary),
                  )
                : const CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(Icons.person, size: 16, color: AppColors.primary),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Page header (title + back — no Filter button) ──────────────────────────

  Widget _buildHeader(BuildContext context) {
    final isMobile = context.isMobile;

    if (isMobile) {
      return Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.leaderboards, style: AppTextStyles.pageTitle),
                Text(AppStrings.leaderboardSubtitle,
                    style: AppTextStyles.pageSubtitle),
              ],
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.leaderboards, style: AppTextStyles.pageTitle),
            const SizedBox(height: 4),
            Text(AppStrings.leaderboardSubtitle,
                style: AppTextStyles.pageSubtitle),
          ],
        ),
      ],
    );
  }

  // ── Use-case filter radio row ──────────────────────────────────────────────

  Widget _buildFilterRow(BuildContext context) {
    return BlocBuilder<LeaderboardBloc, LeaderboardState>(
      buildWhen: (prev, curr) =>
          curr is LeaderboardLoaded || curr is LeaderboardLoading,
      builder: (context, state) {
        final activeFilter =
            state is LeaderboardLoaded ? state.activeFilter : null;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filterOptions.map((option) {
            final isSelected = activeFilter == option.useCase;
            return GestureDetector(
              onTap: () {
                if (!isSelected) {
                  context
                      .read<LeaderboardBloc>()
                      .add(FilterByUseCase(option.useCase));
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: option.useCase,
                    groupValue: activeFilter,
                    onChanged: (val) {
                      if (val != null) {
                        context
                            .read<LeaderboardBloc>()
                            .add(FilterByUseCase(val));
                      }
                    },
                    activeColor: AppColors.primary,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    option.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ── Table ──────────────────────────────────────────────────────────────────

  Widget _buildTable(BuildContext context) {
    return BlocConsumer<LeaderboardBloc, LeaderboardState>(
      buildWhen: (previous, current) =>
          current is LeaderboardLoading ||
          current is LeaderboardError ||
          current is LeaderboardLoaded,
      listener: (context, state) {
        if (state is LeaderboardError) {
          AppSnackbar.showError(
              context, 'Failed to load models: ${state.message}');
        }
      },
      builder: (context, state) {
        if (state is LeaderboardLoading) {
          return const AppLoader();
        }

        if (state is LeaderboardError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () =>
                context.read<LeaderboardBloc>().add(const RefreshLeaderboard()),
          );
        }

        if (state is LeaderboardLoaded) {
          return LeaderboardTable(
            entries: state.entries,
            expandedIds: state.expandedIds,
            activeFilter: state.activeFilter,
            onToggleExpansion: (id) =>
                context.read<LeaderboardBloc>().add(ToggleModelExpansion(id)),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  // ── Footer ─────────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context) {
    final isMobile = context.isMobile;

    if (isMobile) {
      return Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              AppStrings.copyright,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textTertiary),
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            AppStrings.copyright,
            style:
                GoogleFonts.inter(fontSize: 12, color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
