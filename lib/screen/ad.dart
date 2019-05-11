import 'dart:async';
import 'package:flutter/material.dart';

import '../intl_helpers/localization_listener.dart';
import '../auth/auth_callback.dart';
import '../router/routes.dart';
import '../router/handlers.dart';
import '../caches.dart';

class AdPage extends StatefulWidget {

  AdPage(this.callback);

  final AuthCallback callback;

  @override
  State<AdPage> createState() => _AdPage();
}

class _AdPage extends State<AdPage> {

  Duration _duration;
  Timer _timer;
  DateTime _cureTime;

  @override
  void initState() {
    
    super.initState();
    
    LocaleNotifier.instance.addListener(() {
      if (mounted){
        setState(() {});
      }
    });

    _duration = new Duration(seconds: 1);
    _cureTime = DateTime.now();
    _next();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new FutureBuilder(
      future: LanguageCache.instance.getLanguage().then((onValue){
        if (onValue == null) {
          return ['en', 'US'];
        }
        return onValue;
      }),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return new SafeArea(
            top: true,
            bottom: false,
            left: false,
            right: false,
            child: new SizedBox.expand(
              child: snapshot.data[0] == 'en' ? new Image.asset('assets/english.jpg', fit: BoxFit.fill) : new Image.asset('assets/arabic.jpg', fit: BoxFit.fitHeight)
            )
          );  
        }
        return new Container();
      },
    )
  );

  _next(){
    if(!mounted) {
      return;
    }

    _cancel();

    if (DateTime.now().millisecondsSinceEpoch - _cureTime.millisecondsSinceEpoch > 3000) {
      _goNext();
    }

    _timer = new Timer(_duration, () {
      _next();
    });
  }

  void _cancel({bool manual = false}) {
    _timer?.cancel();
  }

  _goNext() {
    LanguageCache.instance.getLanguage().then((code){
      if (code != null) {
        LocaleNotifier.instance.update(new Locale(code[0], code[1]));
        widget.callback(context);
      } else {
        Routes.instance.navigateTo(context, Routes.instance.language, replace: true, transition: TransitionType.inFromRight, object: {'callback': callback, 'canBack': false});
      }
    });
  }
}