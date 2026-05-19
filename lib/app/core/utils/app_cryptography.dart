import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';

class AppCryptography {
  static final Uint8List _saltBytes = Uint8List.fromList([
    0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64,
    0x76, 0x65, 0x64, 0x65, 0x76,
  ]);
  static const int _iterations = 1000;

  /// Encrypts the [plainText] using AES-CBC with a PBKDF2-SHA1 derived key.
  /// Matches C# implementation of GetEncryptedString with encType=1.
  static String encrypt(String plainText, String passwordString) {
    if (plainText.isEmpty) return plainText;

    // Convert encryption key to UTF-8 bytes (matches C# Rfc2898DeriveBytes)
    final passwordBytes = Uint8List.fromList(utf8.encode(passwordString));
    final dataBytes = _toUtf16Le(plainText);

    // Derive 48 bytes using PBKDF2 with SHA-1 (32 bytes key, 16 bytes IV)
    final derivator = PBKDF2KeyDerivator(HMac(SHA1Digest(), 64))
      ..init(Pbkdf2Parameters(_saltBytes, _iterations, 48));
    final derivedBytes = derivator.process(passwordBytes);

    final keyBytes = derivedBytes.sublist(0, 32);
    final ivBytes = derivedBytes.sublist(32, 48);

    // Setup encryption
    final key = Key(keyBytes);
    final iv = IV(ivBytes);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

    // Encrypt and return base64
    final encrypted = encrypter.encryptBytes(dataBytes, iv: iv);
    return encrypted.base64;
  }

  /// Helper to convert Dart String to UTF-16LE bytes
  static Uint8List _toUtf16Le(String str) {
    final bytes = <int>[];
    for (int i = 0; i < str.length; i++) {
      final codeUnit = str.codeUnitAt(i);
      bytes.add(codeUnit & 0xFF); // low byte
      bytes.add((codeUnit >> 8) & 0xFF); // high byte
    }
    return Uint8List.fromList(bytes);
  }
}
