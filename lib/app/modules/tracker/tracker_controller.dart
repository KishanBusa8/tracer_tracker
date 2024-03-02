import 'dart:io';

import 'package:background_location_tracker/background_location_tracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracer_tracker/app/data/services/push_notification_service.dart';
import 'package:tracer_tracker/helpers/Utils/common_functions.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';

@pragma('vm:entry-point')
void backgroundCallback() {
  BackgroundLocationTrackerManager.handleBackgroundUpdated(
    (data) async => Repo().update(data),
  );
}

class TrackerController extends GetxController {
  RxBool isOnline = false.obs;
  late GoogleMapController googleMapController;
  final PushNotificationService _pushNotificationService =
      PushNotificationService();

  @override
  void onInit() async {
    isOnline.value = GetStorage().read(StorageConstants.liveTracking) ?? false;
    initialize();
    super.onInit();
  }

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      await BackgroundLocationTrackerManager.initialize(
        backgroundCallback,
        config: const BackgroundLocationTrackerConfig(
          loggingEnabled: true,
          androidConfig: AndroidConfig(
            notificationIcon: 'ic_launcher',
            trackingInterval: Duration(seconds: 10),
            distanceFilterMeters: null,
            enableCancelTrackingAction: false,
          ),
        ),
      );
      if (isOnline.value) {
        startLocationTracking();
      }
    } else {
      bg.BackgroundGeolocation.requestPermission();
      bg.BackgroundGeolocation.onLocation(_onLocation);
      bg.BackgroundGeolocation.onMotionChange(_onMotionChange);
      bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 100.0,
        stopOnTerminate: false,
        locationAuthorizationRequest: 'Always',
        startOnBoot: true,
        activityRecognitionInterval: 30000,
        debug: false,
        logLevel: bg.Config.LOG_LEVEL_OFF,
        reset: true,
        backgroundPermissionRationale: bg.PermissionRationale(
            title:
                "Allow Despatchy to access this device's location even when the app is closed or not in use.",
            message:
                "This app collects location data to enable recording your trips to work and calculate distance-travelled.",
            positiveAction: 'Okay',
            negativeAction: 'Cancel'),
      )).then((bg.State state) {
        if (isOnline.value) {
          startLocationTracking();
        }
      });
    }
  }

  Future<void> toggleOnlineOffline() async {
    isOnline.value = !isOnline.value;
    if (isOnline.value) {
      startLocationTracking();
      _pushNotificationService.sendNotification(
          body: 'Tracker is now online!',
          title: 'Online',
          topic: 'tracker',
          screenName: '',
          notificationData: {});
    } else {
      stopLocationTracking();
      _pushNotificationService.sendNotification(
          body: 'Tracker has gone offline now!',
          title: 'Offline',
          topic: 'tracker',
          screenName: '',
          notificationData: {});
    }
  }

  startLocationTracking() async {
    GetStorage().write(StorageConstants.liveTracking, true);
    isOnline.value = true;
    if (Platform.isIOS) {
      bg.BackgroundGeolocation.start();
    } else {
      if (Platform.isAndroid) {
        if (!await BackgroundLocationTrackerManager.isTracking()) {
          await BackgroundLocationTrackerManager.startTracking();
        }
      }
    }
  }

  stopLocationTracking() async {
    GetStorage().write(StorageConstants.liveTracking, false);
    isOnline.value = false;
    if (Platform.isIOS) {
      bg.BackgroundGeolocation.stop();
    } else {
      if (Platform.isAndroid) {
        await BackgroundLocationTrackerManager.stopTracking();
      }
    }
  }

  void _onLocation(bg.Location location) {
    Position position = Position(
      longitude: location.coords.longitude,
      latitude: location.coords.latitude,
      timestamp: Timestamp.now().toDate(),
      accuracy: location.coords.accuracy,
      altitude: location.coords.altitude,
      heading: location.coords.heading,
      speed: location.coords.speed,
      speedAccuracy: location.coords.speedAccuracy,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
    CommonFunctions().saveLocationToFirebase(position);
  }

  void _onMotionChange(bg.Location location) {
    Position position = Position(
      longitude: location.coords.longitude,
      latitude: location.coords.latitude,
      timestamp: Timestamp.now().toDate(),
      accuracy: location.coords.accuracy,
      altitude: location.coords.altitude,
      heading: location.coords.heading,
      speed: location.coords.speed,
      speedAccuracy: location.coords.speedAccuracy,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
    CommonFunctions().saveLocationToFirebase(position);
  }
}

class Repo {
  static Repo? _instance;

  Repo._();

  factory Repo() => _instance ??= Repo._();

  Future<void> update(BackgroundLocationUpdateData data) async {
    await Firebase.initializeApp();
    Position position = Position(
      longitude: data.lon,
      latitude: data.lat,
      timestamp: DateTime.now(),
      accuracy: data.courseAccuracy,
      altitude: data.alt,
      heading: data.horizontalAccuracy,
      speed: data.speed,
      speedAccuracy: data.speedAccuracy,
      altitudeAccuracy: data.alt,
      headingAccuracy: 0.0,
    );
    CommonFunctions().saveLocationToFirebase(position);
  }
}
