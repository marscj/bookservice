import 'package:bookservice/bloc/load_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadPage extends StatefulWidget {
  final WidgetBuilder builder;

  const LoadPage({Key key, @required this.builder}) : super(key: key);

  @override
  _LoadPageState createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoadBloc>(
      create: (context) => LoadBloc(),
      child: BlocBuilder<LoadBloc, LoadState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (state is CompleteState) {
            return widget.builder(context);
          }

          if (state is FailureState) {
            return Center(child: Text('Failure'));
          }

          return Container();
        },
      ),
    );
  }
}
