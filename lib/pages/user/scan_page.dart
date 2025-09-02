import 'dart:io';
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

  String? _ocrText;
  bool _loading = false;

  Future<void> _scanImage() async {
    setState(() => _loading = true);

    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked == null) {
      setState(() => _loading = false);
      return;
    }

    final inputImage = InputImage.fromFile(File(picked.path));
    final recognizedText = await _recognizer.processImage(inputImage);

    setState(() {
      _ocrText = recognizedText.text;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Receipt')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _scanImage,
              child: const Text('Scan Receipt'),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_ocrText != null)
              Expanded(
                child: SingleChildScrollView(child: Text(_ocrText!)),
              ),
          ],
        ),
      ),
    );
  }
}