enum UserStatus { NEW, OTP_VERIFIED, PROFILE_UNVERFIED, PROFILE_VERIFIED, USER_BLOCKED }

extension UserStatusExtension on UserStatus {
  int get getValue {
    switch (this) {
      case UserStatus.NEW:
        return 1;
      case UserStatus.OTP_VERIFIED:
        return 2;
      case UserStatus.PROFILE_UNVERFIED:
        return 3;
      case UserStatus.PROFILE_VERIFIED:
        return 4;
      case UserStatus.USER_BLOCKED:
        return 5;
      default:
        return 1;
    }
  }
}
