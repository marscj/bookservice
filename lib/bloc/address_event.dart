part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressRefreshList extends AddressEvent {}

class AddressUpdate extends AddressEvent {
  final Address data;

  AddressUpdate(this.data);

  @override
  List<Object> get props => [data];
}

class AddressPost extends AddressEvent {
  final int id;
  final Map<String, dynamic> payload;

  AddressPost(this.id, this.payload);

  @override
  List<Object> get props => [id, payload];
}

class AddressDelete extends AddressEvent {
  final int id;

  AddressDelete(this.id);

  @override
  List<Object> get props => [id];
}
