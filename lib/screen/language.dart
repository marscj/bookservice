import 'package:flutter/material.dart';

import '../intl_helpers/localization_listener.dart';
import '../cache/language_cache.dart';
import '../auth/auth_callback.dart';

import '../widgets.dart';
import '../l10n/applocalization.dart';

class LanguagePage extends StatefulWidget {

  LanguagePage({
    this.callback,
    this.canBack = false
  });
  
  final AuthCallback callback;
  final bool canBack;

  @override
  State<LanguagePage> createState() => new _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  
  @override
  void initState() {
    
    super.initState();

    LocaleNotifier.instance.addListener(() {
      if (mounted){
        setState(() {});
      }
    });
  }
  
  @override
  Widget build(BuildContext context) => widget.canBack ? new Scaffold(
    appBar: new AppBar(
      elevation: elevation,
      title: new Text(AppLocalizations.of(context).language),
    ),
    body: body,
  ) : new Scaffold(
    body: body,
  );

  Widget get body => new Center(
    child: new IButtonBar(
      axis: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new RaisedButton(
          onPressed: (){
            _toggleLocale('en'); 
          },
          child: new Container(
            width: 100.0,
            alignment: Alignment.center,
            child: new Text('English', style: TextStyle(color: Colors.white, fontSize: 16.0)),
          )
        ),
        new SizedBox(height: 20.0),
        new RaisedButton(
          onPressed: (){
            _toggleLocale('ar');
          },
          child: new Container(
            width: 100.0,
            alignment: Alignment.center,
            child: new Text('عربى', style: TextStyle(color: Colors.white, fontSize: 16.0)),
          )
        ),
      ],
    )
  );

  dynamic _toggleLocale(code) async {
    if (code == 'en') {
      LanguageCache.instance.setLanguage(['en', 'US']);
      LocaleNotifier.instance.update(new Locale('en', 'US'));
    } else {
      LanguageCache.instance.setLanguage(['ar', 'AE']);
      LocaleNotifier.instance.update(new Locale('ar', 'AE'));
    }

    widget.callback == null ?
      Navigator.of(context).pop()
      :
      widget.callback(context);
  }
}
