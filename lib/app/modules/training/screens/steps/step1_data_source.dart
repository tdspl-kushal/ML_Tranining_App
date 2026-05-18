import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../widgets/parquet_upload_zone.dart';
import '../../widgets/profile_exists_banner.dart';
import '../../../../modules/dataset/screens/dataset_preview_screen.dart';

class Step1DataSource extends StatelessWidget {
  final String? fileName;
  final String? filePath;
  final bool isUploading;
  final String? error;
  final bool profileExists;
  final String? profileName;

  /// When non-null, the ingest API call completed and we can show the preview.
  final String? datasetId;

  final ValueChanged<String> onFilePicked;
  final VoidCallback? onRemoveFile;

  const Step1DataSource({
    super.key,
    this.fileName,
    this.filePath,
    this.isUploading = false,
    this.error,
    this.profileExists = false,
    this.profileName,
    this.datasetId,
    required this.onFilePicked,
    this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (profileExists) ...[
          ProfileExistsBanner(profileName: profileName),
          const SizedBox(height: 20),
        ],
        Text(AppStrings.uploadTrainingData, style: AppTextStyles.sectionTitle),
        const SizedBox(height: 4),
        Text(
          AppStrings.uploadSubtitle,
          style: AppTextStyles.pageSubtitle,
        ),
        const SizedBox(height: 20),
        ParquetUploadZone(
          onFilePicked: onFilePicked,
          uploadedFileName: fileName,
          uploadedFilePath: filePath,
          isUploading: isUploading,
          errorText: error,
          onRemoveFile: onRemoveFile,
        ),

        // ── Dataset Preview ───────────────────────────────────────────────
        if (datasetId != null && !isUploading) ...[
          const SizedBox(height: 24),
          _DatasetPreviewSection(datasetId: datasetId!),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Inline preview section — wraps DatasetPreviewGrid in a card with a header.
// ---------------------------------------------------------------------------

class _DatasetPreviewSection extends StatelessWidget {
  const _DatasetPreviewSection({required this.datasetId});

  final String datasetId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.table_view_outlined, size: 18, color: Colors.teal),
            const SizedBox(width: 8),
            Text(
              'Data Preview',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 14),
            ),
            const Spacer(),
            Text(
              'First 10 rows',
              style: AppTextStyles.pageSubtitle.copyWith(fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Fixed height so the PlutoGrid renders correctly inside the dialog's
        // SingleChildScrollView without needing an Expanded ancestor.
        SizedBox(
          height: 320,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: DatasetPreviewGrid(datasetId: datasetId),
          ),
        ),
      ],
    );
  }
}
