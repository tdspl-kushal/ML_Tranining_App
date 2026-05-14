class Login {
  String? username;
  String? name;
  String? password;
  String? email;
  String? gender;
  String? mobileNumber;
  String? fcm_token_android;
  String? fcm_token_ios;
  String? app_cur_version;
  int? d_os_api;
  String? d_manufacture;
  String? d_model;
  String? d_os_version;

  Login(
      {this.username,
        this.mobileNumber,
        this.email,
        this.gender,
        this.name,
      this.password,
      this.fcm_token_android,
      this.fcm_token_ios,
      this.app_cur_version,
      this.d_os_api,
      this.d_manufacture,
      this.d_model,
      this.d_os_version});

  Login.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password_hash'];
    fcm_token_android = json['fcm_token_android'];
    name = json['full_name'];
    mobileNumber = json['mobile_number'];
    email = json['email'];
    fcm_token_ios = json['fcm_token_ios'];
    app_cur_version = json['app_cur_version'];
    d_os_api = json['d_os_api'];
    d_manufacture = json['d_manufacture'];
    d_model = json['d_model'];
    d_os_version = json['d_os_version'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   // data['username'] = username ?? '';
    data['full_name'] = name ?? '';
    data['password_hash'] = password ?? '';
    data['email'] = email ?? '';
    data['mobile_number'] = mobileNumber ?? '';
    data['gender'] = gender ?? 'M';
    data['fcm_token_android'] = fcm_token_android;
    data['fcm_token_ios'] = fcm_token_ios ?? '';
    data['app_cur_version'] = app_cur_version;
    data['d_os_api'] = d_os_api;
    data['d_manufacture'] = d_manufacture;
    data['d_model'] = d_model;
    data['d_os_version'] = d_os_version;

    return data;
  }
}
