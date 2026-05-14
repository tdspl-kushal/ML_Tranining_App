import '../model/login.dart';
import '/app/core/base/base_remote_source.dart';

abstract class ApiDataSource extends BaseRemoteSource {

  Future<Login> login(Login login);
}
