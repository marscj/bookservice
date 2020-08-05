import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'order_event.dart';
part 'order_state.dart';

// ignore_for_file: close_sinks
// ignore_for_file: non_constant_identifier_names

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final BuildContext context;

  OrderBloc(this.context) : super(OrderState.initial());

  RefreshController refreshController = RefreshController(initialRefresh: true);

  @override
  Stream<OrderState> mapEventToState(
    OrderEvent event,
  ) async* {
    if (event is RefreshOrderList) {
      yield await RestService.instance.getOrders(query: {
        'pageNo': 1,
        'pageSize': state.pageSize,
        'sorter': '-id'
      }).then<OrderState>((value) {
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
        }).then<OrderState>((value) {
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

class DropDownData extends Equatable {
  final int service;
  final int main;
  final int sub;

  DropDownData({this.service, this.main, this.sub});

  static generateMain({int service, int length}) {
    return List<DropDownData>.generate(
        length, (index) => DropDownData(service: service, main: index++));
  }

  static generateSub({int service, int main, int length}) {
    return List<DropDownData>.generate(length,
        (index) => DropDownData(service: service, main: main, sub: index++));
  }

  @override
  List<Object> get props => [service, main, sub];
}

class OrderFormBloc extends FormBloc<String, String> {
  final BuildContext context;
  final Order data;

  SelectFieldBloc status;
  SelectFieldBloc service;

  SelectFieldBloc main_info;
  SelectFieldBloc sub_info;

  TextFieldBloc from_date;
  TextFieldBloc to_date;
  TextFieldBloc code;
  TextFieldBloc address;
  TextFieldBloc lat;
  TextFieldBloc lng;

  OrderFormBloc(this.context, this.data) {
    status =
        SelectFieldBloc(items: [0, 1, 2, 3, 4, 5], initialValue: data.status);
    service = SelectFieldBloc(items: [0, 1, 2, 3], initialValue: data.service);
    main_info = SelectFieldBloc(
        items: DropDownData.generateMain(
            service: data.service,
            length: Localization.of(context).mainInfo[data.service].length),
        initialValue:
            DropDownData(service: data.service, main: data.main_info));
    sub_info = SelectFieldBloc(
        items: DropDownData.generateSub(
            service: data.service,
            main: data.main_info,
            length: Localization.of(context)
                .subInfo[data.service][data.main_info]
                .length),
        initialValue: DropDownData(
            service: data.service, main: data.main_info, sub: data.sub_info));

    from_date = TextFieldBloc(initialValue: '${data.from_date ?? ''}');
    to_date = TextFieldBloc(initialValue: '${data.to_date ?? ''}');
    code = TextFieldBloc(initialValue: '${data.code ?? ''}');
    address = TextFieldBloc(initialValue: '${data.address ?? ''}');
    lat = TextFieldBloc(initialValue: '${data.lat ?? ''}');
    lng = TextFieldBloc(initialValue: '${data.lng ?? ''}');

    addFieldBlocs(fieldBlocs: [
      status,
      service,
      main_info,
      sub_info,
      from_date,
      to_date,
      code,
      address,
      lat,
      lng
    ]);

    addValidators();
    addListen();
  }

  void addListen() {
    service
      ..listen((value) async {
        if (value != null && value.value != null) {
          main_info.updateValue(DropDownData(service: value.value, main: 0));
          sub_info
              .updateValue(DropDownData(service: value.value, main: 0, sub: 0));

          main_info.updateItems(DropDownData.generateMain(
              service: value.value,
              length: Localization.of(context).mainInfo[value.value].length));

          sub_info.updateItems(DropDownData.generateSub(
              service: value.value,
              main: 0,
              length: Localization.of(context).subInfo[value.value][0].length));
        }
      });

    main_info
      ..listen((value) async {
        if (value != null && value.value != null) {
          sub_info.updateValue(DropDownData(
              service: service.value, main: value.value.main, sub: 0));

          sub_info.updateItems(DropDownData.generateSub(
              service: service.value,
              main: value.value.main,
              length: Localization.of(context)
                  .subInfo[service.value][value.value.main]
                  .length));
        }
      });
  }

  void addValidators() {
    from_date.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
    to_date.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
    address.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
  }

  void addErrors(Map<String, dynamic> errors) {
    if (errors == null) {
      return;
    }

    status.addFieldError(errors['status']);
    service.addFieldError(errors['service']);
    from_date.addFieldError(errors['from_date']);
    to_date.addFieldError(errors['from_date']);
    address.addFieldError(errors['from_date'] ?? errors['non_field_errors']);
  }

  @override
  void onSubmitting() {}
}
