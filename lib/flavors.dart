enum Flavor {
  tracer,
  tracker,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.tracer:
        return 'Tracer';
      case Flavor.tracker:
        return 'Tracker';
      default:
        return 'title';
    }
  }

}
