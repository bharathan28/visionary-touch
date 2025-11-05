import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc/expense_bloc.dart';
import 'bloc/expense_event.dart';
import 'repos/expense_repo.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // 🔥 Initializes Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ExpenseRepo(), // Inject Repository
      child: BlocProvider(
        create: (context) => ExpenseBloc(context.read<ExpenseRepo>())..add(LoadExpenses()),
        child: MaterialApp(
          title: 'Expense Tracker',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            useMaterial3: true,
          ),
          home: const HomeScreen(),
        ),
      ),
    );
  }
}