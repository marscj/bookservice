import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'intl_helpers/localization_listener.dart';
import 'store/store.dart';
import 'storage/storage.dart';

import 'app.dart';
import 'firebase_user.dart';

// import 'package:google_places_picker/google_places_picker.dart';

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'BookService',
    options: new FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:921339622887:ios:cf0050bc04bbf988'
          : '1:921339622887:android:cf0050bc04bbf988',
      gcmSenderID: '921339622887',
      apiKey: Platform.isIOS
          ? 'AIzaSyBZQ-tkV2bHKzzzrAA6l8XFHLIAFiEu2EA'
          : 'AIzaSyCp49Ib7WJh3kUesaGZnsGt_ZYiguGtKx0',
      projectID: 'bookservice-dubai'
    ),
  );

  LocaleNotifier.init(locale: new Locale('en', 'US'));

  Store.instance.setting(app);
  Storage.instance.setting(app, storageBucket: 'gs://bookservice-dubai.appspot.com');

  await UserWithFirebase.instance.setting();

  // PluginGooglePlacePicker.initialize(
  //       androidApiKey: "AIzaSyAe973oefI_ehzypssdiw9abFgsIjuoAMQ",
  //       iosApiKey: "AIzaSyBaQJKfk6Bo1HfXjesedSAky6mr4wlXIeQ",
  // );
  
  runApp(new BookService());
}