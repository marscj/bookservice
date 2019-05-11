import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({ 
    Key key,
    this.size,
   }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Icon(Icons.email, size:size)
      // new Container(
      //   alignment: Alignment.center,
      //   width: size,
      //   height: size,
      //   child: new Image(
      //     image: new AssetImage('assets/logo.png'),
      //     color: Theme.of(context).scaffoldBackgroundColor,
      //     colorBlendMode: BlendMode.dstIn,
      //   ),
      // )
      // new Container(
      //   width: size,
      //   height: size,
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage(
      //         'assets/logo.png',
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}