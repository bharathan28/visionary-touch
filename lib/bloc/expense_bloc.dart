import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repos/expense_repo.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import '../../models/expense_model.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepo repository;
  StreamSubscription? _subscription;

  ExpenseBloc(this.repository) : super(ExpenseLoading()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<AddExpense>(_onAddExpense);
    on<DeleteExpense>(_onDeleteExpense);
  }

  void _onLoadExpenses(LoadExpenses event, Emitter<ExpenseState> emit) {
    emit(ExpenseLoading());
    _subscription?.cancel();
    _subscription = repository.getExpenses().listen((expenses) {
      add(_ExpenseStreamUpdated(expenses)); // Hidden event
    });
  }

  void _onAddExpense(AddExpense event, Emitter<ExpenseState> emit) async {
    await repository.addExpense(event.expense);
  }

  void _onDeleteExpense(DeleteExpense event, Emitter<ExpenseState> emit) async {
    await repository.deleteExpense(event.id);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// 👇 This event is only used internally by the bloc (not from UI)
class _ExpenseStreamUpdated extends ExpenseEvent {
  final List<ExpenseModel> expenses;
  const _ExpenseStreamUpdated(this.expenses);

  @override
  List<Object?> get props => [expenses];
}
