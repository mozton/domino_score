import 'dart:math';

/// Genera códigos cortos y legibles (sin caracteres ambiguos: 0/O, 1/I).
class CodeGenerator {
  static const _chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static final Random _random = Random();

  static String generate([int length = 6]) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }
}
