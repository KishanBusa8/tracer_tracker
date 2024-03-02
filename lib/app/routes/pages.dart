import 'package:get/get.dart';
import 'package:tracer_tracker/app/modules/splash/splash_screen.dart';
import 'package:tracer_tracker/app/modules/tracer/tracer_screen.dart';
import 'package:tracer_tracker/app/modules/tracker/tracker_screen.dart';

part 'routes.dart';

class AppPages {
  final List<GetPage<dynamic>> pages = <GetPage<dynamic>>[
    GetPage<dynamic>(
      name: Routes.initial,
      page: () => const SplashScreen(),
    ),
    GetPage<dynamic>(
      name: Routes.tracerScreen,
      page: () => TracerScreen(),
    ),
    GetPage<dynamic>(
      name: Routes.trackerScreen,
      page: () => TrackerScreen(),
    ),
  ];
}
