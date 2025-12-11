import 'dart:io';

import 'package:dominos_score/data/local/database_helper.dart';
import 'package:dominos_score/data/remote/remote_auth_data_source_impl.dart';
import 'package:dominos_score/data/repositories/auth_repository_impl.dart';
import 'package:dominos_score/data/repositories/game_repository_impl.dart';
import 'package:dominos_score/domain/datasourse/local_game_data_source.dart';
import 'package:dominos_score/domain/datasourse/remote_auth_data_source.dart';
import 'package:dominos_score/domain/repositories/auth_repository.dart';
import 'package:dominos_score/presentation/viewmodel/camera_viewmodel.dart';
import 'package:dominos_score/presentation/viewmodel/game_viewmodel.dart';
import 'package:dominos_score/presentation/viewmodel/setting_viewmodel.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:image/image.dart' as img;

class ServiceLocator {
  Future<List<SingleChildWidget>> init() async {
    return providers;
  }

  final List<SingleChildWidget> providers = [
    Provider<LocalGameDataSource>(create: (_) => DatabaseHelper()),

    Provider<FlutterSecureStorage>(create: (_) => const FlutterSecureStorage()),
    Provider<RemoteAuthDataSource>(
      create: (context) =>
          RemoteAuthDataSourceImpl(context.read<FlutterSecureStorage>()),
    ),

    Provider<AuthRepository>(
      create: (context) => AuthRepositoryImpl(
        context.read<RemoteAuthDataSource>(),
        context.read<FlutterSecureStorage>(),
      ),
    ),

    Provider<GameRepositoryImpl>(
      create: (context) => GameRepositoryImpl(
        localDataSource: context.read<LocalGameDataSource>(),
      ),
    ),

    ChangeNotifierProvider<SettingViewModel>(create: (_) => SettingViewModel()),

    ChangeNotifierProvider<CameraViewModel>(create: (_) => CameraViewModel()),

    ChangeNotifierProvider<GameViewmodel>(
      create: (context) => GameViewmodel(context.read<GameRepositoryImpl>()),
    ),
  ];
}

// Funcion para aplicar filtro de blanco y negro
Future<File> applyBlackAndWhiteFilter(File original) async {
  final bytes = await original.readAsBytes();
  img.Image image = img.decodeImage(bytes)!;

  // 1. Convertir a blanco y negro
  image = img.grayscale(image);

  // 2. Aumentar contraste (0 a 150 es útil)
  image = img.adjustColor(image, contrast: 120);

  // 3. Guardar resultado
  final result = File(original.path.replaceAll('.jpg', '_bw.jpg'))
    ..writeAsBytesSync(img.encodeJpg(image, quality: 90));

  return result;
}
