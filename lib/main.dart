import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentations/viewmodels/auth/auth_viewmodel.dart';
import 'presentations/viewmodels/dashboard/dashboard_viewmodel.dart';
import 'presentations/views/auth/sign_in_screen.dart';
import 'core/themes/app_colors.dart';

void main() {
  runApp(const MerchantPaymentApp());
}

class MerchantPaymentApp extends StatelessWidget {
  const MerchantPaymentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
      ],
      child: MaterialApp(
        title: 'Merchant Payment Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
          ),
        ),
        home: const SignInScreen(),
      ),
    );
  }
}