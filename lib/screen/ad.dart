import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../intl_helpers/localization_listener.dart';
import '../auth/auth_callback.dart';
import '../router/routes.dart';
import '../router/handlers.dart';
import '../caches.dart';
import '../store/store.dart';

class DefaultScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) => new Stack(
    children: <Widget>[
      new Container(
        color: Colors.white,
      ),
      new Container(
        padding: new EdgeInsets.all(20.0),
        alignment: Alignment.bottomCenter,
        child: new Image.asset('assets/title.png'),
      )
    ],
  );
}

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

  Future<QuerySnapshot> _future;

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

    _future = Store.instance.sourceRef.where('use', isEqualTo: 1).getDocuments();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new FutureBuilder(
      // future: LanguageCache.instance.getLanguage().then((onValue){
      //   if (onValue == null) {
      //     return ['en', 'US'];
      //   }
      //   return onValue;
      // }),
      future: _future,
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return  new Center(
          child: new DefaultScreen(),
        );

        if (snapshot.data.documents != null && snapshot.data.documents.isNotEmpty) {
          return new SafeArea(
            top: true,
            bottom: false,
            left: false,
            right: false,
            child: new SizedBox.expand(
              // child: snapshot.data[0] == 'en' ? new Image.asset('assets/english.jpg', fit: BoxFit.fill) : new Image.asset('assets/arabic.jpg', fit: BoxFit.fitHeight)
              child: new CachedNetworkImage(
                imageUrl: snapshot.data.documents.last.data['url'],
              ),
            )
          );  
        }
        
        return  new Center(
          child: new Image.asset('assets/ad.jpg', fit: BoxFit.fitHeight),
        );
      },
    )
  );

  _next(){
    if(!mounted) {
      return;
    }

    _cancel();

    if (DateTime.now().millisecondsSinceEpoch - _cureTime.millisecondsSinceEpoch > 5000) {
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