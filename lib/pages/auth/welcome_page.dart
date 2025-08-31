import 'package:hackjamraion/pages/auth/login_page.dart';
import 'package:hackjamraion/pages/auth/register_page.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Size of the whole screen
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: height * 0.2),
            Center(
              child: Text(
                'Welcome',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(height: height * 0.02),
            Center(
              child: Text(
                'Lorem Ipsum Dolor Sit Amet \nVel Nobis gw',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: height * 0.1),
            CircleAvatar(radius: 80),
            SizedBox(height: height * 0.1),
            SizedBox(
              width: width * 0.8,
              height: height * 0.06,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  backgroundColor: primaryBlue,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
                child: Text("Register"),
              ),
            ),
            SizedBox(height: height * 0.01),
            SizedBox(
              width: width * 0.8,
              height: height * 0.06,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                    side: BorderSide(width: 1),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Text("Login", style: TextStyle(color: primaryBlue)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
