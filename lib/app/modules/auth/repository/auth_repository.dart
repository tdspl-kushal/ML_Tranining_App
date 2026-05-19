import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../core/utils/app_cryptography.dart';
import '../../../core/constants/api_constants.dart';
import '../service/auth_service.dart';

abstract class IAuthRepository {
  Future<Either<Failure, bool>> verifyServerHealth(String serverUrl);
  Future<Either<Failure, String>> signIn({
    required String serverUrl,
    required String username,
    required String password,
  });
}

class AuthRepository implements IAuthRepository {
  final AuthService _service;

  AuthRepository(this._service);



  @override
  Future<Either<Failure, bool>> verifyServerHealth(String serverUrl) async {
    try {
      final healthy = await _service.verifyServerHealth(serverUrl);
      if (healthy) {
        return const Right(true);
      } else {
        return Left(ServerFailure('Server health check failed.'));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signIn({
    required String serverUrl,
    required String username,
    required String password,
  }) async {
    try {
      // 1. Perform health check first
      final healthy = await _service.verifyServerHealth(serverUrl);
      if (!healthy) {
        return Left(ServerFailure('Connection failed: Server is unreachable or unhealthy.'));
      }

      // 2. Encrypt password using AppCryptography with ApiConstants.encryptionKey
      final encryptedPassword = AppCryptography.encrypt(password, ApiConstants.encryptionKey);

      // 3. Post to signIn
      final response = await _service.signIn(
        serverUrl: serverUrl,
        username: username,
        encryptedPassword: encryptedPassword,
      );

      // 4. Retrieve and return Token
      final token = response.data['access_token'] ??
                    response.data['acess_token'] ??
                    response.data['Token'] ??
                    response.data['token'];
      if (token != null) {
        return Right(token as String);
      } else {
        return Left(ServerFailure('Authentication response did not contain a token.'));
      }
    } on DioException catch (e) {
      final msg = e.response?.data?['Message'] ??
          e.response?.data?['message'] ??
          e.message ??
          'Sign in failed.';
      return Left(ServerFailure(msg));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
