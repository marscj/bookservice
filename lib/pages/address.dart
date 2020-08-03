import 'package:auto_route/auto_route.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return ExtendedNavigator(
      name: 'address',
      initialRoute: AddressPageRoutes.addressListPage,
    );
  }
}

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class AddressPostPage extends StatefulWidget {
  @override
  _AddressPostPageState createState() => _AddressPostPageState();
}

class _AddressPostPageState extends State<AddressPostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
