import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracker/UI/Bottom/history_screen.dart';
import 'package:water_tracker/UI/Bottom/home_screen.dart';
import 'package:water_tracker/UI/Bottom/report_screen.dart';
import 'package:water_tracker/UI/Bottom/setting_screen.dart';

class BottomController extends GetxController {
  RxInt index = 0.obs;

  RxList<Widget> bottomPages = <Widget>[
    HomeScreen(),
    ReportScreen(),
    HistoryScreen(),
    const SettingScreen(),
  ].obs;
}
