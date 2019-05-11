import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/authlocalization.dart';
import '../utils.dart';

class TroubleSignIn extends StatefulWidget {
  final String email;

  TroubleSignIn(this.email, {Key key}) : super(key: key);

  @override
  _TroubleSignInState createState() => new _TroubleSignInState();
}

class _TroubleSignInState extends State<TroubleSignIn> {
  TextEditingController _controllerEmail;

  @override
  initState() {
    super.initState();
    _controllerEmail = new TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.email;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(AuthLocalizations.of(context).recoverPasswordTitle),
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
                    suffix: new Icon(Icons.mail)
                  ),
                ),
                new SizedBox(height: 16.0),
                new Container(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    AuthLocalizations.of(context).recoverHelpLabel,
                    style: Theme.of(context).textTheme.caption,
                  )
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
                onPressed: () => _send(context),
                child: new Text(AuthLocalizations.of(context).nextButtonLabel)),
          ],
        )
      ],
    );
  }

  _send(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: _controllerEmail.text);
    } catch (exception) {
      showErrorDialog(context, exception);
    }

    showErrorDialog(context,
        AuthLocalizations.of(context).recoverDialog(_controllerEmail.text));
  }
}
