import 'package:dominos_score/domain/datasourse/url_launcher_data_source.dart';
import 'package:dominos_score/domain/repositories/url_launcher_repository.dart';

class UrlLauncherRepositoryImpl implements UrlLauncherRepository {
  final UrlLauncherDataSource _dataSource;

  UrlLauncherRepositoryImpl(this._dataSource);

  @override
  Future<void> openInstagram() async {
    return _dataSource.openInstagram();
  }
}
