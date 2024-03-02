import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracer_tracker/app/data/global/theme_controller.dart';
import 'package:tracer_tracker/app/data/services/push_notification_service.dart';
import 'package:tracer_tracker/app/routes/pages.dart';
import 'package:tracer_tracker/helpers/Utils/common_functions.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';
import 'package:tracer_tracker/helpers/schema/color_schema.dart';

import 'flavors.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  await pushNotificationService.init();
  pushNotificationService.showLocalNotification(
    notificationId: Random().nextInt(99999999),
    notificationTitle:
        message.data[PushNotificationService.NOTIFICATION_TITLE]?.toString() ??
            '',
    notificationContent:
        message.data[PushNotificationService.NOTIFICATION_BODY]?.toString() ??
            '',
    payload: message.data,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'admin@tracertracker.com', password: 'tracertracker@123');

  // HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  final PushNotificationService pushNotificationService =
      PushNotificationService();
  await pushNotificationService.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  if (F.appFlavor == Flavor.tracker) {
    await CommonFunctions.grantLocationPermission();
  } else {
    pushNotificationService.subscribeToNotificationTopics('tracker');
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (controller) => GetMaterialApp(
        fallbackLocale: const Locale('en'),
        locale: const Locale('en'),
        title: F.title,
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.initial,
        themeMode: storage.read(StorageConstants.isDarkMode) ?? false
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        getPages: AppPages().pages,
      ),
    );
  }
}

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: DarkTheme.background,
  bottomNavigationBarTheme:
      BottomNavigationBarThemeData(backgroundColor: DarkTheme.background),
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: LightTheme.white,
  useMaterial3: true,
  brightness: Brightness.light,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: LightTheme.white,
  ),
);
