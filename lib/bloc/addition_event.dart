part of 'addition_bloc.dart';

abstract class AdditionEvent extends Equatable {
  const AdditionEvent();

  @override
  List<Object> get props => [];
}

class AdditionRefreshList extends AdditionEvent {}
