import 'dart:io';

import 'flutter_zoom_checker_platform_interface.dart';

class FlutterZoomChecker {
  static Future<bool?> isZoomed() {
    if (!Platform.isIOS) return Future.value(null);
    return FlutterZoomCheckerPlatform.instance.isZoomed();
  }

  static Future<bool?> isDefault() {
    if (!Platform.isIOS) return Future.value(null);
    return FlutterZoomCheckerPlatform.instance.isDefault();
  }

  static Future<bool?> isMoreSpace() {
    if (!Platform.isIOS) return Future.value(null);
    return FlutterZoomCheckerPlatform.instance.isMoreSpace();
  }
}
