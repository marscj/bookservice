import 'package:flutter/material.dart';
import '../widgets.dart';

class ResourcePage extends StatefulWidget {
  _ResourcePageState createState() => _ResourcePageState();
}

class _ResourcePageState extends State<ResourcePage> {

  final List<ListMenu> menus = [
    new ListMenu(
      value: 0,
      title: 'welcome resource',
      callback: () {}
    ),
    new ListMenu(
      value: 1,
      title: 'banner resource',
      callback: () {}
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: new AppBar(
      title: new Text('Resource'),
      elevation: elevation
    ),
    body: new ListView.separated(
      itemCount: 2,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (_, __){
        return new ListTile(
          title: new Text(menus[__].title),
          onTap: () => menus[__].callback(),
        );
      },
    ),
  );
}