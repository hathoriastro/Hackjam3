import 'package:flutter/material.dart';
import 'package:hackjamraion/pages/auth/welcome_page.dart';
import 'package:hackjamraion/pages/user/home_page.dart';
import 'package:hackjamraion/services/auth_services.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.pageIfNotConnected});

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = CircularProgressIndicator.adaptive();
            } else if (snapshot.hasData) {
              widget = const HomePage();
            } else {
              widget = pageIfNotConnected ?? const WelcomePage();
            }
            return widget;
          },
        );
      },
    );
  }
}
