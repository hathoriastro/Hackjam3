import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackjamraion/components/user/navbar.dart';
import 'package:hackjamraion/pages/auth/welcome_page.dart';
import 'package:hackjamraion/services/auth_services.dart';
import 'package:hackjamraion/services/export_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? username;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();
      if (doc.exists) {
        setState(() {
          username = doc["username"];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.value.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: height * 0.2),
            Center(
              child: Text(
                username != null
                    ? "Hello, $username 👋"
                    : "Loading username...",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(selectedItem: 0),
    );
  }
}
