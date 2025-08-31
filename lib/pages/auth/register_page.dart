import 'package:hackjamraion/components/colors.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      appBar: AppBar(
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
              const Text("Back"),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.2),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                            color: lightGray,
                          ),
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(height: constraints.maxHeight * 0.06),
                              const Text(
                                "Create your account",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: constraints.maxHeight * 0.05),

                              // 🔹 Input fields
                              customInputField(
                                context: context,
                                labelText: "Username",
                                controller: _usernameController,
                              ),
                              customInputField(
                                context: context,
                                labelText: "Email",
                                controller: _emailController,
                              ),
                              customInputField(
                                context: context,
                                labelText: "Password",
                                controller: _passwordController,
                                obscureText: true,
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
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    backgroundColor: primaryBlue,
                                  ),
                                  onPressed: register,
                                  child: _loading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : const Text("Register"),
                                ),
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
    );
  }
}

Widget customInputField({
  required BuildContext context,
  required String labelText,
  required TextEditingController controller,
  bool obscureText = false,
}) {
  double screenWidth = MediaQuery.of(context).size.width;
  double screenHeight = MediaQuery.of(context).size.height;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.008,
        ),
        child: TextField(
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(color: Colors.black54, fontSize: 12),
            floatingLabelBehavior: FloatingLabelBehavior.never,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
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
