import 'package:hackjamraion/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:hackjamraion/pages/auth/login_page.dart';
import 'package:hackjamraion/pages/user/home_page.dart';
import '../../services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String errorMessage = '';
  bool _loading = false;

  Future<void> register() async {
    setState(() {
      _loading = true;
      errorMessage = '';
    });

    try {
      await authService.value.createAccount(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        username: _usernameController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message ?? 'Error';
      });
    } finally {
      setState(() {
        _loading = false;
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
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print('Google sign-in error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

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
              const Icon(Icons.arrow_back_ios_new),
              SizedBox(width: width * 0.02),
              const Text("Kembali"),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned(
            top: -310,
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
                          SizedBox(height: constraints.maxHeight * 0.08),
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
                                    "Buat Akun",
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
                                      'Daftar sekarang dan nikmati cara baru mengatur uang dengan lebih pintar.',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  SizedBox(
                                    height: constraints.maxHeight * 0.05,
                                  ),

                                  // 🔹 Input fields
                                  customInputField(
                                    context: context,
                                    labelText: "Masukkan Nama Lengkap",
                                    controller: _usernameController,
                                    title: "Nama Lengkap",
                                  ),
                                  SizedBox(height: height * 0.02),
                                  customInputField(
                                    context: context,
                                    labelText: "Masukkan Email",
                                    controller: _emailController,
                                    title: "Email",
                                  ),
                                  SizedBox(height: height * 0.02),
                                  customInputField(
                                    context: context,
                                    labelText: "Masukkan Password",
                                    controller: _passwordController,
                                    obscureText: true,
                                    title: "Password",
                                  ),

                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: height * 0.02),

                                  // 🔹 Register button
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
                                      onPressed: register,
                                      child: _loading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text("Daftar"),
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
                                        'Daftar dengan',
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
                                        "Sudah punya akun?",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Masuk di sini",
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
        child: Text(title),
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
