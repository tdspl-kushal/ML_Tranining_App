import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_template/app/core/utils/app_cryptography.dart';

void main() {
  group('AppCryptography Tests', () {
    test('Encryption should return empty string if input is empty', () {
      final result = AppCryptography.encrypt('', 'some_password');
      expect(result, equals(''));
    });

    test('Verify exact encryption for Admin@123 with key BAKRNOCTECHONDATER', () {
      final cipherText = AppCryptography.encrypt('Admin@123', 'BAKRNOCTECHONDATER');
      // Should match the expected pattern
      expect(cipherText, equals('VvvQVRdH7JheYR7lLgbPCp4fcNEslXnKqhR59bdFMK8='));
    });
  });
}
