import 'package:dominos_score/core/network/firestore_rest_client.dart';
import 'package:dominos_score/features/profiles/data/datasources/profile_remote_data_source.dart';
import 'package:dominos_score/features/profiles/data/models/profile_model.dart';
import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  static const _collection = 'profiles';

  final FirestoreRestClient _client;

  ProfileRemoteDataSourceImpl(this._client);

  @override
  Future<Profile?> getProfile(String userId) async {
    final doc = await _client.getDocument('$_collection/$userId');
    if (doc == null) return null;
    return ProfileModel.fromMap(doc.id, doc.data);
  }

  @override
  Future<Profile> upsertProfile(Profile profile) async {
    await _client.setDocument(
      '$_collection/${profile.id}',
      ProfileModel.toMap(profile),
    );
    return profile;
  }
}
