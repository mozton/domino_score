import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dominos_score/data/remote/dominos_counter_service.dart';

import 'package:dominos_score/services/camera_service.dart';
import 'package:flutter/material.dart';

class CameraViewModel extends ChangeNotifier {
  final CameraService _cameraService = CameraService();
  final DominosCounter _dominosCounter = DominosCounter();

  CameraController? get cameraController => _cameraService.controller;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    try {
      await _cameraService.initializeCamera();
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      print('Error al inicializar la camara: $e');
    }
    notifyListeners();
  }

  Future<int> processImage(XFile image) async {
    final bytes = await File(image.path).readAsBytes();
    final base64Image = base64Encode(bytes);
    final points = await _dominosCounter.getDominosPointFromImg(base64Image);
    return points;
  }

  @override
  void dispose() {
    _cameraService.disposeCamera();
    super.dispose();
  }
}
