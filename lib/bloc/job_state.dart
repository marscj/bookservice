part of 'job_bloc.dart';

class JobState extends Equatable {
  final List<Job> list;

  const JobState({this.list});

  factory JobState.initial() => JobState(list: List<Job>());

  JobState copyWith({List<Job> list, bool isLoading}) =>
      JobState(list: list ?? this.list);

  @override
  List<Object> get props => [list];
}
