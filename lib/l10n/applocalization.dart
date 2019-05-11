import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'localization.dart';

class AppLocalizations {
  TranslationBundle _translationBundle;

  AppLocalizations(Locale locale) {
    _translationBundle = translationBundleForLocale(locale);
  }

  static Future<AppLocalizations> load(Locale locale) {
    return new SynchronousFuture<AppLocalizations>(
        new AppLocalizations(locale));
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ?? new _DefaultAppLocalizations();
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      const _AppLocalizationsDelegate();

  String get helloWorld => _translationBundle.helloWorld;

  String get pending => _translationBundle.pending;

  String get completed => _translationBundle.completed;

  String get apartment => _translationBundle.apartment;

  String get villa => _translationBundle.villa;

  List<String> get bookingTabs => _translationBundle.bookingTabs;

  List<List<String>> get additionalFirst => _translationBundle.additionalFirst;

  List<List<List<String>>> get additionalSecond => _translationBundle.additionalSecond;

  List<List<String>> get additionalSecondIssue => _translationBundle.additionalSecondIssue;

  List<String> get clientCategories => _translationBundle.clientCategories;

  List<String> get workerCategories => _translationBundle.workerCategories;

  List<String> get operatorCategories => _translationBundle.operatorCategories;

  String get home => _translationBundle.home;

  String get eletec => _translationBundle.eletec;

  String get bookings => _translationBundle.bookings;

  String get settings => _translationBundle.settings;

  String get support => _translationBundle.support;

  String get signout => _translationBundle.signout;

  List<FAQ> get faqs => _translationBundle.faqs;

  List<String> get userTabs => _translationBundle.userTabs;

  List<String> get staffTabs => _translationBundle.staffTabs;

  List<String> get contractOptions => _translationBundle.contractOptions;

  String get camera => _translationBundle.camera;

  String get gallery => _translationBundle.gallery;

  String get addWhiteList => _translationBundle.addWhiteList;

  String get whiteList => _translationBundle.whiteList;

  String get save => _translationBundle.save;

  String get contract => _translationBundle.contract;

  String get options => _translationBundle.options;

  String get dateOfIssue => _translationBundle.dateOfIssue;

  String get dateOfExpiry => _translationBundle.dateOfExpiry;

  String get description => _translationBundle.description;

  String get userDetail => _translationBundle.userDetail;

  String get delete => _translationBundle.delete;

  String get sure => _translationBundle.sure;

  String get no => _translationBundle.no;

  String get yes => _translationBundle.yes;

  String get enable => _translationBundle.enable;

  String get disable => _translationBundle.disable;

  String get unknow => _translationBundle.unknow;

  String get none => _translationBundle.none;

  String get noData => _translationBundle.noData;

  String get users => _translationBundle.users;

  String get search => _translationBundle.search;

  String get userProfile => _translationBundle.userProfile;

  String get address => _translationBundle.address;

  String get freelancerProfile => _translationBundle.freelancerProfile;

  String get language => _translationBundle.language;

  String get skill => _translationBundle.skill;

  String get workTime => _translationBundle.workTime;

  String get from => _translationBundle.from;

  String get to => _translationBundle.to;

  String get userCategory => _translationBundle.userCategory;

  String get register => _translationBundle.register;

  String get areYou => _translationBundle.areYou;

  String get complete => _translationBundle.complete;

  String get book => _translationBundle.book;

  String get bookingDetail => _translationBundle.bookingDetail;

  String get sameday => _translationBundle.sameday;

  String get earliest => _translationBundle.earliest;

  String get scheduled => _translationBundle.scheduled;

  String get after24 => _translationBundle.after24;

  String get addNewAddr => _translationBundle.addNewAddr;

  String get defaultText => _translationBundle.defaultText;

  String get upload => _translationBundle.upload;

  String get faqsText => _translationBundle.faqsText;

  String get displayName => _translationBundle.displayName;
  
  String get phoneNumber => _translationBundle.phoneNumber;

  String get email => _translationBundle.email;

  String get permission => _translationBundle.permission;

  String get status => _translationBundle.status;

  String get admin => _translationBundle.admin;

  String get customerData => _translationBundle.customerData;

  String get companyData => _translationBundle.companyData;

  String get freelancerData => _translationBundle.freelancerData;

  String get country => _translationBundle.country;

  String get city => _translationBundle.city;

  String get community => _translationBundle.community;

  String get street => _translationBundle.street;

  String get villaNo => _translationBundle.villaNo;

  String get skills => _translationBundle.skills;

  String get times => _translationBundle.times;

  String get clickSave => _translationBundle.clickSave;

  String get bookingInformation => _translationBundle.bookingInformation;

  String get bookingInfo => _translationBundle.bookingInfo;

  String get createTime => _translationBundle.createTime;

  String get startTime => _translationBundle.startTime;

  String get endTime => _translationBundle.endTime;

  String get serviceCode => _translationBundle.serviceCode;

  String get additionalInfo => _translationBundle.additionalInfo;

  String get otherIns => _translationBundle.otherIns;

  String get userInfo => _translationBundle.userInfo;

  String get userName => _translationBundle.userName;

  String get userNumber => _translationBundle.userNumber;

  String get location => _translationBundle.location;

  String get staffName => _translationBundle.staffName;

  String get staffNumber => _translationBundle.staffNumber;

  String get evaluation => _translationBundle.evaluation;

  String get user => _translationBundle.user;

  String get staffInfo => _translationBundle.staffInfo;

  String get staff => _translationBundle.staff;

  String get clickDetail => _translationBundle.clickDetail;

  String get type => _translationBundle.type;

  String get map => _translationBundle.map;

  String get buildName => _translationBundle.buildName;

  String get officeNo => _translationBundle.officeNo;
  
  String get required => _translationBundle.required;

  String get timeError => _translationBundle.timeError;

  String get name => _translationBundle.name;

  String get operatorText => _translationBundle.operatorText;

  String get assistance => _translationBundle.assistance;

  String get selectDate => _translationBundle.selectDate;

  String get selectAddress => _translationBundle.selectAddress;

  String get cancel => _translationBundle.cancel;

  String get enterManually => _translationBundle.enterManually;

  String get sameDateError => _translationBundle.sameDateError;

  String get workFromTimeError => _translationBundle.workFromTimeError;

  String get workToTimeError => _translationBundle.workToTimeError;
}

class _DefaultAppLocalizations extends AppLocalizations {
  _DefaultAppLocalizations() : super(const Locale('en', 'US'));
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  static const List<String> _supportedLanguages = const <String>[
    'en', // English
    'ar', // French
  ];

  @override
  bool isSupported(Locale locale) =>
      _supportedLanguages.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
