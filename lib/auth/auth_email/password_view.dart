import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/authlocalization.dart';
import '../auth_async.dart';
import '../auth_callback.dart';
import '../utils.dart';
import 'trouble_signin.dart';
import 'email_view.dart';


class PasswordView extends StatefulWidget {

  PasswordView( this.header, {
    Key key,
    this.email,
    this.callback
  }) : super(key: key);

  final String email;
  final WidgetBuilder header;
  final AuthCallback callback;

  @override
  _PasswordViewState createState() => new _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;

  MediaQueryData mediaQueryData(context) => MediaQuery.of(context);
  double statusBarHeight(context) => mediaQueryData(context).padding.top;
  double screenHeight(context) => mediaQueryData(context).size.height;
  double appBarMaxHeight(context) => screenHeight(context) - statusBarHeight(context);

  @override
  initState() {
    super.initState();
    _controllerEmail = new TextEditingController(text: widget.email);
    _controllerPassword = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    body: buildBody,
    persistentFooterButtons: buildFooterButton,
  );

  List<Widget> get buildFooterButton => <Widget>[
    new ButtonBar(
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new FlatButton(
          onPressed: () => _connexion(context),
          child: new Text(AuthLocalizations.of(context).signInLabel),
        ),
      ],
    )
  ];

  Widget get buildBody => new Flex(
    direction: Axis.vertical,
    children: <Widget>[
      new SizedBox(height: statusBarHeight(context)),
      widget.header(context),
      new Flexible(
        child: buildPage
      )
    ],
  );

  Widget get buildPage => new Padding(
    padding: const EdgeInsets.all(16.0),
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new TextField(
          controller: _controllerEmail,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: new InputDecoration(
            border: OutlineInputBorder(),
            suffixIcon: const Icon(Icons.email))
        ),
        const SizedBox(height: 20.0),
        new PasswordField(
          controller: _controllerPassword,
          border: OutlineInputBorder(),
        ),
        new SizedBox(height: 10.0),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new InkWell(
              child: new Text(
                AuthLocalizations.of(context).forgotPassword,
                style: Theme.of(context).textTheme.caption),
              onTap: _handleLostPassword),
            new InkWell(
              child: new Text(
                AuthLocalizations.of(context).signUpTitle + ' ?',
                style: Theme.of(context).textTheme.caption),
              onTap: _handleSignUp)
          ]
        ),
      ],
    ),
  );

  _handleLostPassword() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new TroubleSignIn(_controllerEmail.text);
    }));
  }

  _handleSignUp() {
    Navigator.of(context).push(new MaterialPageRoute<Null>(builder: (BuildContext context) {
      return new EmailView(widget.header);
    }));
  }

  _connexion(BuildContext context) async {

    await authAsync(
      context: context,
      future: FirebaseAuth.instance.signInWithEmailAndPassword( 
        email: _controllerEmail.text, password: _controllerPassword.text
      ).catchError((onError){
        showErrorDialog(context, onError.details);
      })
    ).then((user){
      if (user != null) {
        widget.callback == null ?
          Navigator.of(context).pop()
          :
          widget.callback(context);
      }
    });
  }
}