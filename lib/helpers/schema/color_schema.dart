// Flutter imports:
// ignore_for_file: avoid_classes_with_only_static_members

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:
import 'package:get_storage/get_storage.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';

class ColorSchema {
  ColorSchema();

  static GetStorage storage = GetStorage();

  static bool isDarkTheme() {
    if (storage.read(StorageConstants.isDarkMode) == true) {
      return true;
    }
    return false;
  }

  static Brightness keyboard() {
    return isDarkTheme() ? Brightness.dark : Brightness.light;
  }

  static SystemUiOverlayStyle statusBar() {
    return isDarkTheme()
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
  }

  static Color primary() {
    return isDarkTheme() ? DarkTheme.primary : LightTheme.primary;
  }

  static Color background() {
    return isDarkTheme() ? DarkTheme.background : LightTheme.background;
  }

  static Color universalSwap() {
    return !isDarkTheme()
        ? DarkTheme.background.withOpacity(1)
        : LightTheme.background;
  }

  static Color midGray3() {
    return !isDarkTheme() ? DarkTheme.midGray3 : LightTheme.midGray3;
  }

  static Color midGray2() {
    return !isDarkTheme() ? DarkTheme.midGray2 : LightTheme.midGray2;
  }

  static Color midGray1() {
    return !isDarkTheme() ? DarkTheme.midGray1 : LightTheme.midGray1;
  }

  static Color darkGray() {
    return !isDarkTheme() ? DarkTheme.darkGray : LightTheme.darkGray;
  }

  static Color lightGray() {
    return !isDarkTheme() ? DarkTheme.lightGray : LightTheme.lightGray;
  }
}

class SingleColor {
  static const Color background = Color(0xff1F1F1F);
  static const Color colorRed = Color(0xffEE5253);
  static const Color white = Color(0xffFFFFFF);
  static const Color underLightGray = Color(0xffF2F2F2);
  static const Color lightGray = Color(0xffE6E6E6);
  static const Color midGray1 = Color(0xffDADADA);
  static const Color midGray2 = Color(0xffC2C2C2);
  static const Color midGray3 = Color(0xff9B9B9B);
  static const Color midGray4 = Color(0xff868e96);
  static const Color darkGray = Color(0xff838383);
  static const Color ultraDarkGray = Color(0xff1F1F1F);
  static const Color primary = Color(0xff303956);
  static const Color blue = Colors.blue;
  static const Color green = Color(0xff77C13A);
}

class LightTheme {
  static const Color background = Color(0xffFFFFFF);
  static const Color white = Color(0xffFFFFFF);
  static const Color underLightGray = Color(0xffF2F2F2);
  static const Color lightGray = Color(0xffE6E6E6);
  static const Color midGray1 = Color(0xffDADADA);
  static const Color midGray2 = Color(0xffC2C2C2);
  static const Color midGray3 = Color(0xff9B9B9B);
  static const Color darkGray = Color(0xff838383);
  static const Color ultraDarkGray = Color(0xff1F1F1F);
  static const Color primary = Color(0xff303956);
}

class DarkTheme {
  static Color background = const Color(0xff1D1E26);
  static const Color white = Color(0xffFFFFFF);
  static const Color underLightGray = Color(0xffF2F2F2);
  static const Color lightGray = Color(0xffE6E6E6);
  static const Color midGray1 = Color(0xffDADADA);
  static const Color midGray2 = Color(0xffC2C2C2);
  static const Color midGray3 = Color(0xff9B9B9B);
  static const Color darkGray = Color(0xff838383);
  static const Color ultraDarkGray = Color(0xff1F1F1F);
  static const Color primary = Color(0xff303956);
}
