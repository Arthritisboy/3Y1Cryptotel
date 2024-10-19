import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:hotel_flutter/data/repositories/auth_repository.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_event.dart';
import 'package:hotel_flutter/logic/bloc/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Pass the profile picture if available
        final user = await authRepository.register(
          event.signUpModel,
          event.profilePicture != null ? File(event.profilePicture!) : null,
        );
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError('Registration failed: ${e.toString()}'));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.login(event.email, event.password);
        emit(AuthenticatedLogin(user)); // Pass the LoginModel directly
      } catch (e) {
        emit(AuthError('Login failed: ${e.toString()}'));
      }
    });
    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.forgotPassword(event.email);
        emit(const AuthSuccess('Reset link sent to your email'));
      } catch (e) {
        emit(AuthError('Failed to send reset link: ${e.toString()}'));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.resetPassword(
            event.token, event.newPassword, event.confirmPassword);
        emit(const AuthSuccess('Password reset successful'));
      } catch (e) {
        emit(AuthError('Failed to reset password: ${e.toString()}'));
      }
    });

    on<FetchAllUsersEvent>((event, emit) async {
      emit(AuthLoading()); // Start with loading state
      try {
        // Fetch users from the repository
        final users = await authRepository.fetchAllUsers();

        // Emit the state with fetched users
        print('Emitting UsersFetched with ${users.length} users');
        emit(UsersFetched(users));
      } catch (e) {
        // Log error if fetching users fails
        print('Failed to fetch users: ${e.toString()}');
        emit(AuthError('Failed to fetch users: ${e.toString()}'));
      }
    });

    on<FetchAllManagersEvent>((event, emit) async {
      emit(AuthLoading()); // Start with loading state
      try {
        // Fetch managers from the repository
        final managers = await authRepository.fetchAllManagers();

        // Emit the state with fetched managers
        print('Emitting ManagersFetched with ${managers.length} managers');
        emit(UsersFetched(managers)); // Reusing UsersFetched for managers
      } catch (e) {
        // Log error if fetching managers fails
        print('Failed to fetch managers: ${e.toString()}');
        emit(AuthError('Failed to fetch managers: ${e.toString()}'));
      }
    });

    on<GetUserEvent>((event, emit) async {
      emit(AuthLoading()); // Start with loading state
      try {
        // Fetch user data from the repository
        final user = await authRepository.getUser(event.userId);

        // Emit authenticated state with the fetched user
        emit(Authenticated(user));
      } catch (e) {
        emit(AuthError('Failed to fetch user data: ${e.toString()}'));
      }
    });
    on<DeleteAccountEvent>((event, emit) async {
      emit(AuthLoading()); // Emit loading state
      try {
        await authRepository.deleteAccount();
        emit(const AccountDeleted('Account deleted successfully'));
        await Future.delayed(const Duration(milliseconds: 500));
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError('Failed to delete account: ${e.toString()}'));
      }
    });

    on<ResendCodeEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.resendCode(event.email);
        emit(const AuthSuccess('Verification code resent successfully!'));
      } catch (e) {
        emit(AuthError('Failed to resend verification code: ${e.toString()}'));
      }
    });

    on<ChangePasswordEvent>((event, emit) async {
      emit(PasswordChanging());
      try {
        await authRepository.changePassword(
          event.oldPassword,
          event.newPassword,
          event.confirmPassword,
        );
        emit(const AuthPasswordChangeSuccess('Password changed successfully'));
      } catch (e) {
        emit(PasswordChangeFailure('Password change failed: ${e.toString()}'));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Call the repository to update the user
        final updatedUser = await authRepository.updateUser(
          event.user,
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          profilePicture:
              event.profilePicture != null ? File(event.profilePicture!) : null,
        );

        // Emit the updated user state
        emit(UserUpdated(updatedUser));
      } catch (e) {
        emit(AuthError('Failed to update user data: ${e.toString()}'));
      }
    });
    on<VerifyUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.verifyUser(event.email, event.code);
        emit(const AuthSuccessVerification('Verification successful!'));
      } catch (e) {
        emit(AuthError('Verification failed: ${e.toString()}'));
      }
    });

    on<LogoutEvent>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await authRepository.logout();
          emit(const AuthSuccess(
              'Logged out successfully!')); // Provide user feedback
          await Future.delayed(
              const Duration(milliseconds: 500)); // Optional delay for feedback
          emit(AuthInitial()); // Transition to initial state
        } catch (e) {
          emit(AuthError('Failed to logout: ${e.toString()}'));
        }
      },
    );

    // Handle the CompleteOnboardingEvent
    on<CompleteOnboardingEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.completeOnboarding();
        emit(const AuthSuccess('Onboarding completed successfully'));
      } catch (e) {
        emit(AuthError('Failed to complete onboarding: ${e.toString()}'));
      }
    });

    on<AddToFavoritesEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.addToFavorites(event.userId, event.type, event.id);
        emit(FavoritesSuccess('Added to favorites'));

        // Fetch updated favorites
        final updatedFavorites =
            await authRepository.getFavorites(event.userId);
        emit(FavoritesFetched(updatedFavorites)); // Pass the updated favorites
      } catch (e) {
        emit(FavoritesError('Failed to add to favorites: ${e.toString()}'));
      }
    });

    on<RemoveFromFavoritesEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.removeFromFavorites(
            event.userId, event.type, event.id);
        emit(FavoritesSuccess('Removed from favorites'));

        // Fetch updated favorites
        final updatedFavorites =
            await authRepository.getFavorites(event.userId);
        emit(FavoritesFetched(updatedFavorites)); // Pass the updated favorites
      } catch (e) {
        emit(
            FavoritesError('Failed to remove from favorites: ${e.toString()}'));
      }
    });

    on<GetFavoritesEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final favorites = await authRepository.getFavorites(event.userId);
        emit(FavoritesFetched(favorites)); // Pass the favorites directly
      } catch (e) {
        emit(FavoritesError('Failed to fetch favorites: ${e.toString()}'));
      }
    });
  }
}
