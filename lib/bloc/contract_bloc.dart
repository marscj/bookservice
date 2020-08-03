import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookservice/apis/client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'contract_event.dart';
part 'contract_state.dart';

class ContractBloc extends Bloc<ContractEvent, ContractState> {
  final BuildContext context;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  ContractBloc(this.context) : super(ContractState.initial());

  @override
  Stream<ContractState> mapEventToState(
    ContractEvent event,
  ) async* {
    if (event is ContractRefreshList) {
      yield await RestService.instance.getContracts(query: {
        'pageNo': 1,
        'pageSize': state.pageSize,
        'sorter': '-id'
      }).then<ContractState>((value) {
        refreshController.refreshCompleted();
        return state.copyWith(
            list: value.data, pageNo: 2, totalCount: value.totalCount);
      }).catchError((onError) {
        refreshController.refreshFailed();
        return state.copyWith(list: [], pageNo: 1, totalCount: 0);
      });
    }

    if (event is ContractLoadList) {
      if (state.list.length < state.totalCount) {
        yield await RestService.instance.getContracts(query: {
          'pageNo': state.pageNo,
          'pageSize': state.pageSize,
          'sorter': '-id'
        }).then<ContractState>((value) {
          refreshController.loadComplete();
          return state.copyWith(
              list: state.list + value.data,
              pageNo: state.pageNo + 1,
              totalCount: value.totalCount);
        }).catchError((onError) {
          refreshController.refreshFailed();
          return state;
        });
      } else {
        refreshController.loadComplete();
      }
    }
  }

  @override
  Future<void> close() {
    refreshController.dispose();
    return super.close();
  }
}
