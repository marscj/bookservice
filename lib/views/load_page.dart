import 'package:animate_do/animate_do.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit/flutter_cubit.dart';

abstract class LoadPageEvent extends Equatable {
  const LoadPageEvent();

  @override
  List<Object> get props => [];
}

class LoadingPage extends LoadPageEvent {}

class LoadPageComplete extends LoadPageEvent {
  final dynamic data;

  LoadPageComplete(this.data);

  @override
  List<Object> get props => [data];
}

abstract class LoadPageState extends Equatable {
  final dynamic data;

  LoadPageState(this.data);

  @override
  List<Object> get props => [data];
}

class LoadPageInitState extends LoadPageState {
  LoadPageInitState() : super(null);
}

class LoadingPageState extends LoadPageState {
  LoadingPageState() : super(null);
}

// class LoadingPagesState extends LoadPageState {
//   LoadingPagesState() : super(null);
// }

class LoadPageCompleteState extends LoadPageState {
  LoadPageCompleteState(data) : super(data);
}

class LoadPageBloc extends Bloc<LoadPageEvent, LoadPageState> {
  LoadPageBloc() : super(LoadPageInitState());

  @override
  Stream<LoadPageState> mapEventToState(LoadPageEvent event) async* {
    print(event);

    if (event is LoadPageComplete) {
      yield LoadPageCompleteState(event.data);
    } else {
      yield LoadingPageState();
    }
  }
}

class LoadPage extends StatefulWidget {
  final WidgetBuilder builder;
  final CubitListenerCondition listener;

  const LoadPage({Key key, @required this.builder, this.listener})
      : super(key: key);

  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoadPageBloc>(
      create: (context) => LoadPageBloc()..add(LoadingPage()),
      child: BlocListener<LoadPageBloc, LoadPageState>(
          listener: (context, state) => widget.listener,
          child: BlocBuilder<LoadPageBloc, LoadPageState>(
              builder: (context, state) {
            if (state is LoadPageCompleteState) {
              return FadeIn(child: widget.builder(context));
            }
            return Center();
          })),
    );
  }
}
