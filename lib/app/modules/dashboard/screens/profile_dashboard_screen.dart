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
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/utils/extensions.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../../../data/model/profile_model.dart';
import '../widgets/profile_list_tile.dart';
import '../../training/screens/training_wizard_screen.dart';
import '../widgets/user_profile_dialog.dart';

class ProfileDashboardScreen extends StatelessWidget {
  const ProfileDashboardScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar
        _buildTopBar(context),
        const Divider(height: 1),
        // Content
        Expanded(
          child: SingleChildScrollView(
            padding:
                EdgeInsets.all(isMobile ? 16.0 : AppDimensions.contentPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildProfileTable(context),
                // const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        _buildFooter(context),
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
          SvgPicture.asset(
            AssetConstants.logoPath,
            height: 28,
            fit: BoxFit.contain,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showProfileDropdown(context),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = context.isMobile;
    final isTablet = context.isTablet;

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.profileDashboard, style: AppTextStyles.pageTitle),
          const SizedBox(height: 4),
          Text(AppStrings.profileDashboardSubtitle,
              style: AppTextStyles.pageSubtitle),
          const SizedBox(height: 20),
          _buildSearchField(context, double.infinity),
          const SizedBox(height: 12),
          AppButton(
            label: AppStrings.trainButton,
            prefixIcon: Icons.add,
            width: double.infinity,
            onPressed: () => _openTrainingWizard(context),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.profileDashboard, style: AppTextStyles.pageTitle),
              const SizedBox(height: 4),
              Text(AppStrings.profileDashboardSubtitle,
                  style: AppTextStyles.pageSubtitle),
            ],
          ),
        ),
        const SizedBox(width: 24),
        _buildSearchField(context, isTablet ? 200 : 280),
        const SizedBox(width: 12),
        AppButton(
          label: AppStrings.trainButton,
          prefixIcon: Icons.add,
          onPressed: () => _openTrainingWizard(context),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context, double width) {
    return SizedBox(
      width: width,
      height: 40,
      child: TextField(
        onChanged: (query) {
          context.read<DashboardBloc>().add(SearchProfiles(query));
        },
        style: GoogleFonts.inter(fontSize: 14),
        decoration: InputDecoration(
          hintText: AppStrings.searchProfiles,
          prefixIcon:
              const Icon(Icons.search, size: 20, color: AppColors.textTertiary),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
            borderSide: const BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
            borderSide:
                const BorderSide(color: AppColors.inputFocused, width: 1.5),
          ),
        ),
      ),
    );
  }

  void _openTrainingWizard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => TrainingWizardScreen(
        onComplete: () {
          context.read<DashboardBloc>().add(const RefreshProfiles());
        },
      ),
    );
  }

  Widget _buildProfileTable(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const AppLoader();
        }

        if (state is DashboardError) {
          return AppErrorWidget(
            message: state.message,
            onRetry: () =>
                context.read<DashboardBloc>().add(const LoadProfiles()),
          );
        }

        if (state is DashboardLoaded) {
          final profiles = state.filteredProfiles;
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
                        // Table header
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.tableBorder),
                              bottom: BorderSide(color: AppColors.tableBorder),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text(AppStrings.hash,
                                    style: AppTextStyles.tableHeader),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 4,
                                child: Text(AppStrings.profileName,
                                    style: AppTextStyles.tableHeader),
                              ),
                              const SizedBox(width: 24),
                              SizedBox(
                                width: 120,
                                child: Text('No. of Models',
                                    style: AppTextStyles.tableHeader),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 80,
                                child: Text(AppStrings.actions,
                                    style: AppTextStyles.tableHeader),
                              ),
                            ],
                          ),
                        ),
                        // Table rows
                        if (profiles.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(48),
                            child: Center(
                              child: Text(
                                AppStrings.noProfilesFound,
                                style: AppTextStyles.pageSubtitle,
                              ),
                            ),
                          )
                        else
                          ...profiles.asMap().entries.map((entry) {
                            return ProfileListTile(
                              index: entry.key,
                              profile: entry.value,
                              onTap: () {
                                context.go(
                                  '/leaderboard?profileId=${entry.value.id}&profileName=${Uri.encodeComponent(entry.value.name)}',
                                );
                              },
                              onEdit: () =>
                                  _showEditDialog(context, entry.value),
                              onDelete: () =>
                                  _showDeleteDialog(context, entry.value),
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

  void _showEditDialog(BuildContext context, ProfileModel profile) {
    final TextEditingController controller =
        TextEditingController(text: profile.name);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Rename Profile', style: AppTextStyles.sectionTitle),
          content: TextField(
            controller: controller,
            style: GoogleFonts.inter(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Enter new profile name',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel',
                  style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = controller.text.trim();
                if (newName.isNotEmpty) {
                  context.read<DashboardBloc>().add(RenameProfile(
                        profileId: profile.id,
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

  void _showDeleteDialog(BuildContext context, ProfileModel profile) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text('Delete Profile', style: AppTextStyles.sectionTitle),
          content: Text(
            'Are you sure you want to delete ${profile.name}?\n\nThis will permanently delete this profile and recursively delete all models within it.',
            style:
                GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel',
                  style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<DashboardBloc>().add(DeleteProfile(profile.id));
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
