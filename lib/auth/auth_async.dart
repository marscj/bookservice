import 'dart:async';

import 'package:flutter/material.dart';

class _DialogAsync extends StatelessWidget {
  
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
                child: CircularProgressIndicator(),
              )
            ),
          ),
        ),
      ),
    );
  }
}

class _AsyncBuilder<T> extends StatefulWidget {
  const _AsyncBuilder({
    Key key,
    @required this.future,
  }) : super(key: key);
  
  final Future<T> future;

  @override
  State<_AsyncBuilder<T>> createState() => new _AsyncBuilderState<T>();
}

class _AsyncBuilderState<T> extends State<_AsyncBuilder<T>> {
  Object _activeCallbackIdentity;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  Widget build(BuildContext context) => new _DialogAsync();

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

Future<T>_showDialogAsync<T>({
  @required BuildContext context,
  @required Future<T> future,
  bool barrierDismissible: false
}) {
  return showDialog(context: context, barrierDismissible: barrierDismissible, builder: (_){
    return new _AsyncBuilder<T>(
      future: future,
    );
  }).then<T>((data){
    return data;
  });
}

Future<T> authAsync<T>({      
  @required BuildContext context,
  @required Future<T> future,
  bool barrierDismissible: false
}) {
  return _showDialogAsync(context: context, barrierDismissible: barrierDismissible, future: future);
}

