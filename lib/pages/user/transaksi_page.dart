import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackjamraion/components/user/navbar.dart';
import 'package:hackjamraion/pages/auth/welcome_page.dart';
import 'package:hackjamraion/services/auth_services.dart';
import 'package:hackjamraion/services/export_services.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("bang waktunya ga cukup bang \n"),
            Text("Reaksi programmer melihat tema HackJam 2025 :"),
            Container(
              color: Colors.white,
              child: Image.asset(
              'assets/images/meme1.png',
              width: 100,
              height: 100,
              ),
            )
            
          ],
        ),
      ),
      bottomNavigationBar: BottomNavbar(selectedItem: 3),
    );
  }
}
