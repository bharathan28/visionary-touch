import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';
import '../models/expense_model.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  double calculateTotal(List<ExpenseModel> expenses, bool Function(DateTime) filter) {
    return expenses
        .where((expense) => filter(expense.date))
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Summary')),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ExpenseLoaded) {
            final expenses = state.expenses;
            final now = DateTime.now();

            final todayTotal = calculateTotal(
              expenses,
                  (date) =>
              date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day,
            );

            final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
            final weekTotal = calculateTotal(
              expenses,
                  (date) => date.isAfter(startOfWeek.subtract(const Duration(days: 1))),
            );

            final monthTotal = calculateTotal(
              expenses,
                  (date) =>
              date.year == now.year && date.month == now.month,
            );

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SummaryCard(label: 'Today', amount: todayTotal),
                  SummaryCard(label: 'This Week', amount: weekTotal),
                  SummaryCard(label: 'This Month', amount: monthTotal),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final double amount;

  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          '₹${amount.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 18, color: Colors.indigo),
        ),
      ),
    );
  }
}
