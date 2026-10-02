/// Alcance de la sesión de juego actual.
///
/// - `groupId == null`  → partidas locales (historial general del usuario).
/// - `groupId != null`  → partidas del grupo (Firestore, compartidas).
class GameScope {
  String? groupId;
  String? groupName;

  bool get isGroup => groupId != null;

  void setGroup(String? groupId, {String? groupName}) {
    this.groupId = groupId;
    this.groupName = groupName;
  }

  void clear() {
    groupId = null;
    groupName = null;
  }
}
