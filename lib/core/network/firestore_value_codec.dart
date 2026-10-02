/// Convierte entre valores Dart y el formato JSON tipado de Firestore REST.
///
/// Firestore REST representa cada valor como `{"stringValue": ...}`,
/// `{"integerValue": "5"}` (nótese que los enteros van como string), etc.
class FirestoreValueCodec {
  static Map<String, dynamic> encodeValue(dynamic value) {
    if (value == null) return {'nullValue': null};
    if (value is String) return {'stringValue': value};
    if (value is bool) return {'booleanValue': value};
    if (value is int) return {'integerValue': value.toString()};
    if (value is double) return {'doubleValue': value};
    if (value is num) return {'doubleValue': value.toDouble()};
    if (value is DateTime) {
      return {'timestampValue': value.toUtc().toIso8601String()};
    }
    if (value is List) {
      return {
        'arrayValue': {'values': value.map(encodeValue).toList()},
      };
    }
    if (value is Map) {
      return {
        'mapValue': {
          'fields': encodeFields(Map<String, dynamic>.from(value)),
        },
      };
    }
    return {'stringValue': value.toString()};
  }

  static Map<String, dynamic> encodeFields(Map<String, dynamic> data) {
    return data.map((key, value) => MapEntry(key, encodeValue(value)));
  }

  static dynamic decodeValue(Map<String, dynamic> value) {
    if (value.containsKey('nullValue')) return null;
    if (value.containsKey('stringValue')) return value['stringValue'];
    if (value.containsKey('booleanValue')) return value['booleanValue'];
    if (value.containsKey('integerValue')) {
      final raw = value['integerValue'];
      if (raw is String) return int.tryParse(raw) ?? 0;
      if (raw is num) return raw.toInt();
      return 0;
    }
    if (value.containsKey('doubleValue')) {
      final raw = value['doubleValue'];
      if (raw is String) return double.tryParse(raw) ?? 0.0;
      if (raw is num) return raw.toDouble();
      return 0.0;
    }
    if (value.containsKey('timestampValue')) {
      final raw = value['timestampValue'];
      if (raw is String) return DateTime.tryParse(raw)?.toLocal();
      return null;
    }
    if (value.containsKey('arrayValue')) {
      final array = value['arrayValue'] as Map<String, dynamic>?;
      final values = array?['values'] as List?;
      if (values == null) return <dynamic>[];
      return values
          .map((e) => decodeValue(e as Map<String, dynamic>))
          .toList();
    }
    if (value.containsKey('mapValue')) {
      final map = value['mapValue'] as Map<String, dynamic>?;
      final fields = map?['fields'] as Map<String, dynamic>?;
      if (fields == null) return <String, dynamic>{};
      return decodeFields(fields);
    }
    if (value.containsKey('referenceValue')) return value['referenceValue'];
    if (value.containsKey('geoPointValue')) return value['geoPointValue'];
    return null;
  }

  static Map<String, dynamic> decodeFields(Map<String, dynamic> fields) {
    return fields.map(
      (key, value) => MapEntry(key, decodeValue(value as Map<String, dynamic>)),
    );
  }
}
