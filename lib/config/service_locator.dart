import 'dart:io';

import 'package:dominos_score/data/repositories/setting_repository_impl.dart';
import 'package:dominos_score/domain/repositories/setting_resopitory.dart';
import 'package:image/image.dart' as img;
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

    Provider<SettingRepository>(create: (context) => SettingRepositoryImpl()),

    ChangeNotifierProvider<SettingViewModel>(
      create: (context) => SettingViewModel(context.read<SettingRepository>()),
    ),

    ChangeNotifierProvider<CameraViewModel>(create: (_) => CameraViewModel()),

    ChangeNotifierProvider<GameViewmodel>(
      create: (context) => GameViewmodel(context.read<GameRepositoryImpl>()),
    ),
  ];
}

// Funcion para aplicar filtro blanco y negro con eliminación de brillos
Future<File> applyBlackAndWhiteFilter(File original) async {
  final bytes = await original.readAsBytes();
  img.Image image = img.decodeImage(bytes)!;

  // 0. Recortar a 4:3 (Portrait) para coincidir con la vista de cámara
  // La imagen original suele ser 16:9 (o lo que de el sensor).
  // 4:3 = 0.75 aspect ratio.
  if (image.height > image.width) {
    // Portrait
    final targetHeight = (image.width * 4 / 3).round();
    if (image.height > targetHeight) {
      final yOffset = (image.height - targetHeight) ~/ 2;
      image = img.copyCrop(
        image,
        x: 0,
        y: yOffset,
        width: image.width,
        height: targetHeight,
      );
    }
  }

  // 1. Convertir a blanco y negro
  image = img.grayscale(image);

  // 2. Eliminar brillos usando un threshold
  // Valores típicos: 160, 170, 180 (ajusta según tu foto)
  int thresholdValue = 70;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      img.Pixel pixel = image.getPixel(x, y);

      num luminance = img.getLuminance(pixel);

      // Si el pixel es muy brillante → se fuerza a blanco
      if (luminance > thresholdValue) {
        image.setPixelRgba(x, y, 230, 230, 230, 230);
      }
      // Si es más oscuro → se fuerza a negro
      else {
        image.setPixelRgba(x, y, 0, 0, 0, 255);
      }
    }
  }

  // 3. Aumentar contraste (opcional) - Valor 1.0 es default, 1.2 un poco más.
  // El usuario tenía 50 (muy alto?) o 100. Probamos con 1.5 para resaltar sin destruir.
  image = img.adjustColor(image, contrast: 1.5);

  // 4. Guardar resultado
  final result = File(original.path.replaceAll('.jpg', '_bw.jpg'))
    ..writeAsBytesSync(img.encodeJpg(image, quality: 90));

  return result;
}
