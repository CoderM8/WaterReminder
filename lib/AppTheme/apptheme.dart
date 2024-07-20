// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker/Constant/constant.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode;

  ThemeNotifier(this._themeMode);

  ThemeMode get getThemeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    if (mode == ThemeMode.system) {
      isDark = PlatformDispatcher.instance.platformBrightness == Brightness.dark;
    } else {
      isDark = mode == ThemeMode.dark;
    }
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: whiteColor,
      primaryColor: whiteColor,
      splashColor: transparentColor,
      highlightColor: transparentColor,
      useMaterial3: false,
      unselectedWidgetColor: whiteColor,
      iconTheme: const IconThemeData(color: blackColor),
      listTileTheme: const ListTileThemeData(tileColor: whiteColor),
      // colorScheme: ColorScheme.fromSwatch(brightness: Brightness.light).copyWith(onPrimary: blueColor,onSecondary: blueColor),
      sliderTheme: const SliderThemeData(
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 6,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Color(0xffF4F4F4), elevation: 0),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: blackColor),
        actionsIconTheme: const IconThemeData(color: blackColor),
        titleTextStyle: TextStyle(fontSize: 20.sp, color: blackColor, fontFamily: 'B'),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarColor: whiteColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: transparentColor,
          statusBarBrightness: Brightness.light,
        ),
      ),
      dialogTheme: DialogTheme(titleTextStyle: TextStyle(color: blackColor, fontSize: 18.sp, fontFamily: 'B'), backgroundColor: whiteColor),
      textTheme: TextTheme(
          displayLarge: h1StyleLight,
          displayMedium: h2StyleLight,
          displaySmall: h3StyleLight,
          headlineMedium: h4StyleLight,
          titleMedium: titleMediumLight,
          headlineSmall: h5StyleLight),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        // dialBackgroundColor: whiteColor,
        // dayPeriodColor: blueColor,
        // dialHandColor: whiteColor,
        // dayPeriodBorderSide: BorderSide(color: blueColor),
        // hourMinuteColor: lightBlueColor,
        // dialTextColor: Colors.black,
        // dayPeriodTextColor: Colors.black,
      ),
      datePickerTheme: DatePickerThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        // backgroundColor: Colors.white,
        // todayBackgroundColor: WidgetStateProperty.all(blueColor),
        // todayBorder: BorderSide.none,
        // yearStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: blueColor),
        // weekdayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: greyColor),
        // todayForegroundColor: MaterialStateProperty.all(blueColor),
      ),
      popupMenuTheme: const PopupMenuThemeData(color: whiteColor),
      dividerTheme: const DividerThemeData(color: greyColor),
      tabBarTheme: TabBarTheme(
        labelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
        unselectedLabelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
      ));

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: blackColor,
    primaryColor: blueColor,
    splashColor: transparentColor,
    highlightColor: transparentColor,
    useMaterial3: false,
    hintColor: whiteColor,
    unselectedWidgetColor: whiteColor,
    iconTheme: const IconThemeData(color: whiteColor),
    listTileTheme: const ListTileThemeData(tileColor: lightBlackColor),
    // colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(onPrimary: blueColor,onSecondary: blueColor),
    appBarTheme: AppBarTheme(
      elevation: 0,
      iconTheme: const IconThemeData(color: whiteColor),
      backgroundColor: blackColor,
      actionsIconTheme: const IconThemeData(color: whiteColor),
      titleTextStyle: TextStyle(fontSize: 20.sp, color: whiteColor, fontFamily: 'B'),
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarColor: blackColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: transparentColor,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    sliderTheme: const SliderThemeData(
      thumbShape: RoundSliderThumbShape(
        enabledThumbRadius: 6,
      ),
    ),
    dividerTheme: const DividerThemeData(color: whiteColor),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: tabColor, elevation: 0),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: blackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
    ),
    // colorScheme: const ColorScheme.dark(primary: Colors.white),
    dialogTheme:
        DialogTheme(titleTextStyle: TextStyle(color: whiteColor, fontSize: 18.sp, fontFamily: 'B'), backgroundColor: lightBlackColor),
    textTheme: TextTheme(
        titleMedium: titleMediumDark,
        displayLarge: h1StyleDark,
        displayMedium: h2StyleDark,
        displaySmall: h3StyleDark,
        headlineMedium: h4StyleDark,
        headlineSmall: h5StyleDark),
    timePickerTheme: TimePickerThemeData(
      backgroundColor: lightBlackColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      //dialBackgroundColor: blueColor,
      // dayPeriodColor: blueColor,
      //dialHandColor: blueColor,
      // dayPeriodBorderSide: BorderSide(color: blueColor),
      // hourMinuteColor: blueColor,
      // dialTextColor: Colors.white,
      // dayPeriodTextColor: Colors.white,
    ),
    popupMenuTheme: const PopupMenuThemeData(color: lightBlackColor),
    datePickerTheme: DatePickerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: lightBlackColor,
      headerBackgroundColor: blueColor,
      todayBackgroundColor: MaterialStateProperty.all(blueColor),
      todayBorder: BorderSide.none,
      yearStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: whiteColor),
      weekdayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp, color: greyColor),
      todayForegroundColor: MaterialStateProperty.all(whiteColor),
      dayStyle: TextStyle(fontFamily: 'M', fontSize: 16.sp),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: blueColor,
      indicatorColor: whiteColor,
      unselectedLabelColor: greyColor,
      labelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
      unselectedLabelStyle: TextStyle(fontSize: 20.sp, fontFamily: 'M'),
    ),
  );

  static setSystemUIOverlayStyle(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        if (PlatformDispatcher.instance.platformBrightness == Brightness.dark) {
          isDark = true;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.dark.copyWith(
              systemNavigationBarColor: blackColor,
              systemNavigationBarIconBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light,
              statusBarColor: transparentColor,
              statusBarBrightness: Brightness.dark,
            ),
          );
        } else {
          isDark = false;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle.light.copyWith(
              systemNavigationBarColor: whiteColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarIconBrightness: Brightness.dark,
              statusBarColor: transparentColor,
              statusBarBrightness: Brightness.light,
            ),
          );
        }
        break;
      case ThemeMode.light:
        isDark = false;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: whiteColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: transparentColor,
            statusBarBrightness: Brightness.light,
          ),
        );
        break;
      case ThemeMode.dark:
        isDark = true;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: blackColor,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarColor: transparentColor,
            statusBarBrightness: Brightness.dark,
          ),
        );
        break;
    }
  }
}

/// Light Mode
const TextStyle titleMediumLight = TextStyle(color: blackColor);
final TextStyle h1StyleLight = TextStyle(fontSize: 17.sp, color: blackColor);
final TextStyle h2StyleLight = TextStyle(fontSize: 16.sp, color: blackColor);
final TextStyle h3StyleLight = TextStyle(fontSize: 20.sp,color: blackColor);
final TextStyle h4StyleLight = TextStyle(fontSize: 15.sp, color: blackColor);
final TextStyle h5StyleLight = TextStyle(fontSize: 40.sp, color: blackColor);

/// Dark Mode
const TextStyle titleMediumDark = TextStyle(color: whiteColor);
final TextStyle h1StyleDark = TextStyle(fontSize: 17.sp, color: whiteColor);
final TextStyle h2StyleDark = TextStyle(fontSize: 16.sp, color: whiteColor);
final TextStyle h3StyleDark = TextStyle(fontSize: 20.sp,color: whiteColor);
final TextStyle h4StyleDark = TextStyle(fontSize: 15.sp, color: whiteColor);
final TextStyle h5StyleDark = TextStyle(fontSize: 40.sp, color: whiteColor);
