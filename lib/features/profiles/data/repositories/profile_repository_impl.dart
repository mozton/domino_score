import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/core/network/current_user_provider.dart';
import 'package:dominos_score/features/profiles/data/datasources/profile_remote_data_source.dart';
import 'package:dominos_score/features/profiles/domain/entities/profile_entity.dart';
import 'package:dominos_score/features/profiles/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final CurrentUserProvider _currentUser;

  ProfileRepositoryImpl(this._remoteDataSource, this._currentUser);

  Future<String> _requireUserId() async {
    final uid = await _currentUser.currentUserId();
    if (uid == null || uid.isEmpty) {
      throw AppException('Sesión no válida. Inicia sesión de nuevo.');
    }
    return uid;
  }

  @override
  Future<Profile?> getMyProfile() async {
    final uid = await _requireUserId();
    return _remoteDataSource.getProfile(uid);
  }

  @override
  Future<Profile> saveMyProfile(Profile profile) async {
    final uid = await _requireUserId();
    return _remoteDataSource.upsertProfile(profile.copyWith(id: uid));
  }
}
