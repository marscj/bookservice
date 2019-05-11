import 'package:flutter/material.dart';

typedef ItemBodyBuilder<T> = Widget Function(ExpansionItem<T> item);
typedef ValueToString<T> = String Function(T value);

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint({
    this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return new Container(
      padding: new  EdgeInsets.only(left: 12.0, top: 10.0, bottom: 10.0),
      alignment: Alignment.centerLeft,
      child: Text(
        name ?? '',
        style: textTheme.body1.copyWith(fontSize: 15.0),
      ),
    );
  }
}

class ExpansionItem<T> {
  ExpansionItem({
    this.name,
    this.builder,
  }) ;

  final String name;
  final ItemBodyBuilder<T> builder;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return DualHeaderWithHint(
        name: name,
      );
    };
  }

  Widget build() => builder(this);
}