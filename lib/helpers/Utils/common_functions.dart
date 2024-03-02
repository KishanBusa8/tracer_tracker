import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';
import 'package:tracer_tracker/helpers/schema/color_schema.dart';
import 'package:tracer_tracker/helpers/schema/text_styles.dart';

class CommonFunctions {
  static Future<Position> determinePosition() async {
    await [
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ].request();
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      CommonFunctions().showSnackBar(
        message: 'Please enable your location service to continue!',
        backgroundColor: Colors.red,
      );
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<bool> grantLocationPermission() async {
    // if (Platform.isIOS) {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await [
        Permission.location,
        Permission.locationWhenInUse,
      ].request();
      await Permission.locationAlways.request();
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        CommonFunctions().showSnackBar(
          message: 'Please enable your location service to continue!',
          backgroundColor: Colors.red,
        );
        return false;
      }
    }
    //
    if (permission == LocationPermission.deniedForever) {
      CommonFunctions().showSnackBar(
        message: 'Please enable your location service to continue!',
        backgroundColor: Colors.red,
      );
      return false;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return true;
    // }
  }

  static bool isNullEmptyOrFalse(dynamic o) {
    if (o is Map<String, dynamic> || o is List<dynamic>) {
      return o == null || o.length == 0;
    }
    return o == null || false == o || "" == o;
  }

  void showSnackBar({Color? backgroundColor, required String message}) {
    final Color background =
        backgroundColor ?? ColorSchema.universalSwap().withOpacity(1);
    // Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        message: message,
        borderRadius: 8,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        snackPosition: SnackPosition.TOP,
        messageText: Text(
          message,
          style: CustomTextStyle().heading6().copyWith(
                color: ColorSchema.background(),
                fontWeight: FontWeight.bold,
              ),
        ),
        backgroundColor: background,
        duration: const Duration(milliseconds: 2300),
      ),
    );
  }

  saveLocationToFirebase(Position position) {
    FirebaseFirestore.instance
        .collection(StorageConstants.trackerCollection)
        .doc(StorageConstants.locationDoc)
        .set(
          position.toJson(),
        );
  }
}
