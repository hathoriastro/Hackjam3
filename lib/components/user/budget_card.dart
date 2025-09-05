import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:hackjamraion/pages/user/edit_saldo_page.dart';
import 'package:intl/intl.dart';

class SaldoCard extends StatefulWidget {
  const SaldoCard({super.key});

  @override
  State<SaldoCard> createState() => _SaldoCardState();
}

class _SaldoCardState extends State<SaldoCard> {
  int? _saldo;
  bool _loading = true;
  bool _isVisible = true; // ✅ default: saldo kelihatan

  @override
  void initState() {
    super.initState();
    _loadSaldo();
  }

  Future<void> _loadSaldo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (!mounted) return; // ✅ cegah error setState after dispose
    if (doc.exists) {
      setState(() {
        _saldo = doc.data()?["saldo"] ?? 0;
        _loading = false;
      });
    } else {
      setState(() {
        _saldo = 0;
        _loading = false;
      });
    }
  }

  String formatRupiah(int value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Stack(
      children: [
        Center(
          child: Container(
            width: width * 0.94,
            height: height * 0.19,
            decoration: BoxDecoration(
              color: primaryBlue80,
              border: Border.all(color: const Color(0xFFD0D0D0)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Center(
          child: SizedBox(
            width: width * 0.94,
            height: height * 0.19,
            child: Positioned(
              top: 20,
              child: SvgPicture.asset('assets/images/budget_card_bg.svg'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sisa Saldo",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isVisible = !_isVisible; // ✅ toggle visibilitas
                      });
                    },
                    child: Icon(
                      _isVisible
                          ? Icons.remove_red_eye
                          : Icons.visibility_off, // ✅ ganti icon
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _loading
                      ? "Loading..."
                      : _isVisible
                          ? "••••••"// ✅ tersembunyiformatRupiah(_saldo ?? 0) // ✅ tampil saldo
                          : formatRupiah(_saldo ?? 0), // ✅ tampil saldo
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Selalu sisihkan 10% pemasukan untuk \ntabungan darurat.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditSaldoPage(),
                        ),
                      );
                      _loadSaldo(); // ✅ refresh saldo setelah edit
                    },
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: secondaryYellow,
                      child: Icon(Icons.mode_edit, color: primaryBlue70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
