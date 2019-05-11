import UIKit
import Flutter
import GoogleMaps
import GooglePlaces

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GMSPlacesClient.provideAPIKey("AIzaSyBaQJKfk6Bo1HfXjesedSAky6mr4wlXIeQ")
    GMSServices.provideAPIKey("AIzaSyBaQJKfk6Bo1HfXjesedSAky6mr4wlXIeQ")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
