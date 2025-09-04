import 'dart:io';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackjamraion/components/colors.dart';
import 'package:hackjamraion/pages/user/preview_page.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanPageDemo extends StatefulWidget {
  const ScanPageDemo({super.key});

  @override
  State<ScanPageDemo> createState() => _ScanPageDemoState();
}

class _ScanPageDemoState extends State<ScanPageDemo> {
  final _picker = ImagePicker();
  final _recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final _firestore = FirebaseFirestore.instance;

  String? _ocrText;
  XFile? _pickedImage;
  bool _isLoading = false;

  // Ganti dengan URL webhook n8n milikmu
  final String _n8nWebhookUrl =
      'https://hathoriastro.app.n8n.cloud/webhook-test/e761aae7-415b-4cd0-bb9e-60b1d0ddf03a';

  Future<void> _scanImageAndProcess() async {
    setState(() {
      _isLoading = true;
      _ocrText = null;
    });

    try {
      final picked = await _picker.pickImage(source: ImageSource.camera);
      if (picked == null) {
        setState(() => _isLoading = false);
        return;
      }

      _pickedImage = picked;

      // OCR
      final inputImage = InputImage.fromFile(File(picked.path));
      final recognizedText = await _recognizer.processImage(inputImage);
      _ocrText = recognizedText.text;

      // Kirim ke n8n & ambil hasil kategori
      final items = await _callN8n(_ocrText!);

      final editedItems = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PreviewPage(items: items)),
      );

      // Kalau user klik save (check), hasil balik ke sini
      if (editedItems != null) {
        for (var item in editedItems) {
          await _firestore.collection("expenses").add({
            "nama": item["nama"],
            "kategori": item["kategori"],
            "harga": item["harga"],
            "createdAt": FieldValue.serverTimestamp(),
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil disimpan")),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memproses nota: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<List<Map<String, dynamic>>> _callN8n(String ocrText) async {
    try {
      final response = await http.post(
        Uri.parse(_n8nWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'teks_nota': ocrText}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        throw Exception('Gagal ambil data dari n8n: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error saat memanggil n8n: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        toolbarHeight: height * 0.09,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        backgroundColor: primaryBlue50,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const Text(
          'Tambah Transaksi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: width,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/scanpage/receipt_graphic.svg',
              width: 250,
              height: 250,
            ),
            SizedBox(height: height * 0.05),
            Container(
              height: height * 0.35,
              width: width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black)],
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.only(left: 15, top: 20, right: 15),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bikin Baru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Pilih cara yang kamu mau',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    GestureDetector(
                      onTap: _isLoading ? null : _scanImageAndProcess,
                      child: Container(
                        height: height * 0.1,
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              'assets/images/scanpage/camera_icon.svg',
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hitung Otomatis Pakai Struk',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Foto strukmu dan AI akan scan \notomatis',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: height * 0.1,
                        decoration: BoxDecoration(
                          color: Color(0xFFF2F2F2),
                          border: Border.all(width: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              'assets/images/scanpage/rincian_icon.svg',
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Masukkan rinciannya sendiri',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Tambah detail transaksi sesuai \nkebutuhanmu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Icon(Icons.arrow_forward_ios),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
