import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    tabController!.index = 0;
    tabController!.addListener(smoothScrollToTop);
    super.onInit();
  }

  smoothScrollToTop() {
    tabIndex.value = tabController!.index;
  }
}
