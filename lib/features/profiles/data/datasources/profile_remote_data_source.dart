import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<Profile?> getProfile(String userId);
  Future<Profile> upsertProfile(Profile profile);
}
