import 'dart:io';
import 'dart:convert';
import 'package:hackjamraion/pages/user/preview_page.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _scanImageAndProcess,
              child: const Text('Pindai Nota'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
