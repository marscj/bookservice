import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../l10n/authlocalization.dart';
import '../auth_async.dart';
import '../auth_callback.dart';
import '../utils.dart';

class SignUpView extends StatefulWidget {
  
  SignUpView(this.email, {
    Key key,
    this.callback
  }) : super(key: key);

  final String email;
  final AuthCallback callback;

  @override
  _SignUpViewState createState() => new _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _controllerEmail;
  TextEditingController _controllerDisplayName;
  TextEditingController _controllerPassword;

  bool _valid = false;
  String errorText = '';

  setErrorText(value) => setState(() => errorText = value);

  @override
  initState() {
    super.initState();
    _controllerEmail = new TextEditingController(text: widget.email);
    _controllerDisplayName = new TextEditingController();
    _controllerPassword = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.email;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(AuthLocalizations.of(context).signUpTitle),
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
                const SizedBox(height: 20.0),
                new TextField(
                  controller: _controllerDisplayName,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onChanged: _checkValid,
                  decoration: new InputDecoration(
                    labelText: AuthLocalizations.of(context).nameLabel,
                    suffixIcon: const Icon(Icons.person)
                  ),
                ),
                const SizedBox(height: 20.0),
                new PasswordField(
                  controller: _controllerPassword,
                  border: UnderlineInputBorder(),
                  labelText: AuthLocalizations.of(context).passwordLabel,
                ),
                const SizedBox(height: 20.0),
                new Text(errorText, style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).errorColor), maxLines: 3)
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
                onPressed: _valid ? () => _connexion(context) : null,
                child: new Text(AuthLocalizations.of(context).nextButtonLabel)),
          ],
        )
      ],
    );
  }

  _connexion(BuildContext context) async {
    setErrorText('');
    await authAsync(
      context: context,
      future: FirebaseAuth.instance.createUserWithEmailAndPassword( 
        email: _controllerEmail.text,
        password: _controllerPassword.text
      ).then((user){
          var userUpdateInfo = new UserUpdateInfo();
          userUpdateInfo.displayName = _controllerDisplayName.text;
          
          return user.updateProfile(userUpdateInfo).then((_){
            return user;
          });
      }).catchError((onError){
        setErrorText(onError.details);
      }
    )).then((data) {
      if (data != null){
        widget.callback == null ?
          Navigator.of(context).pop()
          :
          widget.callback(context);
      }
    });
  }

  void _checkValid(String value) {
    setState(() {
      _valid = _controllerDisplayName.text.isNotEmpty;
    });
  }
}
