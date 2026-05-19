import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/extensions.dart';
import '../../../data/model/profile_model.dart';
import 'profile_icon_badge.dart';

class ProfileListTile extends StatefulWidget {
  final int index;
  final ProfileModel profile;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProfileListTile({
    super.key,
    required this.index,
    required this.profile,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<ProfileListTile> createState() => _ProfileListTileState();
}

class _ProfileListTileState extends State<ProfileListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered ? AppColors.primaryLight.withOpacity(0.3) : AppColors.white,
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
              // Index
              SizedBox(
                width: 50,
                child: Text(
                  (widget.index + 1).toZeroPadded(),
                  style: AppTextStyles.tableRowNum,
                ),
              ),
              const SizedBox(width: 12),
              // Icon + Name
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    ProfileIconBadge(iconType: widget.profile.iconType),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.profile.name,
                        style: AppTextStyles.tableRow,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              // Tag count
              SizedBox(
                width: 120,
                child: Text(
                  widget.profile.modelCount.toString(),
                  style: AppTextStyles.tableRow.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              // Actions
              SizedBox(
                width: 80,
                child: _isHovered
                    ? Row(
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
                    : const SizedBox(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
