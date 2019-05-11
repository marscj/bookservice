import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './l10n/authlocalization.dart';
import './auth_email/emailverify_view.dart';
import './auth_callback.dart';
import './auth_async.dart';
import './utils.dart';
import '../firebase_user.dart';

class ProfileView extends StatefulWidget {

  ProfileView({
    Key key,
    this.callback,
    this.sigout,
    this.storage
  }) : super(key: key);

  final AuthCallback callback;
  final VoidCallback sigout;
  final DocumentReference storage;

  @override
  State<ProfileView> createState() => new _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  
  FirebaseUser _currentUser;

  TextEditingController _controllerPhone;
  TextEditingController _controllerEmail;
  TextEditingController _controllerDisplayName;

  bool _validName = false;
  bool _validEmail = false;
  String errorText = '';

  setErrorText(value) => setState(() => errorText = value);

  @override
  void initState() {
    
    super.initState();  

    _controllerPhone = new TextEditingController();
    _controllerDisplayName = new TextEditingController();
    _controllerEmail = new TextEditingController();

    getCurrentUser();
  }

  getCurrentUser() async {
    _currentUser = await FirebaseAuth.instance.currentUser();

    if (mounted) {
      setState(() {
        _controllerPhone.text = _currentUser?.phoneNumber;
        _controllerDisplayName.text = _currentUser?.displayName;
        _controllerEmail.text = _currentUser?.email;

        _checkValidName(_currentUser?.displayName);
        _checkValidEmail(_currentUser?.email);
      });
    }
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: appBar,
    body: body,
    persistentFooterButtons: persistentFooterButtons,
  );

  AppBar get appBar => new AppBar(
    elevation: 1.0,
    title: new Text(AuthLocalizations.of(context).userProfileTitle)
  );

  List<Widget> get persistentFooterButtons => [
    new ButtonBar(
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.sigout != null ? new FlatButton(
          onPressed: () => _signOut(),
          child: new Text(AuthLocalizations.of(context).signOutLabel)
        ): new LimitedBox(),
        new FlatButton(
          onPressed: _validEmail && _validName && (_controllerEmail.text != _currentUser?.email || _controllerDisplayName.text != _currentUser?.displayName) ? () => _save(context) : null,
          child: new Text(AuthLocalizations.of(context).saveLabel),
        ),
      ],
    )
  ];

  Widget get body => new Padding(
    padding: EdgeInsets.all(16.0),
    child: new ListView(
      children: <Widget>[
        new TextField(
          controller: _controllerPhone,
          keyboardType: TextInputType.phone,
          autocorrect: false,
          enabled: false,
          decoration: new InputDecoration(
            labelText: AuthLocalizations.of(context).phoneNumberLabel,
            suffixIcon: const Icon(Icons.phone)
          ),
        ),
        const SizedBox(height: 20.0),
        new TextField(
          controller: _controllerDisplayName,
          keyboardType: TextInputType.text,
          autocorrect: false,
          enabled: _currentUser != null,
          onChanged: _checkValidName,
          maxLength: 32,
          decoration: new InputDecoration(
            labelText: AuthLocalizations.of(context).nameLabel,
            suffixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 20.0),
        new TextField(
          controller: _controllerEmail,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          enabled: _currentUser != null,
          onChanged: _checkValidEmail,
          decoration: new InputDecoration(
            labelText: AuthLocalizations.of(context).emailLabel,
            suffixIcon: new Visibility(
              visible: _currentUser != null && _currentUser?.email != null,
              child: _currentUser?.isEmailVerified != null ? !_currentUser.isEmailVerified ? new FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _goVerify();
                },
                child: new Text(AuthLocalizations.of(context).verifyInLabel),
              ) : new Icon(Icons.email) : new Icon(Icons.email)
            )
          ),
        ),
        const SizedBox(height: 20.0),
        new Text(errorText, style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).errorColor), maxLines: 3)
      ],
    ),
  );

  _save(BuildContext context) async {
    setErrorText('');
    var userUpdateInfo = new UserUpdateInfo();

    userUpdateInfo.displayName = _controllerDisplayName.text;
    
    await authAsync<FirebaseUser>(
      context: context,
      future: Future.wait([
        _currentUser?.updateProfile(userUpdateInfo),
        _currentUser?.updateEmail(_controllerEmail.text),
      ]).then((list){
        return _currentUser.reload().then((_){
          return FirebaseAuth.instance.currentUser();
        });
      }).catchError((onError){
        setErrorText(onError.details);
      })
    ).then((user){
      if (user != null) {
        if (user.email != null && !user.isEmailVerified) {
          return showEmailVerifyDialog(context).then((value){
            if (value) {
              _goVerify();
            } else {
              _skip(user);
            }
          });
        } else {
          _skip(user);
        }
      }
    });
  }

  _pushData(FirebaseUser user) async {
    return authAsync(
      context: context,
      future: widget.storage.setData({'profile': {'userId': user.uid ,'displayName': user.displayName, 'phoneNumber': user.phoneNumber,'email': user.email, 'isEmailVerified': user.isEmailVerified}}, merge: true).then((onValue){
        return 'success';
      })
    ).then((onValue){
      if (onValue != null && onValue == 'success') {
        _back(user);
      }
    });
  }

  _back(user) {
    UserWithFirebase.instance.reload(user);
    if (widget.callback != null) {  
      widget.callback(context);
    } else {
      setState(() {
        _currentUser = user;
      });
    }
  }

  _skip(user) async {
    if (widget.storage != null) {
      _pushData(user);
    } else {
      _back(user);
    }
  }

  _goVerify() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EmailVerifyView(callback: widget.callback, storage: widget.storage))).then((onValue){
      if (onValue != null && onValue['user'] != null) {
        setState(() {
          _currentUser = onValue['user'];
        });
      }
    });
  }

  _signOut() async{
    widget.sigout();
  }

  void _checkValidName(String value) {
    setState(() {
      _validName = _controllerDisplayName.text.isNotEmpty;
    });
  }

  void _checkValidEmail(String value) {
    setState(() {
      _validEmail = _controllerEmail.text.isNotEmpty;
    });
  }
}

