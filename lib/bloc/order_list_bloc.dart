import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookservice/apis/client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'order_list_event.dart';
part 'order_list_state.dart';

class OrderListBloc extends Bloc<OrderListEvent, OrderListState> {
  final BuildContext context;

  OrderListBloc(this.context) : super(OrderListState.initial());

  RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  Stream<OrderListState> mapEventToState(
    OrderListEvent event,
  ) async* {
    if (event is RefreshOrderList) {
      yield await RestService.instance.getOrders(query: {
        'pageNo': 1,
        'pageSize': state.pageSize,
        'sorter': '-id'
      }).then<OrderListState>((value) {
        refreshController.refreshCompleted();
        return state.copyWith(
            list: value.data, pageNo: 2, totalCount: value.totalCount);
      }).catchError((onError) {
        refreshController.refreshFailed();
        return state.copyWith(list: [], pageNo: 1, totalCount: 0);
      });
    }

    if (event is LoadOrderList) {
      if (state.list.length < state.totalCount) {
        yield await RestService.instance.getOrders(query: {
          'pageNo': state.pageNo,
          'pageSize': state.pageSize,
          'sorter': '-id'
        }).then<OrderListState>((value) {
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
