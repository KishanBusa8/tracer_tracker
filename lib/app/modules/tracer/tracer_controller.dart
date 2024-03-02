import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:tracer_tracker/helpers/constants/image_constants.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';

class TracerController extends GetxController {
  Stream<DocumentSnapshot>? liveLocationSubscription;
  late GoogleMapController googleMapController;
  RxList<MarkerData> markers = <MarkerData>[].obs;

  RxBool isRecording = false.obs;

  Rx<LatLng> current = const LatLng(0.0, 0.0).obs;
  Rx<Position> last = Position(
          accuracy: 0,
          altitude: 0,
          heading: 0,
          latitude: 0,
          longitude: 0,
          speed: 0,
          speedAccuracy: 0,
          timestamp: DateTime.now(),
          floor: 0,
          isMocked: false,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0)
      .obs;
  @override
  void onInit() {
    bool animate = true;
    if (liveLocationSubscription != null) {
      liveLocationSubscription?.drain();
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      liveLocationSubscription = FirebaseFirestore.instance
          .collection(StorageConstants.trackerCollection)
          .doc(StorageConstants.locationDoc)
          .snapshots();
      liveLocationSubscription!.listen((DocumentSnapshot event) {
        Position position = Position.fromMap(event.data());
        last.value = position;
        current.value = LatLng(position.latitude, position.longitude);
        markers.value.removeWhere(
          (element) =>
              element.marker.markerId == const MarkerId('currentLocation'),
        );
        markers.value.add(
          MarkerData(
            marker: Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: InfoWindow(
                title: '${(position.speed * 3.6).round()} KM/H',
                snippet: 'Speed',
              ),
              onTap: () {},
              rotation: position.heading,
            ),
            child: Image.asset(
              ImageConstants.truck,
              height: 75,
              width: 75,
            ),
          ),
        );
        markers.refresh();
        if (animate) {
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 13.5,
                target: LatLng(position.latitude, position.longitude),
              ),
            ),
          );
          animate = false;
        }
      });
    });
    super.onInit();
  }

  Future<void> startRecord({required String fileName}) async {
    await [
      Permission.microphone,
      Permission.storage,
      Permission.photos,
    ].request();
    try {
      bool started = await FlutterScreenRecording.startRecordScreen(
        fileName,
        messageNotification: 'Your screen is being recorded',
        titleNotification: 'Screen Recording',
      );
      isRecording.value = started;
    } catch (e) {
      kDebugMode
          ? debugPrint(
              "Error: An error occurred while starting the recording! $e")
          : null;
    }
  }

  Future<void> stopRecord() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    isRecording.value = false;
    final result = await SaverGallery.saveFile(
      file: path,
      androidExistNotSave: true,
      androidRelativePath: "Movies",
      name: path.split('/').last,
    );
    OpenFile.open(path);
  }
}
