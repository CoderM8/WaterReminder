import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/UI/Bottom/bottom_screen.dart';
import 'package:water_tracker/UI/Authentication/login_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      userID != null ? Get.offAll(() => BottomScreen()) : Get.off(() => LoginScreen());
    });
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Image.asset('assets/images/getstarted.jpg', fit: BoxFit.fill, height: height, width: width),
          Padding(
            padding: EdgeInsets.only(bottom: 45.h, left: 28.w, right: 28.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/waterreminder.png', fit: BoxFit.fill, height: 43.h, width: 281.w),
                SizedBox(height: 8.h),
                TextWidget(
                  text: 'getstartedscreen'.tr,
                  maxLines: 3,
                  fontSize: 15.sp,
                  color: textColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
