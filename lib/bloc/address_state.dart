part of 'address_bloc.dart';

class AddressState extends Equatable {
  final List<Address> list;

  const AddressState({this.list});

  factory AddressState.initial() => AddressState(list: List<Address>());

  AddressState copyWith({List<Address> list}) =>
      AddressState(list: list ?? this.list);

  @override
  List<Object> get props => [list];
}
