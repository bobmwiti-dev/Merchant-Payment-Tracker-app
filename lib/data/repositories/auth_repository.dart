import '../models/user_model.dart';
import '../data sources/remote/auth_remote_data_source.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository({AuthRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AuthRemoteDataSource();

  Future<UserModel> signIn(String email, String password) async {
    try {
      return await _remoteDataSource.signIn(email, password);
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      return await _remoteDataSource.signUp(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _remoteDataSource.resendVerificationEmail();
    } catch (e) {
      throw Exception('Resend verification failed: ${e.toString()}');
    }
  }

  Future<bool> checkEmailVerified() async {
    try {
      return await _remoteDataSource.checkEmailVerified();
    } catch (e) {
      throw Exception('Check verification failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }
}