import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;

import '../data/local/preference/preference_manager.dart';

class RequestHeaderInterceptor extends InterceptorsWrapper {
  final PreferenceManager _preferenceManager = getx.Get.find(tag: (PreferenceManager).toString());

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    getCustomHeaders().then((customHeaders) {
      options.headers.addAll(customHeaders);
      super.onRequest(options, handler);
    });
  }

  Future<Map<String, String>> getCustomHeaders() async {
    String accessToken = await _preferenceManager.getString(PreferenceManager.KEY_ACCESS_TOKEN);
    // if(accessToken==null || accessToken.isEmpty){
    //   accessToken=await  _preferenceManager.getToken(PreferenceManager.KEY_ACCESS_TOKEN);
    // }
    print(accessToken);
    var customHeaders = {'content-type': 'application/json'};
    if (accessToken.trim().isNotEmpty) {
      customHeaders.addAll({
        'Authorization': "Bearer $accessToken",
      });
    }

    return customHeaders;
  }
}
