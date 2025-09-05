import 'package:hackjamraion/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:hackjamraion/pages/auth/register_page.dart';
import 'package:hackjamraion/pages/user/home_page.dart';
import 'package:hackjamraion/pages/user/home_page_demo.dart';

import '../../services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String errorMessage = '   ';
  bool _loading = false;

  void signIn() async {
    try {
      await authService.value.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // navigasi ke HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePageDemo()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Error';
      });
    }
  }

  Future<void> signingoogle() async {
    setState(() {
      _loading = true;
      errorMessage = '';
    });

    try {
      UserCredential? userCredential = await authService.value
          .signInWithGoogle();
      if (userCredential != null) {
        print('Logged in with Google: ${userCredential.user?.displayName}');
      } else {
        print('Google sign-in was canceled or failed.');
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePageDemo()),
      );
    } on FirebaseAuthException catch (e) {
      print('Google sign-in error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Size of the whole screen
    final height = size.height;
    final width = size.width;
    bool _loading = false;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: height * 0.06,
        leadingWidth: width * 0.5,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: [
              SizedBox(width: width * 0.02),
              Icon(Icons.arrow_back_ios_new),
              SizedBox(width: width * 0.02),
              Text("Kembali"),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
              height: 500,
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(height: constraints.maxHeight * 0.25),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50),
                                ),
                                color: white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: constraints.maxHeight * 0.06,
                                  ),
                                  const Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Text(
                                      'Ayo cek lagi perjalanan keuanganmu hari ini!',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  customInputField(
                                    context: context,
                                    labelText: "Masukkan Email",
                                    controller: _emailController,
                                    title: 'Email',
                                  ),
                                  SizedBox(height: height * 0.02),
                                  customInputField(
                                    context: context,
                                    labelText: "Masukkan Password",
                                    controller: _passwordController,
                                    obscureText: true,
                                    title: 'Password',
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: width * 0.1,
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Lupa Password?',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      errorMessage,
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.8,
                                    height: height * 0.06,
                                    child: FilledButton(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            32,
                                          ),
                                        ),
                                        backgroundColor: primaryBlue,
                                      ),
                                      onPressed: () {
                                        signIn();
                                      },
                                      child: _loading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text("Login"),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        color: Colors.grey,
                                        height: 1,
                                        width: 75,
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        'Masuk dengan',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Container(
                                        color: Colors.grey,
                                        height: 1,
                                        width: 75,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                  GestureDetector(
                                    onTap: signingoogle,
                                    child: CircleAvatar(
                                      backgroundColor: grey,
                                      child: Image.asset(
                                        'assets/images/google_icon.png',
                                        scale: 1.75,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Belum punya akun?",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Daftar sekarang",
                                          style: TextStyle(
                                            color: primaryBlue,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget customInputField({
  required BuildContext context,
  required String labelText,
  required TextEditingController controller,
  required String title,
  bool obscureText = false,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.09),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.005,
        ),
        child: TextField(
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.black54, fontSize: 12),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white,
            filled: true,
          ),
        ),
      ),
    ],
  );
}
