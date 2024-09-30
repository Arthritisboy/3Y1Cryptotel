import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotel_flutter/data/data_provider/auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import 'package:hotel_flutter/data/model/user_model.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthDataProvider authProvider;

  AuthBloc(this.authProvider) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield AuthLoading();
      try {
        final data = await authProvider.login(event.email, event.password);
        final user = UserModel.fromJson(data);
        yield Authenticated(user);
      } catch (e) {
        yield AuthError(e.toString());
      }
    } else if (event is RegisterEvent) {
      yield AuthLoading();
      try {
        final data = await authProvider.register(event.email, event.password);
        final user = UserModel.fromJson(data);
        yield Authenticated(user);
      } catch (e) {
        yield AuthError(e.toString());
      }
    }
  }
}
