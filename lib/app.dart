import 'package:flutter/material.dart';

import 'auth/l10n/authlocalization.dart';
import 'l10n/applocalization.dart';
import 'intl_helpers/intl_helpers.dart';
import 'intl_helpers/localization_listener.dart';
import 'router/routes.dart';

import 'caches.dart';

class BookService extends StatefulWidget {
  BookService();

  @override
  State<BookService> createState() => new _BookService();
}

class _BookService extends State<BookService> {
  @override
  void initState() {
    super.initState();

    LanguageCache.instance.getLanguage().then((onValue) {
      if (onValue != null) {
        LocaleNotifier.instance.update(new Locale(onValue[0], onValue[1]));
      }
    });

    LocaleNotifier.instance.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    LocaleNotifier.instance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Eletec',
      locale: LocaleNotifier.instance.locale,
      localizationsDelegates:
          createBasicLocalizationsDelegates(supportedLanguages: [
        'en',
        'ar'
      ], delegate: [
        AuthLocalizations.delegate,
        AppLocalizations.delegate,
      ]),
      supportedLocales: [
        new Locale('ar', 'AE'), // United Arab Emirates
        new Locale('en', 'US'), // English
      ],
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        iconTheme: new IconThemeData(color: Colors.blue[700]),
        accentIconTheme: new IconThemeData(color: Colors.white),
        buttonColor: Colors.blue[700],
        cardColor: Colors.white,
        textTheme: TextTheme(
          button: TextStyle(color: Colors.white),
        ),
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.lightBlue[50]),
        ),
        indicatorColor: Colors.white,
      ),
      onGenerateRoute: Routes.instance.generator,
    );
  }
}

// final ThemeData _kShrineTheme = _buildShrineTheme();

// ThemeData _buildShrineTheme() {
//   final ThemeData base = ThemeData.light();
//   return base.copyWith(
//     accentColor: Colors.white,
//     primaryColor: Colors.cyan,
//     buttonColor: Colors.cyan,
//     textSelectionColor: Colors.cyan,
//     toggleableActiveColor: Colors.cyan,
//     buttonTheme: ButtonThemeData(
//       textTheme: ButtonTextTheme.normal,
//       shape: new RoundedRectangleBorder(
//         borderRadius: new BorderRadius.circular(4.0),
//       ),
//     ),
//     primaryIconTheme: base.iconTheme.copyWith(color: Colors.white),
//     inputDecorationTheme: InputDecorationTheme(
//       border:
//         // new OutlineInputBorder()
//         new UnderlineInputBorder(borderSide: new BorderSide(width: 0.5))
//         //CutCornersBorder(cut: 1.0),
//     ),
//     textTheme: _buildShrineTextTheme(base.textTheme, Colors.yellow),
//     primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme, Colors.red),
//     accentTextTheme: _buildShrineTextTheme(base.accentTextTheme, Colors.pink),
//     iconTheme: _customIconTheme(base.iconTheme),
//   );
// }

// IconThemeData _customIconTheme(IconThemeData original) {
//   return original.copyWith(color: Colors.cyan[900]);
// }

// TextTheme _buildShrineTextTheme(TextTheme base, Color color) {
//   return base.copyWith(
//     headline: base.headline.copyWith(
//       fontWeight: FontWeight.w500,
//     ),
//     title: base.title.copyWith(
//         fontSize: 18.0
//     ),
//     caption: base.caption.copyWith(
//       fontWeight: FontWeight.w400,
//       fontSize: 14.0,
//     ),
//     body2: base.body2.copyWith(
//       fontWeight: FontWeight.w500,
//       fontSize: 16.0,
//     ),
//   ).apply(
//     fontFamily: 'Rubik',
//     displayColor: color,
//     bodyColor: color,
//   );
// }
