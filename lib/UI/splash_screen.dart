import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/UI/getstarted_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Get.off(() => const GetStartedScreen(),transition: Transition.fadeIn,duration: const Duration(seconds: 1));
    });
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('assets/images/splashbg.jpg',fit: BoxFit.fill,height: height,width: width),
          Image.asset('assets/images/splashwater.png',fit: BoxFit.cover,height: 200.h,width: 200.w),
        ],
      ),
    );
  }
}
