import 'package:firebase_messaging/firebase_messaging.dart';
import '../model/user_model.dart';

class Messaging {

  Messaging._();

  static Messaging _instance = new Messaging._();

  static Messaging get instance => _instance;

  FirebaseMessaging _messaging;

  void setting() {
    _messaging = new FirebaseMessaging();

    _messaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
    );

    _messaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void subscribeToTopic(UserModel user) {

    if (user == null){
      return;
    }

    if (user.category == null) { 
      return;
    }

    if (user.category != 4) {
      return;
    }

    _messaging.subscribeToTopic('new');
  }

  void unSubscribeToTopic() {
    _messaging.unsubscribeFromTopic('new');
  }

  void configure({
    MessageHandler onMessage,
    MessageHandler onLaunch,
    MessageHandler onResume,
  }) {
    return _messaging.configure(onMessage: onMessage, onLaunch: onLaunch, onResume: onResume);
  }
}