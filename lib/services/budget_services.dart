import 'package:cloud_firestore/cloud_firestore.dart';

class BudgetService {
  final _firestore = FirebaseFirestore.instance;

  // Tambah pengeluaran ke kategori tertentu
  Future<void> addExpense(String category, int amount) async {
    final ref = _firestore.collection('budgets').doc(category);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(ref);
      if (!snapshot.exists) throw Exception("Kategori $category tidak ditemukan");

      final current = snapshot['numBelow'] ?? 0;
      transaction.update(ref, {
        'numBelow': current + amount,
      });
    });
  }
}
