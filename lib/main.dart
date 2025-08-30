import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackjamraion/auth/register_page.dart';
import 'package:hackjamraion/auth/welcome_page.dart';
import 'firebase_options.dart';
import 'auth/register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'manrope'),
      debugShowCheckedModeBanner: false,
      home: const WelcomePage(),
    );
  }
}
