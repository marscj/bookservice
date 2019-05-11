import 'package:flutter/material.dart';

class BackGroundView extends StatelessWidget {

  BackGroundView({
    Key key,
    @required this.body,
    this.background,
    this.opacity = 0.2,
    this.backgroundColor,
  }) ;

  final Widget body;
  final double opacity;
  final Widget background;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => new SafeArea(
    top: true,
    bottom: true,
    child: new Stack(
      children: <Widget>[
        new Opacity(
          opacity: opacity,
          child: new Container(
            color: backgroundColor,
            alignment: Alignment.bottomCenter,
            child: background ?? new Image.asset('assets/background.png'),
          )
        ),
        body, 
      ],
    ),
  );
}