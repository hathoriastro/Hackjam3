import 'package:flutter/material.dart';

class PreviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const PreviewPage({super.key, required this.items});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late List<Map<String, dynamic>> editableItems;

  @override
  void initState() {
    super.initState();
    editableItems = List.from(widget.items);
  }

  void _saveEdits() {
    Navigator.pop(context, editableItems); 
    // data yang sudah diedit akan dikembalikan ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preview Nota")),
      body: ListView.builder(
        itemCount: editableItems.length,
        itemBuilder: (context, index) {
          final item = editableItems[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Edit Nama Barang
                  TextField(
                    controller: TextEditingController(text: item["nama"]),
                    decoration: const InputDecoration(labelText: "Nama Barang"),
                    onChanged: (val) => editableItems[index]["nama"] = val,
                  ),

                  const SizedBox(height: 10),

                  // Edit Harga
                  TextField(
                    controller: TextEditingController(text: item["harga"].toString()),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Harga"),
                    onChanged: (val) {
                      final parsed = int.tryParse(val);
                      if (parsed != null) {
                        editableItems[index]["harga"] = parsed;
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  // Edit Kategori
                  DropdownButton<String>(
                    value: item["kategori"],
                    items: ["makanan", "transportasi", "belanja", "lainnya"]
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        editableItems[index]["kategori"] = val!;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveEdits,
        child: const Icon(Icons.check),
      ),
    );
  }
}
