import 'package:dio/dio.dart';
import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/core/network/auth_token_provider.dart';
import 'package:dominos_score/core/network/firestore_value_codec.dart';
import 'package:dominos_score/core/utils/jwt_utils.dart';

/// Se lanza cuando un documento o colección no existe en Firestore.
class FirestoreNotFoundException extends AppException {
  FirestoreNotFoundException([String message = 'Recurso no encontrado'])
    : super(message, 'Firestore: ');
}

/// Documento devuelto por Firestore REST.
class FirestoreDocument {  final String id;
  final Map<String, dynamic> data;
  final String? name;

  const FirestoreDocument({
    required this.id,
    required this.data,
    this.name,
  });

  factory FirestoreDocument.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String?;
    final fields = json['fields'] as Map<String, dynamic>? ?? {};
    return FirestoreDocument(
      id: _idFromName(name),
      name: name,
      data: FirestoreValueCodec.decodeFields(fields),
    );
  }

  static String _idFromName(String? name) {
    if (name == null || name.isEmpty) return '';
    final parts = name.split('/');
    return parts.last;
  }
}

/// Filtros para `runQuery` de Firestore REST.
class FirestoreFilter {
  static Map<String, dynamic> equal(String field, dynamic value) =>
      _fieldFilter(field, 'EQUAL', value);

  static Map<String, dynamic> arrayContains(String field, dynamic value) =>
      _fieldFilter(field, 'ARRAY_CONTAINS', value);

  static Map<String, dynamic> _fieldFilter(
    String field,
    String op,
    dynamic value,
  ) {
    return {
      'fieldFilter': {
        'field': {'fieldPath': field},
        'op': op,
        'value': FirestoreValueCodec.encodeValue(value),
      },
    };
  }
}

/// Cliente mínimo para la API REST de Firestore.
///
/// Usa el ID token de Firebase (Identity Toolkit) como Bearer, por lo que
/// funciona con la autenticación REST que ya tiene la app, sin el SDK nativo.
class FirestoreRestClient {
  final Dio _dio;
  final AuthTokenProvider _tokenProvider;

  /// Proyecto por defecto si no se puede deducir del token (opcional).
  final String? fallbackProjectId;

  FirestoreRestClient({
    required AuthTokenProvider tokenProvider,
    this.fallbackProjectId,
    Dio? dio,
  }) : _tokenProvider = tokenProvider,
       _dio = dio ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 15),
               receiveTimeout: const Duration(seconds: 20),
             ),
           );

  Future<String> _buildBaseUrl(String? token) async {
    final projectId =
        JwtUtils.projectIdFromIdToken(token) ?? fallbackProjectId;
    if (projectId == null || projectId.isEmpty) {
      throw AppException(
        'No se pudo determinar el proyecto de Firebase. Vuelve a iniciar sesión.',
      );
    }
    return 'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';
  }

  Future<Response<dynamic>> _request(
    String method,
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    var token = await _tokenProvider.getToken();
    final baseUrl = await _buildBaseUrl(token);
    final url = '$baseUrl$path';

    Future<Response<dynamic>> send(String? bearer) {
      return _dio.request<dynamic>(
        url,
        data: data,
        queryParameters: query,
        options: Options(
          method: method,
          headers: {
            if (bearer != null) 'Authorization': 'Bearer $bearer',
            'Content-Type': 'application/json',
          },
        ),
      );
    }

    try {
      return await send(token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        token = await _tokenProvider.refreshToken();
        if (token != null && token.isNotEmpty) {
          try {
            return await send(token);
          } on DioException catch (retryError) {
            throw _mapError(retryError);
          }
        }
      }
      throw _mapError(e);
    }
  }

  AppException _mapError(DioException e) {
    final status = e.response?.statusCode;
    switch (status) {
      case 401:
      case 403:
        return AppException(
          'No tienes permisos para esta operación. Revisa las reglas de Firestore.',
          'Permiso denegado: ',
        );
      case 404:
        return FirestoreNotFoundException();
      case 409:
        return AppException('El recurso ya existe.', 'Firestore: ');
      case 400:
        return AppException(
          'Solicitud inválida a Firestore.',
          'Firestore: ',
        );
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          return NetworkException();
        }
        return UnknownException(
          'Error al conectar con Firestore (${status ?? 'sin código'}).',
        );
    }
  }

  Future<FirestoreDocument?> getDocument(String documentPath) async {
    try {
      final response = await _request('GET', '/$documentPath');
      final json = response.data as Map<String, dynamic>;
      return FirestoreDocument.fromJson(json);
    } on FirestoreNotFoundException {
      return null;
    }
  }

  Future<List<FirestoreDocument>> listDocuments(
    String collectionPath, {
    int? pageSize,
  }) async {
    final response = await _request(
      'GET',
      '/$collectionPath',
      query: {
        if (pageSize != null) 'pageSize': pageSize,
      },
    );
    final json = response.data as Map<String, dynamic>;
    final documents = json['documents'] as List? ?? [];
    return documents
        .map((d) => FirestoreDocument.fromJson(d as Map<String, dynamic>))
        .toList();
  }

  Future<FirestoreDocument> createDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final response = await _request(
      'POST',
      '/$collectionPath',
      data: {'fields': FirestoreValueCodec.encodeFields(data)},
      query: {'documentId': documentId},
    );
    return FirestoreDocument.fromJson(response.data as Map<String, dynamic>);
  }

  /// Crea el documento si no existe o lo actualiza (reemplaza los campos
  /// indicados). Devuelve el documento resultante.
  Future<FirestoreDocument> setDocument(
    String documentPath,
    Map<String, dynamic> data,
  ) async {
    final response = await _request(
      'PATCH',
      '/$documentPath',
      data: {'fields': FirestoreValueCodec.encodeFields(data)},
      query: {
        'updateMask.fieldPaths': data.keys.toList(),
      },
    );
    return FirestoreDocument.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteDocument(String documentPath) async {
    await _request('DELETE', '/$documentPath');
  }

  /// Ejecuta una consulta estructurada. [parentPath] permite consultar una
  /// subcolección (p. ej. `groups/abc`).
  Future<List<FirestoreDocument>> runQuery({
    required String collectionId,
    Map<String, dynamic>? where,
    int? limit,
    String? parentPath,
  }) async {
    final path = (parentPath == null || parentPath.isEmpty)
        ? ':runQuery'
        : '/$parentPath:runQuery';

    final response = await _request(
      'POST',
      path,
      data: {
        'structuredQuery': {
          'from': [
            {'collectionId': collectionId},
          ],
          if (where != null) 'where': where,
          if (limit != null) 'limit': limit,
        },
      },
    );

    final results = response.data as List? ?? [];
    final documents = <FirestoreDocument>[];
    for (final item in results) {
      final map = item as Map<String, dynamic>;
      final doc = map['document'];
      if (doc is Map<String, dynamic>) {
        documents.add(FirestoreDocument.fromJson(doc));
      }
    }
    return documents;
  }
}
