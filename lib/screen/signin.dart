import 'package:flutter/material.dart';

import '../auth/auth_ui.dart';
import '../auth/auth_callback.dart';

import '../widgets.dart';

class SignInPage extends StatefulWidget {
  
  SignInPage(this.callback);

  final AuthCallback callback;

  @override
  State<SignInPage> createState() => new _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  
  @override
  Widget build(BuildContext context) => new LoginView(ProvidersTypes.phone, (_){
    return new Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: new TitleView()
    );
  }, callback: widget.callback);
}