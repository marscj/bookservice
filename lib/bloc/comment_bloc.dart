import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookservice/I18n/i18n.dart';
import 'package:bookservice/apis/client.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  RefreshController refreshController = RefreshController(initialRefresh: true);

  CommentBloc() : super(CommentState.initial());

  @override
  Stream<CommentState> mapEventToState(
    CommentEvent event,
  ) async* {
    if (event is CommentRefreshList) {
      yield await RestService.instance.getImages(query: {
        'object_id': event.object_id,
        'content_type': event.content_type,
        'sorter': '-id'
      }).then<CommentState>((value) {
        refreshController.refreshCompleted();
        return state.copyWith(list: value ?? []);
      }).catchError((onError) {
        refreshController.refreshFailed();
        return state.copyWith(list: []);
      });
    }
  }
}

// ignore_for_file: close_sinks
// ignore_for_file: non_constant_identifier_names
class CommentFormBloc extends FormBloc<String, String> {
  TextFieldBloc comment = TextFieldBloc();
  TextFieldBloc rating = TextFieldBloc();

  final int object_id;
  final String content_type;
  final BuildContext context;

  CommentFormBloc(this.context, this.object_id, this.content_type) {
    addFieldBlocs(fieldBlocs: [comment, rating]);
    addValidators();
  }

  void addValidators() {
    comment.addValidators([
      RequiredValidator(errorText: Localization.of(context).requiredString)
    ]);
  }

  void addErrors(Map<String, dynamic> errors) {
    if (errors == null) {
      return;
    }

    rating.addFieldError(errors['rating']);
    comment.addFieldError(errors['comment'] ?? errors['non_field_errors']);
  }

  @override
  void onSubmitting() {
    RestService.instance.postComment({
      'object_id': object_id,
      'content_type': content_type,
      'comment': comment.value,
      'rating': rating.valueToInt
    }).then((value) {
      emitSuccess(canSubmitAgain: true);
    }).catchError((onError) {
      emitFailure();
      addErrors(onError?.response?.data);
    });
  }
}
