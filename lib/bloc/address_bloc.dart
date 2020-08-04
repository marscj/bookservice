import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:bookservice/bloc/app_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
  }
}

class AddressPostBloc extends Bloc<AddressEvent, AddressPostState> {
  AddressPostBloc(AddressPostState initialState) : super(initialState);

  @override
  Stream<AddressPostState> mapEventToState(AddressEvent event) async* {
    if (event is AddressFormEvent) {
      yield AddressFormState();
    }

    if (event is AddressMapEvent) {
      yield AddressMapState();
    }
  }
}

class AddressFormBloc extends FormBloc<String, String> {
  final BuildContext context;

  SelectFieldBloc model;
  SelectFieldBloc style;
  TextFieldBloc city;
  TextFieldBloc community;
  TextFieldBloc street;
  TextFieldBloc building;
  TextFieldBloc roomNo;

  AddressFormBloc(this.context, Address data) {
    model = SelectFieldBloc(items: [0, 1], initialValue: 0);
    style = SelectFieldBloc(items: [0, 1], initialValue: 0);
    city = TextFieldBloc();
    community = TextFieldBloc();
    street = TextFieldBloc();
    building = TextFieldBloc();
    roomNo = TextFieldBloc();

    addFieldBlocs(fieldBlocs: [
      model,
      style,
      city,
      community,
      street,
      building,
      roomNo,
    ]);

    addValidators();
  }

  void addValidators() {
    city.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
    community.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
    street.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
    building.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
    roomNo.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
  }

  void addErrors(Map<String, dynamic> errors) {
    if (errors == null) {
      return;
    }

    model.addFieldError(errors['city']);
    model.addFieldError(errors['community']);
    model.addFieldError(errors['street']);
    model.addFieldError(errors['building']);
    model.addFieldError(errors['roomNo'] ?? errors['non_field_errors']);
  }

  @override
  void onSubmitting() {
    String id = RouteData.of(context).pathParams['id'].value;
    int userId = BlocProvider.of<AppBloc>(context).state.user.id;

    if (id != 'null') {
      RestService.instance
          .updateAddress(
              id,
              Address(
                  defAddr: false,
                  onMap: false,
                  model: model.value,
                  style: style.value,
                  city: city.value,
                  community: community.value,
                  street: street.value,
                  building: building.value,
                  roomNo: roomNo.value,
                  user_id: userId))
          .then((value) {
        emitSuccess(canSubmitAgain: true);
      }).catchError((onError) {
        emitFailure();
        addErrors(onError?.response?.data);
      });
    } else {
      RestService.instance
          .postAddress(Address(
              defAddr: false,
              onMap: false,
              model: model.value,
              style: style.value,
              city: city.value,
              community: community.value,
              street: street.value,
              building: building.value,
              roomNo: roomNo.value,
              user_id: userId))
          .then((value) {
        emitSuccess(canSubmitAgain: true);
      }).catchError((onError) {
        emitFailure();
        addErrors(onError?.response?.data);
      });
    }
  }
}

class AddressMapBloc extends FormBloc<String, String> {
  final BuildContext context;

  SelectFieldBloc model;
  SelectFieldBloc style;
  TextFieldBloc lat;
  TextFieldBloc lng;
  TextFieldBloc address;

  AddressMapBloc(this.context, Address data) {
    model = SelectFieldBloc(items: [0, 1], initialValue: data.model);
    style = SelectFieldBloc(items: [0, 1], initialValue: data.style);
    lat = TextFieldBloc(initialValue: '${data.lat}');
    lng = TextFieldBloc(initialValue: '${data.lng}');
    address = TextFieldBloc(initialValue: data.street);

    addFieldBlocs(fieldBlocs: [model, style, lat, lng, address]);

    addValidators();
  }

  void addValidators() {
    lat.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
    lng.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
  }

  void addErrors(Map<String, dynamic> errors) {
    if (errors == null) {
      return;
    }

    model.addFieldError(errors['lat']);
    model.addFieldError(errors['lng']);
    model.addFieldError(errors['address'] ?? errors['non_field_errors']);
  }

  @override
  void onSubmitting() {
    String id = RouteData.of(context).pathParams['id'].value;
    int userId = BlocProvider.of<AppBloc>(context).state.user.id;

    if (id != 'null') {
      RestService.instance
          .updateAddress(
              id,
              Address(
                  defAddr: false,
                  onMap: true,
                  model: model.value,
                  style: style.value,
                  lat: lat.valueToDouble,
                  lng: lng.valueToDouble,
                  address: address.value,
                  user_id: userId))
          .then((value) {
        emitSuccess(canSubmitAgain: true);
      }).catchError((onError) {
        emitFailure();
        addErrors(onError?.response?.data);
      });
    } else {
      RestService.instance
          .postAddress(Address(
              defAddr: false,
              onMap: true,
              model: model.value,
              style: style.value,
              lat: lat.valueToDouble,
              lng: lng.valueToDouble,
              address: address.value,
              user_id: userId))
          .then((value) {
        emitSuccess(canSubmitAgain: true);
      }).catchError((onError) {
        emitFailure();
        addErrors(onError?.response?.data);
      });
    }
  }
}
