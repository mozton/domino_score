import 'package:camera/camera.dart';

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
}
