import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_country_picker/country.dart';

import '../l10n/authlocalization.dart';
import '../auth_async.dart';
import '../auth_callback.dart';
import 'phone_signin.dart';
import 'phone_verify.dart';
import '../../widgets.dart';

class PhoneView extends StatefulWidget {

  PhoneView(this.header, {
    Key key,
    this.callback,
  }) : super(key: key);
  
  final WidgetBuilder header;
  final AuthCallback callback;

  @override
  _PhoneViewState createState() => new _PhoneViewState();
}

class _PhoneViewState extends State<PhoneView> { 
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PageController _pageController;

  GlobalKey<PhoneVerifyViewState> _verifyKey = new GlobalKey<PhoneVerifyViewState>();
  GlobalKey<PhoneSignInViewState> _signinKey = new GlobalKey<PhoneSignInViewState>();

  MediaQueryData mediaQueryData(context) => MediaQuery.of(context);
  double statusBarHeight(context) => mediaQueryData(context).padding.top;
  double screenHeight(context) => mediaQueryData(context).size.height;
  double appBarMaxHeight(context) => screenHeight(context) - statusBarHeight(context);

  String verificationId;
  String errorText;
  String phoneNumber;
  Country country;
  int timeout = 60;

  int curPage = 0;

  setErrorText(value) => setState(() => errorText = value);

  @override
  initState() {
    super.initState();
    
    country = Country.findByIsoCode('AE');

    _pageController = new PageController(keepPage: true)..addListener((){
      setState(() => curPage = _pageController.page.round());
    });
  }

  @override 
  void dispose() {
    timeout = 0;
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new BackGroundView(
      body: buildBody,
    ),
    persistentFooterButtons: buildFooterButton
  );
  

  Widget get buildBody => new SafeArea(
    top: true,
    bottom: true,
    child: new Flex(
      direction: Axis.vertical,
      children: <Widget>[
        new SizedBox(height: statusBarHeight(context)),
        widget.header(context),
        new Flexible(
          child: buildPage
        )
      ],
    )
  );

  Widget get buildPage => new PageView(
    controller: _pageController,
    physics: new NeverScrollableScrollPhysics(),
    children: <Widget>[
      new PhoneVerifyView(
        key: _verifyKey, 
        errorText: errorText,
        country: country,
        phoneNumber: phoneNumber,
        onChange: (value) {
          setState(() {
            if (value is Country) {
              country = value;
            } 
          });

          if (value is String) {
            phoneNumber = value;
          } 
        },
      ),
      new PhoneSignInView(
        key: _signinKey, 
        errorText: errorText, 
        reSend: () {
          verifyPhoneNumber();
        }
      )
    ],
  );

  List<Widget> get buildFooterButton => <Widget>[
    new ButtonBar(
      alignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: curPage == 0 ? <Widget>[
        new FlatButton(
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            verifyPhoneNumber();
          },
          child: new Text(AuthLocalizations.of(context).nextButtonLabel),
        )
      ] : <Widget>[
        timeout > 0 ? new FlatButton(
          child: new Text('$timeout'),
          onPressed: null, 
        ) : new FlatButton(
          textColor: Theme.of(context).accentColor,
          onPressed: () {
            timeout = 0;
            setErrorText(null);
            _pageController.previousPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn);
          }, 
          child: new Text(AuthLocalizations.of(context).reSendLabel),
        ),
        new FlatButton(
          textColor: Theme.of(context).accentColor,
          onPressed: () => signInWithPhoneNumber(),
          child: new Text(AuthLocalizations.of(context).signInLabel),
        ),
      ]
    )
  ];

  printTimeOut() {
    if (timeout > 0) {
      new Timer(const Duration(seconds: 1), (){
        if (mounted) {
          setState((){
            timeout --;
          });
          printTimeOut();
        }
      });
    }
  }

  Future<void> verifyPhoneNumber() async {
    setErrorText(null);

    final PhoneVerificationCompleted verificationCompleted = (AuthCredential user) {
      if (user != null) {
        widget.callback == null ? 
          Navigator.of(context).pop()
          :
          widget.callback(context);
      }
    };

    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
      setErrorText(authException.message);
    };

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      curPage == 0 ? _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn) : print('$curPage');
      timeout = 60;
      printTimeOut();
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      this.verificationId = verificationId;
      curPage == 0 ? _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.fastOutSlowIn) : print('$curPage');
      timeout = 60;
      printTimeOut();
    };

    await _auth.verifyPhoneNumber(
      phoneNumber: _verifyKey.currentState.getInputNumber(),
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
    );
  }

  Future<FirebaseUser> signInWithPhoneNumberFun(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }

  Future<void> signInWithPhoneNumber() async {
    var smsCode = _signinKey.currentState.smsCodeController.text;
    setErrorText(null);

    await authAsync(
      context: context,
      future: signInWithPhoneNumberFun(smsCode).catchError((onError){
        setErrorText(onError.details);
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