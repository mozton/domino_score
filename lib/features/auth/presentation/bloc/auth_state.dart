part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  signedUp,
  passwordResetSent,
  deleted,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  static const Object _unset = Object();

  AuthState copyWith({
    AuthStatus? status,
    Object? user = _unset,
    Object? errorMessage = _unset,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: identical(user, _unset) ? this.user : user as User?,
      errorMessage: identical(errorMessage, _unset)
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
