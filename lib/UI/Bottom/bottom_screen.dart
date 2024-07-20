// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/bottom_controller.dart';

class BottomScreen extends StatelessWidget {
  BottomScreen({super.key});

  final BottomController bc = Get.put(BottomController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        backgroundColor: bc.index.value == 0 ? Theme.of(context).bottomNavigationBarTheme.backgroundColor : isDark ? tabColor : whiteColor,
        body: Obx(() {
          bc.index.value;
          return IndexedStack(index: bc.index.value, children: bc.bottomPages);
        }),
        bottomNavigationBar: Obx(() {
          bc.index.value;
          return Container(
            margin: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 16.h),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: blackColor,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildNavItem('assets/icons/home.svg', 'home'.tr, 0),
                buildNavItem('assets/icons/report.svg', 'report'.tr, 1),
                buildNavItem('assets/icons/history.svg', 'history'.tr, 2),
                buildNavItem('assets/icons/setting.svg', 'setting'.tr, 3),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget buildNavItem(String icon, String title, int index) {
    return GestureDetector(
      onTap: () {
        bc.index.value = index;
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 33.h,
            width: bc.index.value == index ? 85.w : 70.w,
            decoration: BoxDecoration(
              color: bc.index.value == index ? blueColor : transparentColor,
              borderRadius: BorderRadius.circular(bc.index.value == index ? 12.r : 0.r),
            ),
            child: Center(
                child: bc.index.value == index
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(icon, height: 18.w, width: 18.w),
                          SizedBox(width: 6.w),
                          TextWidget(text: title, fontSize: 12.sp, fontFamily: 'M', color: whiteColor, textAlign: TextAlign.center),
                        ],
                      )
                    : SvgPicture.asset(icon, height: 18.w, width: 18.w)),
          ),
        ],
      ),
    );
  }
}