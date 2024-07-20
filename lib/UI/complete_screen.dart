import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/UI/Bottom/bottom_screen.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/complete.jpg'), fit: BoxFit.fill)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Lottie.asset(
                'assets/lottie/highfive.json',
              ),
              const Spacer(),
              TextWidget(
                  text: 'youareready'.tr, fontSize: 18.sp, fontFamily: 'SM', color: whiteColor, textAlign: TextAlign.center),
              SizedBox(height: 5.h),
              TextWidget(
                  text: 'customizeyourdrink'.tr,
                  fontSize: 12.sp,
                  fontFamily: 'R',
                  color: whiteColor.withOpacity(0.8),
                  textAlign: TextAlign.center),
              SizedBox(height: 45.h),
              ButtonWidget(
                  title: 'getstarted'.tr,
                  buttonColor: whiteColor,
                  textColor: blueColor,
                  onTap: () async {
                    await getProfileData();
                    Get.offAll(() => BottomScreen());
                  }),
              SizedBox(height: 30.h)
            ],
          ),
        ),
      ),
    );
  }
}
