import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackjamraion/components/anggaran_icon.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:hackjamraion/components/user/anggaran_card.dart';
import 'package:hackjamraion/components/user/atur_anggaran_input.dart';
import 'package:hackjamraion/components/user/navbar.dart';

class AnggaranPage extends StatefulWidget {
  const AnggaranPage({super.key});

  @override
  State<AnggaranPage> createState() => _AnggaranPageState();
}

class _AnggaranPageState extends State<AnggaranPage>
    with SingleTickerProviderStateMixin {
  String? username;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isPanelVisible = false;

  // Simpan budget tiap kategori dalam Map
  Map<String, int> budgets = {
    "Transportasi": 100000,
    "Pendidikan": 5000000,
    "Hiburan": 100000,
    "Kesehatan": 100000,
    "Belanja": 100000,
    "Makanan": 0,
    "Donasi": 0,
    "Biaya Darurat": 0,
    "Tagihan": 0,
  };

  // Controller input
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    getUsername();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Inisialisasi controller tiap kategori
    budgets.forEach((key, value) {
      controllers[key] = TextEditingController(text: value.toString());
    });
  }

  void _showPanel() {
    setState(() {
      _isPanelVisible = true;
      _controller.forward();
    });
  }

  void _hidePanel() {
    _controller.reverse().then((value) {
      setState(() {
        _isPanelVisible = false;
      });
    });
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

  void _saveBudgets() {
    setState(() {
      budgets.forEach((key, _) {
        final text = controllers[key]?.text ?? "0";
        budgets[key] = int.tryParse(text) ?? 0;
      });
    });
    _hidePanel();
  }

  @override
  void dispose() {
    _controller.dispose();
    controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        toolbarHeight: height * 0.09,
        backgroundColor: primaryBlue50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        leading: Icon(Icons.arrow_back_ios, color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Anggaran",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kategori',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      FilledButton(
                        onPressed: _showPanel,
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryBlue,
                        ),
                        child: Text('Atur Budget'),
                      ),
                    ],
                  ),
                  AnggaranCard(
                    title: 'Transportasi',
                    path: AppIcons.transportasi,
                    indicatorColor: Color(0xFF3A7879),
                    numBelow: 40000,
                    numUpper: budgets["Transportasi"]!,
                  ),
                  AnggaranCard(
                    title: 'Pendidikan',
                    path: AppIcons.pendidikan,
                    indicatorColor: Color(0xFF783A79),
                    numBelow: 1000000,
                    numUpper: budgets["Pendidikan"]!,
                  ),
                  AnggaranCard(
                    title: 'Hiburan',
                    path: AppIcons.hiburan,
                    indicatorColor: Color(0xFF793A3B),
                    numBelow: 40000,
                    numUpper: budgets["Hiburan"]!,
                  ),
                  AnggaranCard(
                    title: 'Kesehatan',
                    path: AppIcons.kesehatan,
                    indicatorColor: Color(0xFF9D6329),
                    numBelow: 40000,
                    numUpper: budgets["Kesehatan"]!,
                  ),
                  AnggaranCard(
                    title: 'Belanja',
                    path: AppIcons.belanja,
                    indicatorColor: Color(0xFF549D29),
                    numBelow: 40000,
                    numUpper: budgets["Belanja"]!,
                  ),
                  AnggaranCard(
                    title: 'Makanan',
                    path: AppIcons.makanan,
                    indicatorColor: Color(0xFF29749D),
                    numBelow: 40000,
                    numUpper: budgets["Makanan"]!,
                  ),
                  AnggaranCard(
                    title: 'Donasi',
                    path: AppIcons.donasi,
                    indicatorColor: Color(0xFF61299D),
                    numBelow: 40000,
                    numUpper: budgets["Donasi"]!,
                  ),
                  AnggaranCard(
                    title: 'Biaya Darurat',
                    path: AppIcons.biayaDarurat,
                    indicatorColor: Color(0xFF9D2929),
                    numBelow: 40000,
                    numUpper: budgets["Biaya Darurat"]!,
                  ),
                  AnggaranCard(
                    title: 'Tagihan',
                    path: AppIcons.belanja,
                    indicatorColor: Color(0xFFBCAA04),
                    numBelow: 40000,
                    numUpper: budgets["Tagihan"]!,
                  ),
                ],
              ),
            ),
          ),

          if (_isPanelVisible)
            GestureDetector(
              onTap: () {},
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _buildBudgetPanel(),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavbar(selectedItem: 1),
    );
  }

  Widget _buildBudgetPanel() {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _saveBudgets,
                  icon: const Icon(Icons.close),
                  color: Colors.grey[700],
                ),
                SizedBox(width: 30),
              ],
            ),
          ),
          const Text(
            'Atur budget per kategori',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: budgets.keys.map((key) {
                  return AturAnggaranInput(
                    title: key,
                    path: _getIconForCategory(key),
                    controller: controllers[key]!,
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getIconForCategory(String category) {
    switch (category) {
      case "Transportasi":
        return AppIcons.transportasi;
      case "Pendidikan":
        return AppIcons.pendidikan;
      case "Hiburan":
        return AppIcons.hiburan;
      case "Kesehatan":
        return AppIcons.kesehatan;
      case "Belanja":
        return AppIcons.belanja;
      case "Makanan":
        return AppIcons.makanan;
      case "Donasi":
        return AppIcons.donasi;
      case "Biaya Darurat":
        return AppIcons.biayaDarurat;
      case "Tagihan":
        return AppIcons.tagihan;
      default:
        return "";
    }
  }
}
