part of 'job_bloc.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object> get props => [];
}

class JobRefreshList extends JobEvent {
  JobRefreshList();

  @override
  List<Object> get props => [];
}
