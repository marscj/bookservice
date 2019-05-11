library intl_helpers;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_helper_localizations.dart';
export 'localization_listener.dart';

List<LocalizationsDelegate<dynamic>> createBasicLocalizationsDelegates({
  List<String> supportedLanguages,
  InitializeMessages initializeMessages,
  List<LocalizationsDelegate> delegate
  }) {
  
  var _delegates = [
    GlobalWidgetsLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
  ];

  _delegates.addAll(delegate);

  if (initializeMessages != null) {
    _delegates.add(
      AppHelperLocalizations.delegate(supportedLanguages, initializeMessages)
    );
  }

  return _delegates;
}
