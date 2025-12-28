abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final dynamic user; // Will be replaced with UserModel
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthPasswordResetSent extends AuthState {}

class AuthVerificationEmailSent extends AuthState {}

class AuthEmailVerified extends AuthState {}