part of 'address_bloc.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object> get props => [];
}

class AddressRefreshList extends AddressEvent {}

class AddressUpdateList extends AddressEvent {
  final int id;
  final Map<String, dynamic> playload;

  AddressUpdateList(this.id, this.playload);

  @override
  List<Object> get props => [id, playload];
}

class AddressDelList extends AddressEvent {
  final int id;

  AddressDelList(this.id);

  @override
  List<Object> get props => [id];
}
