import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/authlocalization.dart';
import 'sign_up_view.dart';
import 'password_view.dart';

class EmailView extends StatefulWidget {

  EmailView(this.header, {
    Key key,
  });

  final WidgetBuilder header;

  @override
  _EmailViewState createState() => new _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final TextEditingController _controllerEmail = new TextEditingController();

  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text(AuthLocalizations.of(context).welcome),
          elevation: 1.0,
        ),
        body: new Builder(
          builder: (BuildContext context) {
            return new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: new InputDecoration(
                      labelText: AuthLocalizations.of(context).emailLabel,
                      suffixIcon: const Icon(Icons.email)
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        persistentFooterButtons: <Widget>[
          new ButtonBar(
            alignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new FlatButton(
                  onPressed: () => _connexion(context),
                  child: new Text(AuthLocalizations.of(context).nextButtonLabel)),
            ],
          )
        ],
      );

  _connexion(BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      List<String> providers = await auth.fetchSignInMethodsForEmail(email: _controllerEmail.text);
      print(providers);

      if (providers == null || providers.isEmpty) {
        bool connected = await Navigator
            .of(context)
            .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
          return new SignUpView(_controllerEmail.text);
        }));

        if (connected) {
          Navigator.of(context).pop();
        }
      } else if (providers.contains('password')) {
        bool connected = await Navigator
            .of(context)
            .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
          return new PasswordView(widget.header, email:_controllerEmail.text);
        }));

        if (connected) {
          Navigator.of(context).pop();
        }
      }
    } catch (exception) {
      print(exception);
    }
  }
}
