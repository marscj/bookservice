part of 'addition_bloc.dart';

class AdditionState extends Equatable {
  final List<SourceImage> list;

  const AdditionState({this.list});

  factory AdditionState.initial() => AdditionState(list: List<SourceImage>());

  AdditionState copyWith({List<Address> list, bool isLoading}) =>
      AdditionState(list: list ?? this.list);

  @override
  List<Object> get props => [list];
}
