import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../l10n/authlocalization.dart';
import '../auth_callback.dart';
import '../utils.dart';
import '../auth_async.dart';
import '../firebase_user.dart';

class EmailVerifyView extends StatefulWidget {

  EmailVerifyView({
    this.callback,
    this.storage
  });

  final AuthCallback callback;
  final DocumentReference storage;
  
  @override
  State<EmailVerifyView> createState() => new _EmailVerifyViewState();
}

class _EmailVerifyViewState extends State<EmailVerifyView> {

  FirebaseUser _currentUser;

  int step = 0;

  setStep(value) => setState(() => step = value);

  @override
  void initState() {
    
    super.initState();

    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (mounted){
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    appBar: appBar,
    body: body,
    persistentFooterButtons: persistentFooterButtons,
  );

  AppBar get appBar => new AppBar(
    elevation: 1.0,
    title: new Text(AuthLocalizations.of(context).verificationEmailTitle),
  );

  List<Widget> get persistentFooterButtons => [
    new FlatButton(
      onPressed: () => _skip(_currentUser),
      child: new Text(AuthLocalizations.of(context).skipLabel),
    ),
    new FlatButton(
      onPressed: () => setStep(1),
      child: new Text(AuthLocalizations.of(context).verifyInLabel),
    ),
  ];

  Widget get body => new Padding(
    padding: EdgeInsets.all(16.0),
    child: new Center( 
      child: step == 0 ? new FutureBuilder<void>(
        future: sendVerify(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new Stack(
                children: <Widget>[
                  new Text(AuthLocalizations.of(context).sendVerifyEmailLinkText, style: Theme.of(context).textTheme.title),
                  new Center(child: new LinearProgressIndicator()) 
                ],
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).errorColor), maxLines: 3);
              } else {
                return new Text(AuthLocalizations.of(context).clickEmailLinkText, style: Theme.of(context).textTheme.title);
              }
          }
          return null; // unreachable
        }
      ) : new FutureBuilder<FirebaseUser>(
        future: reload(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return new Stack(
                children: <Widget>[
                  new Center(child: new LinearProgressIndicator()) 
                ],
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return new Text('Error: ${snapshot.error}', style: Theme.of(context).textTheme.caption.copyWith(color: Theme.of(context).errorColor), maxLines: 3);
              } else {
                if (snapshot.data != null){
                  return new Text(AuthLocalizations.of(context).welcome, style: Theme.of(context).textTheme.title);
                } else {
                  return new SizedBox();
                }
              }
          }
          return null; 
        }
      )
    ), 
  );
 
  Future<void> sendVerify() async {   
    return FirebaseAuth.instance.setLanguageCode(Intl.defaultLocale).then((_){
      return _currentUser?.sendEmailVerification();
    });
  } 

  Future<FirebaseUser> reload() async {   
    return _currentUser?.reload()?.then((_){
      return FirebaseAuth.instance.currentUser().then((user){
        if (!user.isEmailVerified) {
          return showVerifyErrorDialog(context).then((onValue){
            if (onValue) {
              setStep(0);
              return null;
            } else {
              return null;
            }
          });
        } else {
          _skip(user);
          return user;
        }
      });
    });
  }

  _pushData(user) async {
    return authAsync(
      context: context,
      future: widget.storage.setData({'profile': {'displayName': user.displayName, 'email': user.email, 'isEmailVerified': user.isEmailVerified}}, merge: true).then((onValue){
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
    widget.callback == null ?
      Navigator.of(context).pop()
      :
      widget.callback(context);
  }

  _skip(user) async {
    if (widget.storage != null) {
      _pushData(user);
    } else {
      _back(user);
    }
  }
}