import 'package:flutter/foundation.dart';
import 'auth_state.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  
  AuthState _state = AuthInitial();
  UserModel? _user;

  AuthViewModel({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  AuthState get state => _state;
  UserModel? get user => _user;
  bool get isLoading => _state is AuthLoading;
  bool get isAuthenticated => _state is AuthAuthenticated;

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }

  // Sign In
  Future<void> signIn(String email, String password) async {
    _setState(AuthLoading());
    
    try {
      _user = await _authRepository.signIn(email, password);
      _setState(AuthAuthenticated(_user));
    } catch (e) {
      _setState(AuthError(e.toString()));
    }
  }

  // Sign Up
  Future<void> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _setState(AuthLoading());
    
    try {
      _user = await _authRepository.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
      _setState(AuthAuthenticated(_user));
    } catch (e) {
      _setState(AuthError(e.toString()));
    }
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    _setState(AuthLoading());
    
    try {
      await _authRepository.resetPassword(email);
      _setState(AuthPasswordResetSent());
    } catch (e) {
      _setState(AuthError(e.toString()));
    }
  }

  // Resend Verification Email
  Future<void> resendVerificationEmail() async {
    _setState(AuthLoading());
    
    try {
      await _authRepository.resendVerificationEmail();
      _setState(AuthVerificationEmailSent());
    } catch (e) {
      _setState(AuthError(e.toString()));
    }
  }

  // Check Email Verified
  Future<void> checkEmailVerified() async {
    try {
      final isVerified = await _authRepository.checkEmailVerified();
      if (isVerified) {
        _setState(AuthEmailVerified());
      }
    } catch (e) {
      _setState(AuthError(e.toString()));
    }
  }

  // Sign Out
  Future<void> signOut() async {
    _setState(AuthLoading());
    
    try {
      await _authRepository.signOut();
      _user = null;
      _setState(AuthUnauthenticated());
    } catch (e) {
      _setState(AuthError(e.toString()));
    }
  }

  // Clear Error
  void clearError() {
    if (_state is AuthError) {
      _setState(AuthInitial());
    }
  }
}
