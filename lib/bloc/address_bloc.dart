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
    yield await RestService.instance.getAddress().then<AddressState>((value) {
      refreshController.refreshCompleted();
      return state.copyWith(list: value);
    }).catchError((onError) {
      refreshController.refreshFailed();
      return state.copyWith(list: []);
    });
  }
}
