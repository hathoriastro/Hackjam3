import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:hackjamraion/components/user/budget_card.dart';
import 'package:hackjamraion/components/user/navbar.dart';
import 'package:hackjamraion/pages/auth/welcome_page.dart';
import 'package:hackjamraion/services/auth_services.dart';
import 'package:hackjamraion/services/export_services.dart';

class HomePageDemo extends StatefulWidget {
  const HomePageDemo({super.key});

  @override
  State<HomePageDemo> createState() => _HomePageDemoState();
}

class _HomePageDemoState extends State<HomePageDemo> {
  String? username;

  @override
  void initState() {
    super.initState();
    // getUsername();
  }

  // Future<void> getUsername() async {
  //   final uid = FirebaseAuth.instance.currentUser?.uid;
  //   if (uid != null) {
  //     final doc = await FirebaseFirestore.instance
  //         .collection("users")
  //         .doc(uid)
  //         .get();
  //     if (doc.exists) {
  //       setState(() {
  //         username = doc["username"];
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leadingWidth: 60,
        leading: Row(
          children: [
            SizedBox(width: 20),
            CircleAvatar(child: Text("A")),
          ],
        ),
        toolbarHeight: height * 0.14,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hai, welcome", style: TextStyle(fontSize: 12)),
            Text(
              username != null ? "$username" : "Loading username...",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ],
        ),
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
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Center(child: SaldoCard()),
            SizedBox(height: height * 0.03),
            Expanded(
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      spreadRadius: 0,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Catatan Keuangan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.43,
                            height: height * 0.08,
                            decoration: BoxDecoration(
                              color: primaryBlue40,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: darkGrey),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pemasukan",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Rp. -",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: width * 0.43,
                            height: height * 0.08,
                            decoration: BoxDecoration(
                              color: secondaryYellow20,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: darkGrey),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Pengeluaran",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "Rp. -",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      Container(
                        width: width * 0.89,
                        height: height * 0.1,
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: darkGrey),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lorem Ipsum",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Dolor Sit Amet",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SvgPicture.asset(
                                'assets/images/coins_graphic.svg',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
