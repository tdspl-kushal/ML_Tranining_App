class NetworkInfo {
  // In a production app, use connectivity_plus to check internet status.
  // For now, always return true.
  static Future<bool> get isConnected async => true;
}
