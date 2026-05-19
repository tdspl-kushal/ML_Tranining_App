class UserProfileModel {
  final int userId;
  final String displayName;
  final String emailId;
  final String currentOrgName;
  final String? currentOrgLogo;

  UserProfileModel({
    required this.userId,
    required this.displayName,
    required this.emailId,
    required this.currentOrgName,
    this.currentOrgLogo,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      userId: json['userId'] as int? ?? 0,
      displayName: json['displayName'] as String? ?? '',
      emailId: json['emailId'] as String? ?? '',
      currentOrgName: json['currentOrgName'] as String? ?? '',
      currentOrgLogo: json['currentOrgLogo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'emailId': emailId,
      'currentOrgName': currentOrgName,
      'currentOrgLogo': currentOrgLogo,
    };
  }
}
