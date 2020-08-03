part of 'address_bloc.dart';

class AddressState extends Equatable {
  final List<Address> list;
  final bool isLoading;

  const AddressState({this.list, this.isLoading});

  factory AddressState.initial() => AddressState(list: List<Address>());

  AddressState copyWith({List<Address> list, bool isLoading}) => AddressState(
      list: list ?? this.list, isLoading: isLoading ?? this.isLoading);

  @override
  List<Object> get props => [list, isLoading];
}
