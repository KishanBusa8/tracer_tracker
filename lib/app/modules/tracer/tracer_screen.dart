import 'dart:convert';

import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:tracer_tracker/app/data/global/theme_controller.dart';
import 'package:tracer_tracker/app/modules/tracer/tracer_controller.dart';
import 'package:tracer_tracker/components/base_widget.dart';
import 'package:tracer_tracker/helpers/Utils/map_utils.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';
import 'package:tracer_tracker/helpers/schema/color_schema.dart';

class TracerScreen extends StatelessWidget {
  TracerScreen({super.key});

  final ThemeController _themeController = Get.find();
  final TracerController _controller = Get.put(TracerController());
  Set<Marker> lastMarkers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.googleMapController = controller;
    controller.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(_controller.current.value.latitude,
          _controller.current.value.longitude),
      16,
    ));
    if (_themeController.isDarkMode.value) {
      _controller.googleMapController
          .setMapStyle(jsonEncode(StorageConstants.darkMap));
    } else {
      _controller.googleMapController.setMapStyle(jsonEncode([]));
    }
    _themeController.isDarkMode.listen((bool isDarkMode) {
      if (isDarkMode) {
        _controller.googleMapController
            .setMapStyle(jsonEncode(StorageConstants.darkMap));
      } else {
        _controller.googleMapController.setMapStyle(jsonEncode([]));
      }
    });
    if (_controller.markers.isNotEmpty) {
      Future.delayed(
          const Duration(milliseconds: 200),
          () => controller.animateCamera(CameraUpdate.newLatLngBounds(
              MapUtils.boundsFromLatLngList(_controller.markers
                  .map((element) => element.marker.position)
                  .toList()),
              10)));
    }
  }

  CameraPosition initialPosition = const CameraPosition(
    target: LatLng(-24.868127, 152.34027),
    zoom: 15.0,
  );

  @override
  Widget build(BuildContext context) {
    return BaseWidget(children: [
      const SizedBox(
        height: 10,
      ),
      Expanded(
        child: Obx(() {
          return ShowUpAnimation(
            delayStart: const Duration(milliseconds: 200),
            animationDuration: const Duration(seconds: 1),
            curve: Curves.bounceIn,
            direction: Direction.vertical,
            offset: 0.5,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomGoogleMapMarkerBuilder(
                customMarkers: _controller.markers.value,
                builder: (BuildContext context, Set<Marker>? markers) {
                  if (markers != null) {
                    lastMarkers = markers;
                  }
                  return GoogleMap(
                    mapType: MapType.normal,
                    zoomGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: _controller.current.value,
                      zoom: 15.0,
                    ),
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    onTap: (position) {},
                    onCameraMove: (position) {},
                    markers: lastMarkers,
                  );
                },
              ),
            ),
          );
        }),
      ),
      const SizedBox(
        height: 20,
      ),
      ShowUpAnimation(
        delayStart: const Duration(milliseconds: 500),
        animationDuration: const Duration(seconds: 1),
        curve: Curves.bounceIn,
        direction: Direction.vertical,
        offset: 0.5,
        child: Obx(() {
          return AnimatedButton(
            onPress: () {
              if (_controller.isRecording.value) {
                _controller.stopRecord();
              } else {
                _controller.startRecord(
                  fileName: '${DateTime.now().millisecondsSinceEpoch}',
                );
              }
            },
            height: 50,
            text: _controller.isRecording.value
                ? 'Stop Recording'
                : 'Start Recoding',
            isReverse: true,
            borderRadius: 12,
            selectedTextColor: Colors.black,
            transitionType: TransitionType.CENTER_LR_OUT,
            backgroundColor: ColorSchema.primary(),
            borderColor: ColorSchema.primary(),
            borderWidth: 1,
          );
        }),
      ),
      // Obx(() {
      //   return CustomButton(
      //     buttonType: ButtonType.enable,
      //     onTap: () {
      //       if (_controller.isRecording.value) {
      //         _controller.stopRecord();
      //       } else {
      //         _controller.startRecord(
      //           fileName: '${DateTime.now().millisecondsSinceEpoch}',
      //         );
      //       }
      //     },
      //     backgroundColor: !_controller.isRecording.value
      //         ? ColorSchema.primary()
      //         : ColorSchema.darkGray(),
      //     titleColor: SingleColor.white,
      //     suffixIcon: _controller.isRecording.value
      //         ? const Icon(
      //             Icons.stop_circle,
      //             color: Colors.white,
      //           )
      //         : const Icon(Icons.play_circle, color: Colors.white),
      //     title: _controller.isRecording.value
      //         ? 'Stop Recording'
      //         : 'Start Recoding',
      //   );
      // }),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
