enum UserRole {
  admin,   // Puede crear partidas, editar resultados, eliminar miembros
  editor,  // Puede anotar puntos (Scorer)
  viewer;  // Solo puede ver el historial y marcador en vivo

  // Método helper para serializar a String (para la DB)
  String toShortString() => toString().split('.').last;

  // Método helper para obtener desde String
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.toShortString() == role,
      orElse: () => UserRole.viewer, // Default
    );
  }
}