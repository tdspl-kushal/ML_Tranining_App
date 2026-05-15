import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../widgets/parquet_upload_zone.dart';
import '../../widgets/profile_exists_banner.dart';

class Step1DataSource extends StatelessWidget {
  final String? fileName;
  final String? filePath;
  final bool isUploading;
  final String? error;
  final bool profileExists;
  final String? profileName;
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
    required this.onFilePicked,
    this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
      ],
    );
  }
}
