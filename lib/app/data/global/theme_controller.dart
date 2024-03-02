// // // Package imports:
// // import 'dart:ui';

// // import 'package:enum_to_string/enum_to_string.dart';
// // // Project imports:
// // import 'package:champrep_mobile/helpers/constants/image_constants.dart';
// // import 'package:champrep_mobile/helpers/constants/storage_constants.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:get_storage/get_storage.dart';

// // class ThemeController extends GetxController {
// //   final GetStorage storage = GetStorage();
// //   final List<ThemeModel> addThemeList = <ThemeModel>[];
// //   Rxn<Brightness> brightness = Rxn<Brightness>();

// //   @override
// //   void onInit() {
// //     super.onInit();

// //     // final SingletonFlutterWindow window = WidgetsBinding.instance.window;
// //     //
// //     // // Set initial value if customBrightness is not set
// //     // if (storage.read(StorageConstants.customBrightness) == null) {
// //     //   brightness.value = window.platformBrightness;
// //     // } else {
// //     //   brightness.value = EnumToString.fromString(
// //     //     Brightness.values,
// //     //     storage.read(StorageConstants.customBrightness).toString(),
// //     //   );
// //     // }
// //     //
// //     // // Add change listener if customBrightness is not set
// //     // window.onPlatformBrightnessChanged = () {
// //     //   if (storage.read('customBrightness') == null) {
// //     //     brightness.value = window.platformBrightness;
// //     //     if (kDebugMode) {
// //     //       print("System brightness changed to ${window.platformBrightness}");
// //     //     }
// //     //   }
// //     // };
// //   }

// //   void fillThemeData() {
// //     addThemeList.clear();
// //     addThemeList.addAll(ThemeModel.getThemeList);
// //     for (final ThemeModel element in addThemeList) {
// //       final String? customBrightness = storage.read('customBrightness');
// //       if (customBrightness == element.brightness) {
// //         element.isSelected = true;
// //       } else if (customBrightness == null && element.brightness == null) {
// //         element.isSelected = true;
// //       }
// //     }
// //     update();
// //   }

// //   void setTheme({required String? customBrightness}) {
// //     if (customBrightness == null) {
// //       brightness.value = WidgetsBinding.instance.window.platformBrightness;
// //       storage.remove(StorageConstants.customBrightness);
// //     } else {
// //       brightness.value =
// //           EnumToString.fromString(Brightness.values, customBrightness);
// //       storage.write(StorageConstants.customBrightness, customBrightness);
// //     }

// //     update();
// //   }
// // }

// // class ThemeModel {
// //   ThemeModel({
// //     required this.brightnessIcon,
// //     required this.brightnessName,
// //     required this.brightness,
// //     this.isSelected = false,
// //   });

// //   String brightnessIcon;
// //   String brightnessName;
// //   String? brightness;
// //   bool? isSelected;

// //   static List<ThemeModel> getThemeList = <ThemeModel>[
// //     ThemeModel(
// //       brightnessIcon: ImageConstants.sun,
// //       brightnessName: "Light Mode",
// //       brightness: 'light',
// //     ),
// //     ThemeModel(
// //       brightnessIcon: ImageConstants.moon,
// //       brightnessName: "Dark Mode",
// //       brightness: 'dark',
// //     ),
// //     ThemeModel(
// //       brightnessIcon: ImageConstants.deviceMobile,
// //       brightnessName: "System",
// //       brightness: null,
// //     ),
// //   ];
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:champrep_mobile/helpers/constants/storage_constants.dart';

// class ThemeController extends GetxController {
//   var isDarkMode = false.obs;
//   final GetStorage storage = GetStorage();

//   @override
//   void onInit() {
//     super.onInit();
//     isDarkMode.value = storage.read(StorageConstants.isDarkMode) ?? false;
//   }

//   void toggleTheme() {
//     isDarkMode.value = !isDarkMode.value;
//     storage.write(StorageConstants.isDarkMode, isDarkMode.value);
//   }

//   ThemeData get theme => isDarkMode.value
//       ? ThemeData.dark().copyWith(
//           brightness: Brightness.dark,

//           // add your custom dark theme data here
//         )
//       : ThemeData.light().copyWith(
//           brightness: Brightness.light,

//           // add your custom light theme data here
//         );

// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = storage.read(StorageConstants.isDarkMode) ?? false;
  }

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await storage.write(StorageConstants.isDarkMode, isDarkMode.value);
    if (isDarkMode.value) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    }

    update();
  }

  ThemeData get theme => isDarkMode.value
      ? ThemeData.dark().copyWith(
          brightness: Brightness.dark,

          // add your custom dark theme data here
        )
      : ThemeData.light().copyWith(
          brightness: Brightness.light,

          // add your custom light theme data here
        );
}
