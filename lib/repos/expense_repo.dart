import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/models/expense_model.dart';

class ExpenseRepo{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future <void> addExpense(ExpenseModel expense) async{
    await _firestore.collection('expenses').add(expense.toMap());
  }
  Stream<List<ExpenseModel>> getExpenses() {
    return _firestore
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      return ExpenseModel.fromMap(id, data);
    }).toList());
  }

  /// Delete an expense
  Future<void> deleteExpense(String docId) async {
    await _firestore.collection('expenses').doc(docId).delete();
  }
}