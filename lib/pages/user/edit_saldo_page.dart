import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackjamraion/components/colors.dart';

class EditSaldoPage extends StatefulWidget {
  const EditSaldoPage({super.key});

  @override
  State<EditSaldoPage> createState() => _EditSaldoPageState();
}

class _EditSaldoPageState extends State<EditSaldoPage> {
  final TextEditingController _saldoController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSaldo();
  }

  Future<void> _loadSaldo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();

    if (doc.exists) {
      final saldo = doc.data()?["saldo"] ?? 0;
      _saldoController.text = saldo.toString();
    }
  }

  Future<void> _saveSaldo() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isLoading = true);

    final saldoBaru = int.tryParse(_saldoController.text) ?? 0;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"saldo": saldoBaru});

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pop(context); // balik ke page sebelumnya
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Edit Saldo",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: 
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Saldo Anda",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _saldoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan saldo",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: width,
            height: height * 0.07,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveSaldo,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Simpan",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
