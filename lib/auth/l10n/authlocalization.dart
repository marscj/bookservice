import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'localization.dart';

class AuthLocalizations {
  TranslationBundle _translationBundle;

  AuthLocalizations(Locale locale) {
    _translationBundle = translationBundleForLocale(locale);
  }

  String get welcome => _translationBundle.welcome;

  String get emailLabel => _translationBundle.emailLabel;

  String get nextButtonLabel => _translationBundle.nextButtonLabel;

  String get cancelButtonLabel => _translationBundle.cancelButtonLabel;

  String get passwordLabel => _translationBundle.passwordLabel;

  String get forgotPassword => _translationBundle.forgotPassword;

  String get signInLabel => _translationBundle.signInLabel;

  String get signInTitle => _translationBundle.signInTitle;

  String get signOutLabel => _translationBundle.signOutLabel;

  String get signOutTitle => _translationBundle.signOutTitle;

  String get signUpTitle => _translationBundle.signUpTitle;

  String get verifyInLabel => _translationBundle.verifyInLabel;

  String get nextLabel => _translationBundle.nextLabel;

  String get previousLabel => _translationBundle.previousLabel;

  String get recoverPasswordTitle => _translationBundle.recoverPasswordTitle;

  String get recoverHelpLabel => _translationBundle.recoverHelpLabel;

  String get sendButtonLabel => _translationBundle.sendButtonLabel;

  String get nameLabel => _translationBundle.nameLabel;

  String get saveLabel => _translationBundle.saveLabel;

  String get errorOccurred => _translationBundle.errorOccurred;

  String recoverDialog(String email) => _translationBundle.recoverDialog(email);

  String get phoneNumberLabel => _translationBundle.phoneNumberLabel;

  String get smsCodeLabel => _translationBundle.smsCodeLabel;

  String get reSendLabel => _translationBundle.reSendLabel;

  String get userProfileTitle => _translationBundle.userProfileTitle;

  String get skipLabel => _translationBundle.skipLabel;

  String get verifyedInLabel => _translationBundle.verifyedInLabel;

  String get unverifyedInLabel => _translationBundle.unverifyedInLabel;

  String get verifyEmailTitle => _translationBundle.verifyEmailTitle;

  String get completeLabel => _translationBundle.completeLabel;

  String get verifyEmailErrorText => _translationBundle.verifyEmailErrorText;

  String get clickEmailLinkText => _translationBundle.clickEmailLinkText;

  String get sendVerifyEmailLinkText => _translationBundle.sendVerifyEmailLinkText;

  String get verificationEmailTitle => _translationBundle.verificationEmailTitle;

  static Future<AuthLocalizations> load(Locale locale) {
    return new SynchronousFuture<AuthLocalizations>(
        new AuthLocalizations(locale));
  }

  static AuthLocalizations of(BuildContext context) {
    return Localizations.of<AuthLocalizations>(context, AuthLocalizations) ??
        new _DefaultFFULocalizations();
  }

  static const LocalizationsDelegate<AuthLocalizations> delegate =
      const _FFULocalizationsDelegate();
}

class _DefaultFFULocalizations extends AuthLocalizations {
  _DefaultFFULocalizations() : super(const Locale('en', 'US'));
}

class _FFULocalizationsDelegate
    extends LocalizationsDelegate<AuthLocalizations> {
  const _FFULocalizationsDelegate();

  static const List<String> _supportedLanguages = const <String>[
    'en', // English
    'fr', // French
  ];

  @override
  bool isSupported(Locale locale) =>
      _supportedLanguages.contains(locale.languageCode);

  @override
  Future<AuthLocalizations> load(Locale locale) => AuthLocalizations.load(locale);

  @override
  bool shouldReload(_FFULocalizationsDelegate old) => false;
}
