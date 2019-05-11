import 'dart:async';
import 'package:flutter/material.dart';

import 'async_builder.dart';

Future<T>_showDialogAsync<T>({
  @required BuildContext context,
  @required Future<T> future,
  Shape shape = Shape.circular,
  bool barrierDismissible: false
}) {
  return showDialog(context: context, barrierDismissible: barrierDismissible, builder: (_){
    return new AsyncBuilder<T>(
      future: future,
      shape: shape,
    );
  }).then<T>((data){
    return data;
  });
}

Future<T> asyncDialog<T>({      
  @required BuildContext context,
  @required Future<T> future,
  Shape shape = Shape.circular,
  bool barrierDismissible: false
}) {
  return _showDialogAsync(context: context, barrierDismissible: barrierDismissible, future: future);
}