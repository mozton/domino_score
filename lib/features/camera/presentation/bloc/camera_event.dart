part of 'camera_bloc.dart';

sealed class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object?> get props => [];
}

class CameraInitialized extends CameraEvent {
  const CameraInitialized();
}
