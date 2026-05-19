class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://127.0.0.1:8000';
  static const String mainUrl = 'http://164.52.221.177:5128';
  static const String encryptionKey = 'BAKRNOCTECHONDATER';

  // Health
  static const String health = '/health';

  // Auth
  static const String signIn = '/api/SignIn';

  // Profiles
  static const String profiles = '/v1/profiles';
  static String profileById(String id) => '/v1/profiles/$id';
  static String profileModels(String id) => '/v1/profiles/$id/models';

  // Leaderboard / Models
  static String modelById(String id) => '/v1/models/$id';
  static String modelDownload(String id) => '/v1/models/$id/download';

  // Training / Ingest
  static const String ingest = '/v1/ingest';
  static const String featuresExtract = '/v1/features/extract';
  static String hparams(String useCase) => '/v1/hparams/$useCase';

  // Training
  static const String train = '/v1/train';
  static String trainStream(String modelId) => '/v1/train/$modelId/stream';

  // User Profile
  static const String getUserProfile = '/api/GetUserProfile';
}
