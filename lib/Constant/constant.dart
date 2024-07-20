import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:water_tracker/Services/api.dart';
import 'package:webview_flutter/webview_flutter.dart';

final box = GetStorage();

const Color whiteColor = Color(0xffffffff);
const Color blackColor = Color(0xff000000);
const Color blueColor = Color(0xff1998F1);
const Color lightBlueColor = Color(0x801998f1);
const Color textColor = Color(0xff808080);
const Color greyColor = Color(0xff999999);
const Color backgroundGreyColor = Color(0xffF5F5F5);
const Color redColor = Colors.red;
const Color transparentColor = Colors.transparent;
const Color shimmer = Color(0x80999999);
const Color tabColor = Color(0xff1F2529);
const Color lightBlackColor = Color(0xff202529);
const Color tabContainerColor = Color(0xff3F4447);

const MethodChannel channel = MethodChannel('com.vocsywaterreminder');

int themeMode = 0;
bool isDark = false;

final RxBool isLoginProgress = false.obs;
final RxBool isRefresh = false.obs;

final RxInt drinkWater = 0.obs;
final RxInt remainingWater = 0.obs;
final RxString waterPercentage = '0.0'.obs;
final RxDouble waterProgress = 0.0.obs;

final RxBool isNotification = false.obs;

final String toDay = DateFormat('EEEE').format(DateTime.now());
final String todayDate = DateFormat('dd MMMM y').format(DateTime.now());
final String todayDateNumber = DateFormat('d').format(DateTime.now());

WebViewController privacyController = WebViewController();
WebViewController termsController = WebViewController();

Future getUserId() async {
  userID = box.read('userID');
  box.writeIfNull('languageCode', 'en');
  debugPrint('USER ID :::: $userID');
}

String? userID;
final RxString gender = ''.obs;
final RxInt genderIndex = 0.obs;
final RxString weight = ''.obs;
final RxInt weightNumber = 0.obs;
final RxString weather = ''.obs;
final RxString image = ''.obs;
final RxString email = ''.obs;
final RxString firstName = ''.obs;
final RxString lastName = ''.obs;
final RxString dob = ''.obs;
final RxString flagCode = ''.obs;
final RxString number = ''.obs;
final RxString waterType = ''.obs;
final RxInt waterNumber = 0.obs;

class Api {
  static const mainApi = 'https://vocsyinfotech.in/vocsy/flutter/Water_Reminder/api.php';
}

const String androidLink = 'https://play.google.com/store/apps/details?id=com.vocsywaterreminder';
const String iosLink = 'https://apps.apple.com/us/app/drink-water-daily-reminder/id6503231333';
const String iosReview = 'https://itunes.apple.com/app/id6503231333?action=write-review';

String get appShare {
  if (Platform.isAndroid) {
    return androidLink;
  } else {
    return iosLink;
  }
}

String get appReview {
  if (Platform.isAndroid) {
    return androidLink;
  } else {
    return iosReview;
  }
}

double height = MediaQuery.sizeOf(Get.context!).height;
double width = MediaQuery.sizeOf(Get.context!).width;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

bool isTab(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= 600 && MediaQuery.sizeOf(context).width < 2048;
}

Future configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future appTracking() async {
  TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
  if (status == TrackingStatus.notDetermined) {
    await AppTrackingTransparency.requestTrackingAuthorization();
  } else if (status == TrackingStatus.denied) {
    await AppTrackingTransparency.requestTrackingAuthorization();
    openAppSettings();
  }
  if (status == TrackingStatus.authorized) {
    await AppTrackingTransparency.getAdvertisingIdentifier();
  }
}

Future<Map<String,dynamic>> getProfileData() async {
  if (userID != null) {
    final profile = (await AllApi().getProfileApi())["WATER_REMIND"][0];
    if (profile.isNotEmpty) {
      image.value = profile['user_image'];
      email.value = profile['email'];
      firstName.value = profile['firstName'];
      lastName.value = profile['lastName'];
      dob.value = profile['dob'];
      flagCode.value = profile['flagCode'];
      number.value = profile['number'];
      waterType.value = profile['waterType'];
      waterNumber.value = profile['waterNumber'];
      gender.value = profile['gender'];
      genderIndex.value = profile['genderIndex'];
      weight.value = profile['weight'];
      weightNumber.value = profile['weightNumber'];
      weather.value = profile['weather'];
      drinkWater.value = profile['total_ml_today'] ?? 0;
      remainingWater.value = waterNumber.value - drinkWater.value;
      waterPercentage.value = (drinkWater.value / waterNumber.value * 100).toStringAsFixed(2);
      waterProgress.value = drinkWater.value / waterNumber.value;

      // print("send start ----");
      // channel.invokeMethod("forwardToAppleWatch", {
      //   "method": "updateTextFromFlutter",
      //   "data": {
      //     "drinkWater": "${drinkWater.value}" , "remainingWater": "${remainingWater.value}", "waterPercentage": waterPercentage.value,"waterProgress":"${waterProgress.value}"
      //   },
      // });
      // print("send end ----");


      // await  channel.invokeMethod("flutterToWatch", {
     //    "method": "sendCounterToNative",
     //    "data": drinkWater.value
     //    // {
     //    //   "drinkWater": "${drinkWater.value}" , "remainingWater": "${remainingWater.value}", "waterPercentage": waterPercentage.value,"waterProgress":"${waterProgress.value}"
     //    // }
     //  });

    }
    return profile;
  }
  return {};

}

int convertWater(int waterNumber, String waterType) {
  if (waterType == 'L') {
    return waterNumber * 1000;
  } else if (waterType == 'US Oz') {
    return (waterNumber * 29.59).toInt();
  } else if (waterType == 'UK Oz') {
    return (waterNumber * 28.41).toInt();
  } else {
    return waterNumber;
  }
}

String greet() {
  var hour = DateTime.now().hour;
  if (hour >= 5 && hour < 12) {
    return 'goodmorning'.tr;
  } else if (hour >= 12 && hour < 17) {
    return 'goodafternoon'.tr;
  } else if (hour >= 17 && hour < 21) {
    return 'goodevening'.tr;
  } else {
    return 'goodnight'.tr;
  }
}

showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: isDark ? Colors.white60 : Colors.black45,
    textColor: isDark ? blackColor : whiteColor,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    fontSize: 16.sp,
  );
}

class TodayChartData {
  TodayChartData({required this.x, required this.y});

  final String x;
  final int y;

  Map<String, dynamic> toMap() {
    return {
      'time_interval': x,
      'total_ml': y,
    };
  }

  factory TodayChartData.fromMap(Map<String, dynamic> map) {
    return TodayChartData(
      x: map['time_interval'],
      y: map['total_ml'],
    );
  }
}

class WeekChartData {
  WeekChartData({required this.time, required this.ml, required this.goal, required this.ratio, required this.date});

  final String time;
  final String date;
  final int ml;
  final int goal;
  final String ratio;

  Map<String, dynamic> toMap() {
    return {
      'time_interval': time,
      'date': date,
      'total_ml': ml,
      'goal': goal,
      'ratio': ratio,
    };
  }

  factory WeekChartData.fromMap(Map<String, dynamic> map) {
    return WeekChartData(
      time: map['time_interval'] ?? '',
      date: map['date'] ?? '',
      ml: map['total_ml'] ?? 0,
      goal: map['goal'] ?? 0,
      ratio: map['ratio'] ?? '0',
    );
  }
}

class MonthChartData {
  MonthChartData({required this.time, required this.ml, required this.goal, required this.ratio, required this.date});

  final String time;
  final String date;
  final int ml;
  final int goal;
  final String ratio;

  Map<String, dynamic> toMap() {
    return {
      'time_interval': time,
      'date': date,
      'total_ml': ml,
      'goal': goal,
      'ratio': ratio,
    };
  }

  factory MonthChartData.fromMap(Map<String, dynamic> map) {
    return MonthChartData(
      time: map['time_interval'] ?? '',
      date: map['date'] ?? '',
      ml: map['total_ml'] ?? 0,
      goal: map['goal'] ?? 0,
      ratio: map['ratio'] ?? '0',
    );
  }
}

class YearChartData {
  YearChartData({required this.time, required this.ml, required this.goal, required this.ratio});

  final String time;
  final int ml;
  final int goal;
  final String ratio;

  Map<String, dynamic> toMap() {
    return {
      'time_interval': time,
      'total_ml': ml,
      'goal': goal,
      'ratio': ratio,
    };
  }

  factory YearChartData.fromMap(Map<String, dynamic> map) {
    return YearChartData(
      time: map['time_interval'] ?? '',
      ml: map['total_ml'] ?? 0,
      goal: map['goal'] ?? 0,
      ratio: map['ratio'] ?? '0',
    );
  }
}
