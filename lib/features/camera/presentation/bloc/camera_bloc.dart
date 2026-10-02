import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:dominos_score/core/error/app_exception.dart';
import 'package:dominos_score/core/services/camera_service.dart';
import 'package:dominos_score/core/services/dominos_counter_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'camera_event.dart';
part 'camera_state.dart';

/// BLoC que gestiona el ciclo de vida de la cámara y el procesado OCR de la
/// foto para contar los puntos del dominó.
class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraService _cameraService;
  final DominosCounter _counter;

  CameraBloc({
    required CameraService cameraService,
    required DominosCounter counter,
  }) : _cameraService = cameraService,
       _counter = counter,
       super(const CameraState()) {
    on<CameraInitialized>(_onInit);
  }

  Future<void> _onInit(
    CameraInitialized event,
    Emitter<CameraState> emit,
  ) async {
    emit(state.copyWith(status: CameraStatus.loading));
    try {
      await _cameraService.initializeCamera();
      emit(
        state.copyWith(
          status: CameraStatus.ready,
          controller: _cameraService.controller,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CameraStatus.error));
    }
  }

  CameraController? get cameraController => _cameraService.controller;

  /// Procesa la foto tomada y devuelve los puntos detectados.
  Future<int> processImage(XFile image) async {
    final filteredImage = await CameraService.applyBlackAndWhiteFilter(
      File(image.path),
    );
    final imageBytes = await filteredImage.readAsBytes();
    final base64Image = base64Encode(imageBytes);
    return _counter.getDominosPointFromImg(base64Image);
  }

  /// Convierte un error en un mensaje amigable para el usuario.
  static String messageFor(Object e) {
    if (e is DioException && e.error is AppException) {
      return (e.error as AppException).message;
    }
    if (e is AppException) {
      return e.message;
    }
    return 'Ha ocurrido un error inesperado';
  }

  @override
  Future<void> close() async {
    await _cameraService.disposeCamera();
    return super.close();
  }
}
