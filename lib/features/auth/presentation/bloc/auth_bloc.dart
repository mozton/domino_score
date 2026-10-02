import 'package:dominos_score/core/utils/input_validator.dart';
import 'package:dominos_score/features/auth/domain/entities/user_entity.dart';
import 'package:dominos_score/features/auth/domain/usecase/check_auth_status_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/delete_account_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/privacy_policy_usecases.dart';
import 'package:dominos_score/features/auth/domain/usecase/send_password_reset_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_in_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:dominos_score/features/auth/domain/usecase/sign_up_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// BLoC de autenticación (Firebase REST).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final CheckAuthStatusUseCase _checkAuthStatus;
  final SignInUseCase _signIn;
  final SignUpUseCase _signUp;
  final SignOutUseCase _signOut;
  final SendPasswordResetUseCase _sendPasswordReset;
  final DeleteAccountUseCase _deleteAccount;
  final RejectPrivacyPolicyUseCase _rejectPrivacyPolicy;

  AuthBloc({
    required CheckAuthStatusUseCase checkAuthStatus,
    required SignInUseCase signIn,
    required SignUpUseCase signUp,
    required SignOutUseCase signOut,
    required SendPasswordResetUseCase sendPasswordReset,
    required DeleteAccountUseCase deleteAccount,
    required RejectPrivacyPolicyUseCase rejectPrivacyPolicy,
  }) : _checkAuthStatus = checkAuthStatus,
       _signIn = signIn,
       _signUp = signUp,
       _signOut = signOut,
       _sendPasswordReset = sendPasswordReset,
       _deleteAccount = deleteAccount,
       _rejectPrivacyPolicy = rejectPrivacyPolicy,
       super(const AuthState()) {
    on<AuthStatusChecked>(_onCheckStatus);
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
    on<PasswordResetRequested>(_onPasswordReset);
    on<DeleteAccountRequested>(_onDeleteAccount);
    on<AuthErrorCleared>(_onClearError);
  }

  Future<void> _onCheckStatus(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _checkAuthStatus();
      emit(
        state.copyWith(
          status: user != null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
          user: user,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: InputValidator.parseException(e),
        ),
      );
    }
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _signIn(event.email, event.password);
      emit(
        state.copyWith(status: AuthStatus.authenticated, user: user),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: InputValidator.parseException(e),
        ),
      );
    }
  }

  Future<void> _onSignUp(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _signUp(event.email, event.password);
      emit(
        state.copyWith(status: AuthStatus.signedUp, user: user),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: InputValidator.parseException(e),
        ),
      );
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _signOut();
    emit(
      state.copyWith(status: AuthStatus.unauthenticated, user: null),
    );
  }

  Future<void> _onPasswordReset(
    PasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _sendPasswordReset(event.email);
      emit(state.copyWith(status: AuthStatus.passwordResetSent));
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: InputValidator.parseException(e),
        ),
      );
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      await _deleteAccount();
      await _rejectPrivacyPolicy();
      emit(
        state.copyWith(status: AuthStatus.deleted, user: null),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: InputValidator.parseException(e),
        ),
      );
    }
  }

  void _onClearError(AuthErrorCleared event, Emitter<AuthState> emit) {
    emit(state.copyWith(errorMessage: null));
  }
}
