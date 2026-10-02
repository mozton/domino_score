part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStatusChecked extends AuthEvent {
  const AuthStatusChecked();
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const SignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class DeleteAccountRequested extends AuthEvent {
  const DeleteAccountRequested();
}

class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}
