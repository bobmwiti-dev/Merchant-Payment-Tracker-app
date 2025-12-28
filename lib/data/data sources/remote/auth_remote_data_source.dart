import '../../models/user_model.dart';

class AuthRemoteDataSource {
  // Simulate network delay
  Future<void> _delay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  // Sign In (Mock implementation - Replace with Firebase)
  Future<UserModel> signIn(String email, String password) async {
    await _delay();

    // Mock validation
    if (email == 'demo@merchant.com' && password == 'password123') {
      return UserModel(
        id: '1',
        name: 'John Merchant',
        email: email,
        phone: '+1234567890',
        token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
        createdAt: DateTime.now(),
      );
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // Sign Up (Mock implementation - Replace with Firebase)
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _delay();

    // Mock validation
    if (email == 'existing@merchant.com') {
      throw Exception('Email already exists');
    }

    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: email,
      phone: phone,
      token: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );
  }

  // Reset Password (Mock implementation)
  Future<void> resetPassword(String email) async {
    await _delay();
    // In real app: await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // Resend Verification Email (Mock implementation)
  Future<void> resendVerificationEmail() async {
    await _delay();
    // In real app: await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }

  // Check Email Verified (Mock implementation)
  Future<bool> checkEmailVerified() async {
    await _delay();
    // In real app: 
    // await FirebaseAuth.instance.currentUser?.reload();
    // return FirebaseAuth.instance.currentUser?.emailVerified ?? false;
    return false; // Mock: always return false
  }

  // Sign Out (Mock implementation)
  Future<void> signOut() async {
    await _delay();
    // In real app: await FirebaseAuth.instance.signOut();
  }
}
