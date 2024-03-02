import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracer_tracker/helpers/constants/storage_constants.dart';
import 'package:tracer_tracker/helpers/schema/color_schema.dart';

enum FontFamily { lato }

class CustomTextStyle {
  static GetStorage storage = GetStorage();

  static bool isDarkTheme() {
    if (storage.read(StorageConstants.isDarkMode) == true) {
      return true;
    }
    return false;
  }

  TextStyle heading4() {
    return ThemeTextStyles()
        .heading4
        .copyWith(color: ColorSchema.universalSwap());
  }

  TextStyle heading5() {
    return ThemeTextStyles()
        .heading5
        .copyWith(color: ColorSchema.universalSwap());
  }

  TextStyle heading6() {
    return ThemeTextStyles()
        .heading6
        .copyWith(color: ColorSchema.universalSwap());
  }

  TextStyle specialLink() {
    return ThemeTextStyles()
        .specialLink
        .copyWith(color: ColorSchema.universalSwap());
  }

  TextStyle paragraph() {
    return ThemeTextStyles()
        .paragraph
        .copyWith(color: ColorSchema.universalSwap());
  }

  TextStyle caption() {
    return ThemeTextStyles()
        .caption
        .copyWith(color: ColorSchema.universalSwap());
  }

  TextStyle other() {
    return ThemeTextStyles().other.copyWith(color: ColorSchema.universalSwap());
  }

  TextStyle placeHolder() {
    return ThemeTextStyles()
        .placeHolder
        .copyWith(color: ColorSchema.universalSwap());
  }
}

class ThemeTextStyles {
  TextStyle heading4 = TextStyle(
    fontSize: CustomFontSize.heading4,
    fontWeight: FontWeight.normal,
    fontFamily: FontFamily.lato.name,
  );
  TextStyle heading5 = TextStyle(
    fontSize: CustomFontSize.heading5,
    fontWeight: FontWeight.w600,
    fontFamily: FontFamily.lato.name,
  );
  TextStyle heading6 = TextStyle(
    fontSize: CustomFontSize.heading6,
    fontWeight: FontWeight.w600,
    fontFamily: FontFamily.lato.name,
  );

  TextStyle specialLink = TextStyle(
    fontSize: CustomFontSize.heading6,
    fontWeight: FontWeight.normal,
    fontFamily: FontFamily.lato.name,
  );
  TextStyle paragraph = TextStyle(
    fontSize: CustomFontSize.heading5,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.lato.name,
  );

  TextStyle caption = TextStyle(
    fontSize: CustomFontSize.heading6,
    fontWeight: FontWeight.w400,
    fontFamily: FontFamily.lato.name,
  );

  TextStyle other = TextStyle(
    fontSize: CustomFontSize.other,
    fontWeight: FontWeight.w500,
    fontFamily: FontFamily.lato.name,
  );
  TextStyle placeHolder = TextStyle(
    fontSize: CustomFontSize.placeHolder,
    fontWeight: FontWeight.normal,
    fontFamily: FontFamily.lato.name,
  );
}

class CustomFontSize {
  static const double heading4 = 25;
  static const double heading5 = 18;
  static const double heading6 = 14;
  static const double other = 12;
  static const double placeHolder = 16;
  static const double micro = 10;
}
