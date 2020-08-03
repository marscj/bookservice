import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookservice/apis/client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'address_event.dart';
part 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final BuildContext context;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  AddressBloc(this.context) : super(AddressState.initial());

  @override
  Stream<AddressState> mapEventToState(
    AddressEvent event,
  ) async* {
    if (event is AddressRefreshList) {
      yield await RestService.instance.getAddress().then<AddressState>((value) {
        refreshController.refreshCompleted();
        return state.copyWith(list: value ?? []);
      }).catchError((onError) {
        refreshController.refreshFailed();
        return state.copyWith(list: []);
      });
    }

    if (event is AddressUpdateList) {
      yield state.copyWith(isLoading: true);

      yield await RestService.instance
          .updateAddress(event.id, event.playload)
          .then((value) {
        return RestService.instance.getAddress();
      }).then<AddressState>((value) {
        return state.copyWith(list: value ?? [], isLoading: false);
      }).catchError((onError) {
        return state.copyWith(isLoading: false);
      });
    }

    if (event is AddressDelList) {
      yield state.copyWith(isLoading: true);

      yield await RestService.instance.deleteAddress(event.id).then((value) {
        return RestService.instance.getAddress();
      }).then<AddressState>((value) {
        return state.copyWith(list: value ?? [], isLoading: false);
      }).catchError((onError) {
        return state.copyWith(isLoading: false);
      });
    }
  }
}
