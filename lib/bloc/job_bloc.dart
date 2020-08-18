import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bookservice/apis/client.dart';
import 'package:equatable/equatable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  RefreshController refreshController = RefreshController(initialRefresh: true);

  JobBloc() : super(JobState.initial());

  @override
  Stream<JobState> mapEventToState(
    JobEvent event,
  ) async* {
    if (event is JobRefreshList) {
      yield await RestService.instance
          .getJobs(query: {'sorter': '-id'}).then<JobState>((value) {
        refreshController.refreshCompleted();
        return state.copyWith(list: value ?? []);
      }).catchError((onError) {
        refreshController.refreshFailed();
        return state.copyWith(list: []);
      });
    }
  }
}
