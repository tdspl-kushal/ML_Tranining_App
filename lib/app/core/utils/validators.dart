class Validators {
  Validators._();

  static String? validateModelName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Model name is required';
    }
    if (value.length < 3) {
      return 'Model name must be at least 3 characters';
    }
    if (value.length > 64) {
      return 'Model name must be at most 64 characters';
    }
    if (value.contains(' ')) {
      return 'Model name cannot contain spaces (use underscores)';
    }
    return null;
  }

  static String? validateTrainSplit(String? value) {
    if (value == null || value.isEmpty) {
      return 'Train split is required';
    }
    final parsed = double.tryParse(value);
    if (parsed == null) {
      return 'Must be a valid number';
    }
    if (parsed < 0.1 || parsed > 0.99) {
      return 'Must be between 0.1 and 0.99';
    }
    return null;
  }

  static String? validateParquetFile(String? fileName) {
    if (fileName == null || fileName.isEmpty) {
      return 'Please select a file';
    }
    if (!fileName.toLowerCase().endsWith('.parquet')) {
      return 'Only .parquet files are accepted';
    }
    return null;
  }
}
