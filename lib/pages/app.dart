import 'package:auto_route/auto_route.dart';
import 'package:country_code_picker/country_localizations.dart';
import 'package:bookservice/bloc/app_bloc.dart';
import 'package:bookservice/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;

import 'package:bookservice/I18n/i18n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EletecApp extends StatefulWidget {
  @override
  State<EletecApp> createState() => _EletecAppState();
}

class _EletecAppState extends State<EletecApp> {
  @override
  Widget build(BuildContext context) => BlocListener<AppBloc, AppState>(
      listener: (_, __) {},
      child: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
        return MaterialApp(
          title: 'Eletec',
          locale: state.locale,
          localizationsDelegates: const [
            location_picker.S.delegate,
            Localization.delegate,
            RefreshLocalizations.delegate,
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Localization.delegate.supportedLocales,
          builder: ExtendedNavigator.builder<Router>(
            router: Router(),
            builder: (context, child) => child,
          ),
          theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.blueAccent,
              scaffoldBackgroundColor: Colors.grey[200],
              buttonColor: Colors.blue,
              bottomAppBarColor: Colors.blue,
              buttonTheme: ButtonThemeData(
                  buttonColor: Colors.blue,
                  hoverColor: Colors.blueAccent,
                  textTheme: ButtonTextTheme.primary),
              appBarTheme: AppBarTheme(
                  elevation: 0,
                  color: Colors.grey[200],
                  iconTheme: IconThemeData(color: Colors.blue),
                  textTheme: GoogleFonts.righteousTextTheme(
                    Theme.of(context).textTheme.apply(
                        displayColor: Colors.blue, bodyColor: Colors.blue),
                  ),
                  brightness: Brightness.light),
              dividerColor: Colors.grey,
              // textTheme: GoogleFonts.righteousTextTheme(
              //   Theme.of(context).textTheme,
              // ),
              // fontFamily: GoogleFonts.getFont('Paprika').fontFamily,
              fontFamily: GoogleFonts.getFont('Righteous').fontFamily,
              highlightColor: Colors.blueAccent,
              hoverColor: Colors.blueAccent.withOpacity(0.04),
              splashColor: Colors.blueAccent),
        );
      }));
}
