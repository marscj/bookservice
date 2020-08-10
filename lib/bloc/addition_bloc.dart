import 'dart:io';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';

// ignore_for_file: close_sinks
class AdditionBloc extends FormBloc<String, String> {
  TextFieldBloc tag = TextFieldBloc();
  InputFieldBloc<File, Object> image = InputFieldBloc<File, Object>();

  AdditionBloc() {
    addFieldBlocs(fieldBlocs: [tag, image]);
  }

  @override
  void onSubmitting() {}
}
