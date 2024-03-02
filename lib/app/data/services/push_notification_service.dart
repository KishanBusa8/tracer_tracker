import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';

@pragma('vm:entry-point')
notificationTapBackground(NotificationResponse notificationResponse) {
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  pushNotificationService.onNotificationTap(notificationResponse.payload ?? '');
}

class PushNotificationService {
  static const int NOTIFICATION_ID = 1234;
  static const String NOTIFICATION = 'notification';
  static const String NOTIFICATION_TITLE = 'title';
  static const String NOTIFICATION_BODY = 'body';

  static const String NOTIFICATION_CHANNEL_ID = '1234';
  static const String NOTIFICATION_CHANNEL_TITLE = 'tracerTracker';
  static const String NOTIFICATION_CHANNEL_DESC =
      'TracerTracker App Notification';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    requestNotificationAuthorization();
    _firebaseOnListenMethod();
  }

  void initializeLocalNotification() {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings();
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );
      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
          onNotificationTap(notificationResponse.payload ?? '');
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
    }
  }

  Future<void> onNotificationTap(String payload) async {
    if (kDebugMode) print('WARN: onNotificationTap is not implemented yet');
  }

  void _firebaseOnListenMethod() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(
        notificationId: Random().nextInt(99999999),
        notificationTitle: message
                .data[PushNotificationService.NOTIFICATION_TITLE]
                ?.toString() ??
            '',
        notificationContent: message
                .data[PushNotificationService.NOTIFICATION_BODY]
                ?.toString() ??
            '',
        payload: message.data,
      );
    });
  }

  void showLocalNotification({
    required int notificationId,
    required String notificationTitle,
    required String notificationContent,
    dynamic payload,
    String channelId = NOTIFICATION_CHANNEL_ID,
    String channelTitle = NOTIFICATION_CHANNEL_TITLE,
    String channelDescription = NOTIFICATION_CHANNEL_DESC,
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription: channelDescription,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentSound: false,
      presentAlert: true,
      presentBadge: true,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: jsonEncode(payload),
    );
  }

  Future<void> requestNotificationAuthorization() async {
    initializeLocalNotification();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    try {
      await FirebaseMessaging.instance.requestPermission();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> subscribeToNotificationTopics(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(
      topic,
    );
  }

  Future<void> unSubscribeToNotificationTopics(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(
      topic,
    );
  }

  Future<void> sendNotification({
    required String body,
    required String title,
    required String topic,
    required String screenName,
    required Map<String, dynamic> notificationData,
  }) async {
    const String firebaseSentNotificationUrl =
        'https://fcm.googleapis.com/fcm/send';
    final String toTopic = '/topics/$topic';

    final dynamic data = <String, Object>{
      'content_available': true,
      'priority': 'high',
      'data': <String, Object>{
        'body': body,
        'title': title,
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'status': 'done',
        'screen': screenName,
        'data': notificationData,
      },
      'to': toTopic
    };
    final Map<String, String> headers = <String, String>{
      'content-type': 'application/json',
      'Authorization': 'key=${StorageConstants.firebaseMessagingServerKey}'
    };
    await http
        .post(
          Uri.parse(firebaseSentNotificationUrl),
          body: json.encode(data),
          headers: headers,
        )
        .then((value) => print(value.body));
  }
}
