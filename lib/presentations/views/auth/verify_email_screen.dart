import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../viewmodels/auth/auth_viewmodel.dart';
import '../../viewmodels/auth/auth_state.dart';
import '../../../core/themes/app_colors.dart';
import '../common/custom_button.dart';
import '../dashboard/dashboard_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _checkEmailVerification();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = 60;
    _canResend = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _checkEmailVerification() {
    // Poll for email verification every 3 seconds
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      final authViewModel = context.read<AuthViewModel>();
      await authViewModel.checkEmailVerified();

      if (!mounted) {
        timer.cancel();
        return;
      }

      final state = authViewModel.state;
      if (state is AuthEmailVerified) {
        timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      }
    });
  }

  Future<void> _handleResendEmail() async {
    final authViewModel = context.read<AuthViewModel>();
    await authViewModel.resendVerificationEmail();

    if (!mounted) return;

    final state = authViewModel.state;
    if (state is AuthVerificationEmailSent) {
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.primaryGradient,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(),
                  const SizedBox(height: 40),
                  _buildContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.mark_email_unread_outlined,
        size: 64,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<AuthViewModel>(
      builder: (context, AuthViewModel authViewModel, child) {
        final isLoading = authViewModel.state is AuthLoading;

        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We\'ve sent a verification link to:',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade100,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Please check your email and click the verification link to continue.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'I\'ve Verified My Email',
                onPressed: isLoading
                    ? null
                    : () async {
                        await authViewModel.checkEmailVerified();
                        if (!mounted) return;

                        final state = authViewModel.state;
                        if (state is AuthEmailVerified) {
                          Navigator.pushReplacement(
                            this.context,
                            MaterialPageRoute(
                              builder: (context) => const DashboardScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Email not verified yet. Please check your inbox.'),
                              backgroundColor: Colors.orange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                isLoading: isLoading,
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: _canResend && !isLoading
                    ? _handleResendEmail
                    : null,
                icon: Icon(
                  Icons.refresh,
                  color: _canResend ? AppColors.primary : Colors.grey,
                ),
                label: Text(
                  _canResend
                      ? 'Resend Verification Email'
                      : 'Resend in \\$_resendCountdown seconds',
                  style: TextStyle(
                    color: _canResend ? AppColors.primary : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  await authViewModel.signOut();
                  if (!mounted) return;
                  Navigator.popUntil(this.context, (route) => route.isFirst);
                },
                child: Text(
                  'Use Different Email',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}