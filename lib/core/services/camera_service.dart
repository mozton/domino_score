import 'dart:io';

import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

class CameraService {
  CameraController? _controller;

  CameraController? get controller => _controller;

  Future<void> initializeCamera() async {
    final camera = await availableCameras();
    if (camera.isEmpty) {
      throw Exception('No se encontraron camaras disponibles.');
    }
    _controller = CameraController(
      camera.first,
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
  }

  Future<XFile> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('La camara no esta inicializada.');
    }
    return await _controller!.takePicture();
  }

  Future<void> disposeCamera() async {
    await _controller?.dispose();
    _controller = null;
  }

  /// Aplica un filtro blanco y negro con eliminación de brillos y recorta a
  /// 4:3 para coincidir con la vista de cámara.
  static Future<File> applyBlackAndWhiteFilter(File original) async {
    final bytes = await original.readAsBytes();
    img.Image image = img.decodeImage(bytes)!;

    if (image.height > image.width) {
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

    image = img.grayscale(image);

    const int thresholdValue = 70;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        final img.Pixel pixel = image.getPixel(x, y);
        final num luminance = img.getLuminance(pixel);

        if (luminance > thresholdValue) {
          image.setPixelRgba(x, y, 230, 230, 230, 230);
        } else {
          image.setPixelRgba(x, y, 0, 0, 0, 255);
        }
      }
    }

    image = img.adjustColor(image, contrast: 1.5);

    final result = File(original.path.replaceAll('.jpg', '_bw.jpg'))
      ..writeAsBytesSync(img.encodeJpg(image, quality: 90));

    return result;
  }
}
