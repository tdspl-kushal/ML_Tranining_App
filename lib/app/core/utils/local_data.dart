import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class LocalData {
  static final OBJECT_USER = 'loginUserLocal';
  static final USER_TOKEN = 'localToken';
  static final box = GetStorage();

  static saveUser(user) {
    var s = json.encode(user);
    box.write(OBJECT_USER, s);
  }

  static saveAccessToken(String token) {
    box.write(USER_TOKEN, 'Bearer ' + token);
  }

  static String getAccessToken() {
    return box.read(USER_TOKEN) ?? '';
  }

  static clearAllData() {
    return box.erase();
  }
}
