import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tracer_tracker/app/routes/pages.dart';
import 'package:tracer_tracker/flavors.dart';
import 'package:tracer_tracker/helpers/constants/image_constants.dart';
import 'package:tracer_tracker/helpers/schema/color_schema.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (ColorSchema.isDarkTheme()) {
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

    Future.delayed(const Duration(seconds: 2)).then((value) async {
      if (F.appFlavor == Flavor.tracer) {
        Get.offAllNamed(Routes.tracerScreen);
      } else {
        Get.offAllNamed(Routes.trackerScreen);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.asset(ImageConstants.splashAnimation),
            ),
          ],
        ),
      ),
    );
  }
}
