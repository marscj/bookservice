import 'dart:async';
import 'package:flutter/material.dart';

enum Shape {
  circular,
  linear
}

class _CircularProgress extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: new MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: new Center(
          child: new ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 45.0),
            child: new Material(
              elevation: 1.0,
              color: Theme.of(context).scaffoldBackgroundColor,
              type: MaterialType.card,
              child: new Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator()
              )
            )
          )
        )
      )
    );
  }
}

class _LinearProgress extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets + const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
      duration: Duration(milliseconds: 100),
      curve: Curves.decelerate,
      child: new MediaQuery.removeViewInsets(
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        context: context,
        child: new Center(
          child: new Material(
            elevation: 1.0,
            color: Theme.of(context).scaffoldBackgroundColor,
            type: MaterialType.card,
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: new LinearProgressIndicator()
            )
          )
        )
      )
    );
  }
}

class AsyncBuilder<T> extends StatefulWidget {
  const AsyncBuilder({
    Key key,
    @required this.future,
    this.shape = Shape.circular
  }) : super(key: key);
  
  final Future<T> future;
  final Shape shape;

  @override
  State<AsyncBuilder<T>> createState() => new _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<AsyncBuilder<T>> {
  Object _activeCallbackIdentity;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  Widget build(BuildContext context) => widget.shape == Shape.circular ? _CircularProgress() : _LinearProgress();

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    if (widget.future != null) {
      final Object callbackIdentity = new Object();

      _activeCallbackIdentity = callbackIdentity;

      widget.future.then<T>((T data) {
        if (_activeCallbackIdentity == callbackIdentity) {
          if (mounted) {
            Navigator.of(context).pop(data);
          }
        }
      }).catchError((onError){
        print(onError);
        Navigator.of(context).pop(null);
      });
    }
  }

  void _unsubscribe() {
    _activeCallbackIdentity = null;
  }
}