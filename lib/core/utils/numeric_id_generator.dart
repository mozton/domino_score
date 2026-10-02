/// Genera identificadores numéricos únicos y crecientes (microsegundos).
///
/// Se usan como id de documento en Firestore para las partidas de grupo, de
/// modo que las entidades de dominio sigan usando `int` como id (igual que
/// Drift) sin colisiones prácticas entre dispositivos.
class NumericIdGenerator {
  static int _last = 0;

  static int next() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final id = now > _last ? now : _last + 1;
    _last = id;
    return id;
  }
}
