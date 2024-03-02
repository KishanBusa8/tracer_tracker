import UIKit
import Flutter
import flutter_local_notifications
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
                UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
              }
              FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
                  GeneratedPluginRegistrant.register(with: registry)
                }
    GMSServices.provideAPIKey("AIzaSyBfkYA5ss8W1YxGMtMVU6V__oj3PUXdB3o")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
