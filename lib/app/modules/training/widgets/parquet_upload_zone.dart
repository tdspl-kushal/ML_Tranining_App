import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/extensions.dart';

class ParquetUploadZone extends StatefulWidget {
  final ValueChanged<String> onFilePicked;
  final String? uploadedFileName;
  final bool isUploading;
  final String? errorText;
  final VoidCallback? onRemoveFile;

  const ParquetUploadZone({
    super.key,
    required this.onFilePicked,
    this.uploadedFileName,
    this.isUploading = false,
    this.errorText,
    this.onRemoveFile,
  });

  @override
  State<ParquetUploadZone> createState() => _ParquetUploadZoneState();
}

class _ParquetUploadZoneState extends State<ParquetUploadZone> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropTarget(
          onDragEntered: (_) => setState(() => _isDragging = true),
          onDragExited: (_) => setState(() => _isDragging = false),
          onDragDone: (details) {
            setState(() => _isDragging = false);
            if (details.files.isNotEmpty) {
              final file = details.files.first;
              if (file.path.toLowerCase().endsWith('.parquet')) {
                widget.onFilePicked(file.path);
              }
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: isMobile ? 180 : AppDimensions.uploadZoneHeight,
            decoration: BoxDecoration(
              color: _isDragging ? AppColors.primaryLight : AppColors.uploadZoneBg,
              borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
              border: Border.all(
                color: _isDragging ? AppColors.primary : AppColors.uploadZoneBorder,
                width: 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: widget.isUploading
                ? _buildUploading()
                : _buildDropZone(isMobile),
          ),
        ),
        // File name chip
        if (widget.uploadedFileName != null && !widget.isUploading) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.insert_drive_file, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    widget.uploadedFileName!,
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (widget.onRemoveFile != null)
                  InkWell(
                    onTap: widget.onRemoveFile,
                    child: const Icon(Icons.close, size: 16, color: AppColors.primary),
                  ),
              ],
            ),
          ),
        ],
        // Error
        if (widget.errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.errorText!,
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildDropZone(bool isMobile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file_outlined,
          size: isMobile ? 32 : 40,
          color: AppColors.primary.withAlpha((255 * 0.7).toInt()),
        ),
        const SizedBox(height: 12),
        Text(
          'Drop your file here',
          style: GoogleFonts.inter(
            fontSize: isMobile ? 14 : 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (!isMobile) ...[
          const SizedBox(height: 4),
          Text(
            'Parquet file (.parquet)',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _pickFile,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            side: const BorderSide(color: AppColors.inputBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20, vertical: isMobile ? 8 : 10),
          ),
          child: Text(
            'Browse Files',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildUploading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 120,
          child: LinearProgressIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.primaryLight,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Uploading...',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['parquet'],
    );
    if (result != null && result.files.single.path != null) {
      widget.onFilePicked(result.files.single.path!);
    }
  }
}
