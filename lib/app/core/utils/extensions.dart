import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension StringExtensions on String {
  String get capitalize => isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  String get titleCase => split(' ').map((w) => w.capitalize).join(' ');
}

extension DoubleExtensions on double {
  String toMetric() {
    if (isNaN) return 'NaN';
    if (isInfinite) return 'Infinity';
    return NumberFormat('0.000').format(this);
  }
}

extension IntExtensions on int {
  String toZeroPadded({int width = 2}) => toString().padLeft(width, '0');
}

extension UseCaseDisplay on String {
  String toUseCaseLabel() {
    switch (this) {
      case 'failure_prediction':
        return 'Failure Prediction';
      case 'rul':
        return 'RUL';
      case 'anomaly_multivariate':
        return 'Anomaly Multivariate';
      default:
        return split('_').map((w) => w.capitalize).join(' ');
    }
  }
}

extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isDesktop => screenWidth >= 1024;
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  bool get isMobile => screenWidth < 768;
}
