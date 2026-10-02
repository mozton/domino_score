import 'package:flutter/material.dart';

/// Paleta por equipo (hasta 4). Los dos primeros mantienen los colores
/// originales de la app (dorado y azul oscuro).
class TeamPalette {
  static const List<Color> cardColors = [
    Color(0xFFF7E7AF),
    Color(0xFFFFFFFF),
    Color(0xFFE0F2FE),
    Color(0xFFDCFCE7),
  ];

  static const List<Color> buttonColors = [
    Color(0xFFD4AF37),
    Color(0xFF1E2B43),
    Color(0xFF0284C7),
    Color(0xFF16A34A),
  ];

  static Color card(int index) => cardColors[index % cardColors.length];

  static Color button(int index) => buttonColors[index % buttonColors.length];

  /// Factor de ancho de cada tarjeta según la cantidad de equipos.
  static double widthFactor(int teamCount) {
    switch (teamCount) {
      case 2:
        return 0.43;
      case 3:
        return 0.29;
      default:
        return 0.43;
    }
  }
}
