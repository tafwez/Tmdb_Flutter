import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/api_client.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final ApiClient _apiClient;

  AuthCubit(this._apiClient) : super(AuthInitial());

  bool get isAuthenticated => state is AuthAuthenticated;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      // Step 1: Create request token
      final tokenResponse = await _apiClient.createRequestToken();
      if (!tokenResponse.success) {
        emit(const AuthError('Failed to create request token'));
        return;
      }

      // Step 2: Validate with login
      final validatedToken = await _apiClient.validateWithLogin(
        username: username,
        password: password,
        requestToken: tokenResponse.requestToken,
      );

      if (!validatedToken.success) {
        emit(const AuthError('Invalid credentials'));
        return;
      }

      // Step 3: Create session
      /*  final sessionResponse = await _apiClient.createSession(
        validatedToken.requestToken,
      );*/

      /* if (!sessionResponse.success) {
        emit(const AuthError('Failed to create session'));
        return;
      }*/

      _apiClient.setSessionId(validatedToken.requestToken);
      // final userDetails = await _apiClient.getAccountDetails();

      emit(
        AuthAuthenticated(
          // user: userDetails,
          sessionId: validatedToken.requestToken,
        ),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.deleteSession();
      await _apiClient.clearSession();
      emit(AuthUnauthenticated());
    } catch (e) {
      // Still clear local session even if API call fails
      await _apiClient.clearSession();
      emit(AuthUnauthenticated());
    }
  }

  Future<void> checkAuthStatus() async {
    final sessionId = _apiClient.sessionId;
    if (sessionId != null) {
      try {
        //  final userDetails = await _apiClient.getAccountDetails();
        emit(AuthAuthenticated(sessionId: sessionId));
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> testLoading() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 3));
    emit(AuthInitial());
  }
}
