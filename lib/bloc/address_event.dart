part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressRefreshList extends AddressEvent {}

class AddressUpdate extends AddressEvent {
  final int id;
  final Address data;

  AddressUpdate(this.id, this.data);

  @override
  List<Object> get props => [id, data];
}

class AddressDelete extends AddressEvent {
  final int id;

  AddressDelete(this.id);

  @override
  List<Object> get props => [id];
}
