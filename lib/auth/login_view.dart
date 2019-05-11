import 'package:flutter/material.dart';

import 'auth_email/password_view.dart';
import 'auth_phone/phone_view.dart';
import 'auth_callback.dart';
import 'utils.dart';

class LoginView extends StatefulWidget {
  
  LoginView(this.provider, this.header, {
    Key key,
    this.callback
  }) : super(key: key);

  final ProvidersTypes provider;
  final WidgetBuilder header;
  final AuthCallback callback;
  
  @override
  _LoginViewState createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  @override
  Widget build(BuildContext context) {
    switch (widget.provider) {
      case ProvidersTypes.email:
        return new PasswordView(widget.header, callback: widget.callback);
      case ProvidersTypes.phone:
      default:
        return new PhoneView(widget.header, callback: widget.callback);
    }
  }
}
