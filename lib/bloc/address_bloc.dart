import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookservice/apis/client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'address_event.dart';
part 'address_state.dart';

// ignore_for_file: close_sinks

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final BuildContext context;

  RefreshController refreshController = RefreshController(initialRefresh: true);

  AddressBloc(this.context) : super(AddressState.initial());

  @override
  Stream<AddressState> mapEventToState(
    AddressEvent event,
  ) async* {
    print(event);
    if (event is AddressRefreshList) {
      yield await RestService.instance
          .getAddressList()
          .then<AddressState>((value) {
        refreshController.refreshCompleted();
        return state.copyWith(list: value ?? []);
      }).catchError((onError) {
        refreshController.refreshFailed();
        return state.copyWith(list: []);
      });
    }

    if (event is AddressUpdate) {
      yield state.copyWith(isLoading: true);

      yield await RestService.instance
          .updateAddress(event.id, event.payload)
          .then((value) {
        return RestService.instance.getAddressList();
      }).then<AddressState>((value) {
        return state.copyWith(list: value ?? [], isLoading: false);
      }).catchError((onError) {
        return state.copyWith(isLoading: false);
      });
    }

    if (event is AddressUpdate) {
      yield state.copyWith(isLoading: true);

      yield await RestService.instance.deleteAddress(event.id).then((value) {
        return RestService.instance.getAddressList();
      }).then<AddressState>((value) {
        return state.copyWith(list: value ?? [], isLoading: false);
      }).catchError((onError) {
        print(onError);
        return state.copyWith(isLoading: false);
      });
    }
  }
}

class AddressPostBloc extends Bloc<AddressEvent, AddressPostState> {
  AddressPostBloc(AddressPostState initialState) : super(initialState);

  @override
  Stream<AddressPostState> mapEventToState(AddressEvent event) async* {
    if (event is AddressUpdate) {
      yield await RestService.instance
          .updateAddress(event.id, event.payload)
          .then((value) => AddressPostState(data: value))
          .catchError((onError) {});
    }
  }
}

class AddressFormBloc extends FormBloc<String, String> {
  final SelectFieldBloc model = SelectFieldBloc(
    items: ['Option 1', 'Option 2'],
    initialValue: 'Option 1',
  );

  final SelectFieldBloc style = SelectFieldBloc(
    items: ['Option 1', 'Option 2'],
    initialValue: 'Option 1',
  );

  final TextFieldBloc city = TextFieldBloc();
  final TextFieldBloc community = TextFieldBloc();
  final TextFieldBloc street = TextFieldBloc();
  final TextFieldBloc building = TextFieldBloc();
  final TextFieldBloc roomNo = TextFieldBloc();
  final TextFieldBloc lat = TextFieldBloc();
  final TextFieldBloc lng = TextFieldBloc();
  final TextFieldBloc address = TextFieldBloc();

  AddressFormBloc() {
    addFieldBlocs(fieldBlocs: [
      model,
      style,
      city,
      community,
      street,
      building,
      roomNo,
      lat,
      lng,
      address
    ]);
  }

  void addErrors(Map<String, dynamic> errors) {
    if (errors == null) {
      return;
    }

    model.addFieldError(errors['model'] ?? errors['non_field_errors']);
  }

  @override
  void onSubmitting() {}
}
