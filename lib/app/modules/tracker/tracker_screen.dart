import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:tracer_tracker/app/data/global/theme_controller.dart';
import 'package:tracer_tracker/app/modules/tracker/tracker_controller.dart';
import 'package:tracer_tracker/components/base_widget.dart';
import 'package:tracer_tracker/helpers/Utils/common_functions.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';
import 'package:tracer_tracker/helpers/schema/color_schema.dart';

class TrackerScreen extends StatelessWidget {
  TrackerScreen({super.key});

  final TrackerController _controller = Get.put(TrackerController());
  final ThemeController _themeController = Get.find();

  Set<Marker> lastMarkers = {};

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.googleMapController = controller;
    Position position = await CommonFunctions.determinePosition();
    controller.animateCamera(CameraUpdate.newLatLngZoom(
      LatLng(position.latitude, position.longitude),
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ShowUpAnimation(
            delayStart: const Duration(milliseconds: 200),
            animationDuration: const Duration(seconds: 1),
            curve: Curves.bounceIn,
            direction: Direction.vertical,
            offset: 0.5,
            child: GoogleMap(
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              initialCameraPosition: initialPosition,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              onTap: (position) {},
              onCameraMove: (position) {},
            ),
          ),
        ),
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
              _controller.toggleOnlineOffline();
            },
            height: 50,
            text: _controller.isOnline.value ? 'Offline' : 'Come Online',
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
      //       _controller.toggleOnlineOffline();
      //     },
      //     backgroundColor: !_controller.isOnline.value
      //         ? ColorSchema.primary()
      //         : ColorSchema.darkGray(),
      //     titleColor: SingleColor.white,
      //     title: _controller.isOnline.value ? 'Offline' : 'Come Online',
      //   );
      // }),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
