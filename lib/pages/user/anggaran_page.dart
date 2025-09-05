import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackjamraion/components/anggaran_icon.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:hackjamraion/components/user/anggaran_card.dart';
import 'package:hackjamraion/components/user/atur_anggaran_input.dart';
import 'package:hackjamraion/components/user/budget_card.dart';
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

  // simpan budget default
  Map<String, int> budgets = {
    "Transportasi": 0,
    "Pendidikan": 0,
    "Hiburan": 0,
    "Kesehatan": 0,
    "Belanja": 0,
    "Makanan": 0,
    "Donasi": 0,
    "Biaya Darurat": 0,
    "Tagihan": 0,
  };

  // data dari Firestore
  Map<String, dynamic> data = {};

  // controller untuk text input tiap kategori
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();

    getUsername();
    getBudgets();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // inisialisasi controller default
    budgets.forEach((key, value) {
      controllers[key] = TextEditingController(text: value.toString());
    });
  }

  // ambil username dari Firestore
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

  // ambil budgets dari Firestore
  Future<void> getBudgets() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (doc.exists) {
      setState(() {
        data = doc.data()?["budgets"] ?? {};

        // update controllers sesuai data Firestore
        data.forEach((key, value) {
          controllers[key] = TextEditingController(
            text: value["numUpper"]?.toString() ?? "0",
          );
        });
      });
    }
  }

  // ambil total transaksi per kategori
  Future<Map<String, int>> _getTotalsByCategory() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .get();

    Map<String, int> totals = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final kategori = (data['kategori'] ?? 'lainnya').toString().toLowerCase();
      final harga = (data['harga'] ?? 0) as num;

      totals[kategori] = (totals[kategori] ?? 0) + harga.toInt();
    }

    return totals;
  }

  void _saveBudgets() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() {
      budgets.forEach((key, _) {
        final text = controllers[key]?.text ?? "0";
        budgets[key] = int.tryParse(text) ?? 0;
      });
    });

    final newData = budgets.map(
      (key, value) => MapEntry(key, {
        "numUpper": value,
        "numBelow": data[key]?["numBelow"] ?? 0,
      }),
    );

    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "budgets": newData,
    }, SetOptions(merge: true));

    if (!mounted) return;
    setState(() {
      data = newData;
    });

    _hidePanel();
  }

  // panel control
  void _showPanel() {
    setState(() {
      _isPanelVisible = true;
      _controller.forward();
    });
  }

  void _hidePanel() {
    // sebelum panel ditutup, simpan dulu
    _saveBudgets();

    _controller.reverse().then((value) {
      setState(() {
        _isPanelVisible = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    controllers.forEach((_, c) => c.dispose());
    super.dispose();
  }

  // build UI
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.09,
        backgroundColor: primaryBlue50,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
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
          FutureBuilder<Map<String, int>>(
            future: _getTotalsByCategory(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final totals = snapshot.data!;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Center(child: SaldoCard()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
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
                            child: const Text('Atur Budget'),
                          ),
                        ],
                      ),
                      // setiap kategori
                      AnggaranCard(
                        title: 'Transportasi',
                        path: AppIcons.transportasi,
                        indicatorColor: const Color(0xFF3A7879),
                        numBelow: totals["transportasi"] ?? 0,
                        numUpper: data["Transportasi"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Pendidikan',
                        path: AppIcons.pendidikan,
                        indicatorColor: const Color(0xFF783A79),
                        numBelow: totals["pendidikan"] ?? 0,
                        numUpper: data["Pendidikan"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Hiburan',
                        path: AppIcons.hiburan,
                        indicatorColor: const Color(0xFF793A3B),
                        numBelow: totals["hiburan"] ?? 0,
                        numUpper: data["Hiburan"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Kesehatan',
                        path: AppIcons.kesehatan,
                        indicatorColor: const Color(0xFF9D6329),
                        numBelow: totals["kesehatan"] ?? 0,
                        numUpper: data["Kesehatan"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Belanja',
                        path: AppIcons.belanja,
                        indicatorColor: const Color(0xFF549D29),
                        numBelow: totals["belanja"] ?? 0,
                        numUpper: data["Belanja"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Makanan',
                        path: AppIcons.makanan,
                        indicatorColor: const Color(0xFF29749D),
                        numBelow: totals["makanan"] ?? 0,
                        numUpper: data["Makanan"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Donasi',
                        path: AppIcons.donasi,
                        indicatorColor: const Color(0xFF61299D),
                        numBelow: totals["donasi"] ?? 0,
                        numUpper: data["Donasi"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Biaya Darurat',
                        path: AppIcons.biayaDarurat,
                        indicatorColor: const Color(0xFF9D2929),
                        numBelow: totals["biaya darurat"] ?? 0,
                        numUpper: data["Biaya Darurat"]?["numUpper"] ?? 0,
                      ),
                      AnggaranCard(
                        title: 'Tagihan',
                        path: AppIcons.tagihan,
                        indicatorColor: const Color(0xFFBCAA04),
                        numBelow: totals["tagihan"] ?? 0,
                        numUpper: data["Tagihan"]?["numUpper"] ?? 0,
                      ),
                    ],
                  ),
                ),
              );
            },
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
      bottomNavigationBar: const BottomNavbar(selectedItem: 1),
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
                  onPressed: _hidePanel,
                  icon: const Icon(Icons.close),
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 30),
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
