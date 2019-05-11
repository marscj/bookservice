import 'package:flutter/material.dart';

class IButtonBar extends StatelessWidget {
  
  const IButtonBar({
    Key key,
    this.axis = Axis.horizontal,
    this.alignment = MainAxisAlignment.end,
    this.mainAxisSize = MainAxisSize.max,
    this.children = const <Widget>[],
  }) : super(key: key);

  final MainAxisAlignment alignment;

  final MainAxisSize mainAxisSize;

  final List<Widget> children;

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final double paddingUnit = ButtonTheme.of(context).padding.horizontal / 4.0;
    return new Padding(
      padding: new EdgeInsets.symmetric(
        vertical: 2.0 * paddingUnit,
        horizontal: paddingUnit
      ),
      child: new Flex(
        direction: axis,
        mainAxisAlignment: alignment,
        mainAxisSize: mainAxisSize,
        children: children.map<Widget>((Widget child) {
          return new Padding(
            padding: new EdgeInsets.symmetric(horizontal: paddingUnit),
            child: child
          );
        }).toList()
      )
    );
  }
}
