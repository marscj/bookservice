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
  AddressPostBloc() : super(AddressPostState.initial());

  @override
  Stream<AddressPostState> mapEventToState(AddressEvent event) async* {
    // if (event is AddressPost) {
    //   if (event.id == null) {
    //     yield await RestService.instance
    //         .postAddress(event.data)
    //         .then((value) => AddressPostState(data: value))
    //         .catchError((onError) {});
    //   } else {
    //     yield await RestService.instance
    //         .updateAddress(event.id, event.data)
    //         .then((value) => AddressPostState(data: value))
    //         .catchError((onError) {});
    //   }
    // }

    // if (event is AddressDelete) {
    //   yield await RestService.instance.deleteAddress(event.id).then((value) {
    //     return state;
    //   }).catchError((onError) {});
    // }

    if (event is AddressUpdate) {
      yield state.copyWith(data: event.data);
    }
  }
}

class AddressFormBloc extends FormBloc<String, String> {
  final BuildContext context;

  final SelectFieldBloc model = SelectFieldBloc(items: [0, 1], initialValue: 0);
  final SelectFieldBloc style = SelectFieldBloc(items: [0, 1], initialValue: 0);
  final TextFieldBloc city = TextFieldBloc();
  final TextFieldBloc community = TextFieldBloc();
  final TextFieldBloc street = TextFieldBloc();
  final TextFieldBloc building = TextFieldBloc();
  final TextFieldBloc roomNo = TextFieldBloc();

  AddressFormBloc(this.context) {
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

  final SelectFieldBloc model = SelectFieldBloc(items: [0, 1], initialValue: 0);
  final SelectFieldBloc style = SelectFieldBloc(items: [0, 1], initialValue: 0);
  final TextFieldBloc lat = TextFieldBloc();
  final TextFieldBloc lng = TextFieldBloc();
  final TextFieldBloc address = TextFieldBloc();

  AddressMapBloc(this.context) {
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
