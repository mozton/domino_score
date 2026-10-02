part of 'camera_bloc.dart';

enum CameraStatus { initial, loading, ready, error }

class CameraState extends Equatable {
  final CameraStatus status;
  final CameraController? controller;

  const CameraState({
    this.status = CameraStatus.initial,
    this.controller,
  });

  static const Object _unset = Object();

  CameraState copyWith({CameraStatus? status, Object? controller = _unset}) {
    return CameraState(
      status: status ?? this.status,
      controller: identical(controller, _unset)
          ? this.controller
          : controller as CameraController?,
    );
  }

  @override
  List<Object?> get props => [status, controller];
}
