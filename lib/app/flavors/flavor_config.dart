class FlavorConfig {
  final String name;
  final String apiBaseUrl;
  final bool enableLogging;

  const FlavorConfig({
    required this.name,
    required this.apiBaseUrl,
    this.enableLogging = false,
  });

  static const FlavorConfig development = FlavorConfig(
    name: 'development',
    apiBaseUrl: 'http://localhost:8000',
    enableLogging: true,
  );

  static const FlavorConfig production = FlavorConfig(
    name: 'production',
    apiBaseUrl: 'https://api.anexee.io',
    enableLogging: false,
  );
}
