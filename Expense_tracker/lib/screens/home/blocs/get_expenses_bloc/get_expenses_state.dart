part of 'get_expenses_bloc.dart';

sealed class GetExpensesState extends Equatable {
  const GetExpensesState();

  @override
  List<Object> get props => [];
}

class GetExpensesInitial extends GetExpensesState {}

class GetExpensesLoading extends GetExpensesState {}
class GetExpensesFailure extends GetExpensesState {}
class GetExpensesSuccess extends GetExpensesState {
  final List<Expense> expenses;

  const GetExpensesSuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}