import '../../network/dio_provider.dart';
import '../model/login.dart';
import '/app/core/base/base_remote_source.dart';

import 'api_source.dart';

class ApiDataSourceImpl extends BaseRemoteSource implements ApiDataSource {
  @override
  Future<Login> login(Login login) {
    var endpoint = "${DioProvider.baseUrl}uapi/account/login";
    var dioCall = dioClient.post(endpoint, data: login);
    try {
      return callApiWithErrorParser(dioCall).then((response) => Login.fromJson(response.data));
    } catch (e) {
      rethrow;
    }
  }

}
