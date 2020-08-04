part of 'address_bloc.dart';

class AddressState extends Equatable {
  final List<Address> list;

  const AddressState({this.list});

  factory AddressState.initial() => AddressState(list: List<Address>());

  AddressState copyWith({List<Address> list, bool isLoading}) =>
      AddressState(list: list ?? this.list);

  @override
  List<Object> get props => [list];
}

class AddressPostState extends Equatable {
  final Address data;

  const AddressPostState({this.data});

  factory AddressPostState.initial() => AddressPostState(
          data: Address(
        defAddr: false,
        onMap: false,
        model: 0,
        style: 0,
        city: '',
        community: '',
        street: '',
        building: '',
        roomNo: '',
        address: '',
      ));

  AddressPostState copyWith({Address data}) =>
      AddressPostState(data: data ?? this.data);

  @override
  List<Object> get props => [data];
}
