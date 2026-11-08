import 'package:flutter/foundation.dart';

// Build-time configuration. Override with `--dart-define`:
//
// - `API_BASE_URL`: the mock server. Defaults to the host machine as seen
//   from the Android emulator (10.0.2.2) or the iOS Simulator (localhost).
// - `REACHABILITY_URL`: any URL that answers 2xx when the internet works.
@immutable
class Env {
  const Env({required this.apiBaseUrl, required this.reachabilityUrl});

  factory Env.fromEnvironment() {
    const apiOverride = String.fromEnvironment('API_BASE_URL');
    const reachability = String.fromEnvironment(
      'REACHABILITY_URL',
      defaultValue: 'https://clients3.google.com/generate_204',
    );
    final apiBaseUrl = apiOverride.isNotEmpty
        ? apiOverride
        : defaultTargetPlatform == TargetPlatform.android
        ? 'http://10.0.2.2:8080'
        : 'http://localhost:8080';
    return Env(apiBaseUrl: apiBaseUrl, reachabilityUrl: reachability);
  }

  final String apiBaseUrl;
  final String reachabilityUrl;

  // Network URL of a catalogue image such as `products/coconut.png`.
  String imageUrl(String path) => '$apiBaseUrl/images/$path';
}
