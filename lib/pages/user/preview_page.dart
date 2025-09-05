import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:hackjamraion/pages/user/anggaran_page.dart';

class PreviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const PreviewPage({super.key, required this.items});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late List<Map<String, dynamic>> editableItems;

  // Tambahan di dalam _PreviewPageState

  void _addNewItem() {
    setState(() {
      editableItems.add({"nama": "", "harga": 0, "kategori": "lainnya"});
    });
  }

  @override
  void initState() {
    super.initState();
    editableItems = List.from(widget.items);
  }

  Future<void> _saveEdits() async {
    final firestore = FirebaseFirestore.instance;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final userDoc = firestore.collection('users').doc(uid);

    for (var item in editableItems) {
      final harga = (item["harga"] ?? 0) as int;
      final kategori = item["kategori"]?.toString().toLowerCase() ?? "lainnya";

      // simpan transaksi
      await firestore.collection('transactions').add({
        "uid": uid,
        "nama": item["nama"],
        "kategori": kategori,
        "harga": harga,
        "tanggal": FieldValue.serverTimestamp(),
      });

      // update numBelow di budgets
      await userDoc.set({
        "budgets": {
          kategori: {"numBelow": FieldValue.increment(harga)},
        },
      }, SetOptions(merge: true));
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AnggaranPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close_rounded),
        ),
      ),
      body: Stack(
        children: [
          // Background atas
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: height * 0.20,
              decoration: const BoxDecoration(
                color: secondaryYellow,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
          ),

          // ListView dalam container
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: height * 0.14, left: 16, right: 16),
              constraints: BoxConstraints(maxHeight: height * 0.9),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 7, bottom: 80),
                itemCount: editableItems.length + 1, // +1 buat tombol tambah
                itemBuilder: (context, index) {
                  if (index == editableItems.length) {
                    // --- Slot terakhir = tombol tambah ---
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: BorderSide(color: secondaryYellow),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: _addNewItem,
                        icon: Icon(Icons.add, color: Colors.white),
                        label: Text(
                          "Tambah Rincian",
                          style: TextStyle(
                            color: secondaryYellow,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }

                  // --- Item normal ---
                  final item = editableItems[index];
                  return Card(
                    elevation: 0,
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(left: 8, right: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Edit Nama
                          TextField(
                            controller: TextEditingController(
                              text: item["nama"],
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: primaryBlue70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: Colors.blue[900],
                            onChanged: (val) =>
                                editableItems[index]["nama"] = val,
                          ),

                          const SizedBox(height: 10),

                          // Edit Harga
                          TextField(
                            controller: TextEditingController(
                              text: item["harga"].toString(),
                            ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefixText: "Rp ",
                              prefixStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              filled: true,
                              fillColor: primaryBlue70,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            cursorColor: Colors.blue[900],
                            onChanged: (val) {
                              final parsed = int.tryParse(val);
                              if (parsed != null) {
                                editableItems[index]["harga"] = parsed;
                              }
                            },
                          ),

                          const SizedBox(height: 10),

                          // Edit Kategori
                          Container(
                            decoration: BoxDecoration(
                              color: primaryBlue70,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButton<String>(
                              value: item["kategori"],
                              items:
                                  [
                                        "Transportasi",
                                        "Pendidikan",
                                        "Hiburan",
                                        "Kesehatan",
                                        "Belanja",
                                        "Makanan",
                                        "Donasi",
                                        "Biaya Darurat",
                                        "Tagihan",
                                        "lainnya",
                                      ]
                                      .map(
                                        (cat) => DropdownMenuItem(
                                          value: cat,
                                          child: Text(
                                            cat,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (val) {
                                setState(() {
                                  editableItems[index]["kategori"] = val!;
                                });
                              },
                              dropdownColor: primaryBlue70,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              underline: Container(),
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          Divider(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        color: Colors.white,
        shape: AutomaticNotchedShape(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
            side: BorderSide(),
          ),
        ),
        child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: secondaryYellow),
          onPressed: _saveEdits,
          child: Text('Konfirmasi', style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
