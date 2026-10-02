import 'dart:convert';

/// Utilidades para leer el payload de un ID token de Firebase (JWT).
class JwtUtils {
  static Map<String, dynamic>? decodePayload(String? token) {
    if (token == null || token.isEmpty) return null;
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(decoded);
      return json is Map<String, dynamic> ? json : null;
    } catch (_) {
      return null;
    }
  }

  /// El claim `aud` de un ID token de Firebase es el ID del proyecto.
  static String? projectIdFromIdToken(String? token) {
    final payload = decodePayload(token);
    final aud = payload?['aud'];
    return aud is String && aud.isNotEmpty ? aud : null;
  }

  static String? userIdFromIdToken(String? token) {
    final payload = decodePayload(token);
    final sub = payload?['user_id'] ?? payload?['sub'];
    return sub is String && sub.isNotEmpty ? sub : null;
  }
}
