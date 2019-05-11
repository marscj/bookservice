import 'package:flutter/material.dart';

class TitleView extends StatelessWidget {
  
  TitleView({
    this.size = const Size(270.0, 80.0)
  });
  
  final Size size;

  @override
  Widget build(BuildContext context) => new SizedBox.fromSize(
    size: size,
    child: new Image.asset('assets/title.png',
     fit: BoxFit.fill
    ),
  );

}