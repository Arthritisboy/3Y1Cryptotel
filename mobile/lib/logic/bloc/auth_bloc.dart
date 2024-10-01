import 'package:bloc/bloc.dart';
import 'package:hotel_flutter/data/respositories/auth_repository.dart';
import 'package:hotel_flutter/logic/bloc/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    //! Handle Sign Up Event
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.register(event.signUpModel);
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    //! Handle Login Event
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.email, event.password);
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    //! Handle Forgot Password Event
    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.forgotPassword(event.email);
        emit(AuthSuccess('Reset link sent to your email'));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    //! Handle Reset Password Event
    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.resetPassword(
            event.token, event.newPassword, event.confirmPassword);
        emit(AuthSuccess('Password reset successful'));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
