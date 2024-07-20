import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/UI/Authentication/login_screen.dart';
import 'package:water_tracker/UI/Setting/changeTheme.dart';
import 'package:water_tracker/UI/Setting/editgender_screen.dart';
import 'package:water_tracker/UI/Setting/editgoal_screen.dart';
import 'package:water_tracker/UI/Setting/editprofile_screen.dart';
import 'package:water_tracker/UI/Setting/editweight_screen.dart';
import 'package:water_tracker/UI/Setting/help_screen.dart';
import 'package:water_tracker/UI/Setting/language_screen.dart';
import 'package:water_tracker/UI/Setting/privacy_screen.dart';
import 'package:water_tracker/UI/Setting/reminder_screen.dart';
import 'package:water_tracker/UI/Setting/terms_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            collapsedHeight: 0,
            toolbarHeight: 0,
            expandedHeight: 170.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                      height: 240.h,
                      color: transparentColor,
                      alignment: AlignmentDirectional.topStart,
                      child: Image.asset('assets/images/settingwave.png', width: width, height: 195.h, fit: BoxFit.fill)),
                  Container(
                    height: 130.w,
                    width: 130.w,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: whiteColor),
                    padding: EdgeInsets.all(1.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Obx(() {
                        return image.isNotEmpty
                            ? Image.network(image.value, height: 130.w, width: 130.w, alignment: Alignment.topCenter, fit: BoxFit.cover)
                            : Image.asset(
                                'assets/images/profile.png',
                                width: 130.w,
                                height: 130.w,
                                fit: BoxFit.cover,
                              );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Obx(() {
                return TextWidget(text: firstName.value,textAlign: TextAlign.center, fontSize: 18.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color);
              }),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: 1,
              (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      ListWidget(
                          title: 'profile'.tr,
                          image: 'assets/icons/profile.svg',
                          onTap: () {
                            Get.to(() => EditProfileScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'reminder'.tr,
                          image: 'assets/icons/notification.svg',
                          onTap: () {
                            Get.to(() => ReminderScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'gender'.tr,
                          image: 'assets/icons/gender.svg',
                          onTap: () {
                            Get.to(() => EditGenderScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'dailygoal'.tr,
                          image: 'assets/icons/goal.svg',
                          onTap: () {
                            Get.to(() => EditGoalScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'language'.tr,
                          image: 'assets/icons/language.svg',
                          onTap: () {
                            Get.to(() => LanguageScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'theme'.tr,
                          image: 'assets/icons/theme.svg',
                          onTap: () {
                            Get.to(() => const ThemeChange());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'weight'.tr,
                          image: 'assets/icons/weight.svg',
                          onTap: () {
                            Get.to(() => EditWeightScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'helpfeedback'.tr,
                          image: 'assets/icons/help.svg',
                          onTap: () {
                            Get.to(() => HelpScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'privacypolicy'.tr,
                          image: 'assets/icons/privacy.svg',
                          onTap: () {
                            Get.to(() => const PrivacyScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'termsconditions'.tr,
                          image: 'assets/icons/terms.svg',
                          onTap: () {
                            Get.to(() => const TermsScreen());
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'ratethisapp'.tr,
                          image: 'assets/icons/rate.svg',
                          onTap: () async {
                            await launchUrl(Uri.parse(appReview));
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'shareapp'.tr,
                          image: 'assets/icons/share.svg',
                          onTap: () async {
                            if (isTab(context)) {
                              await Share.share("Drink Water : Daily Reminder\n$appShare",
                                  sharePositionOrigin: Rect.fromLTWH(0, 0, MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height / 2));
                            } else {
                              await Share.share("Drink Water : Daily Reminder\n$appShare");
                            }
                          }),
                      SizedBox(height: 10.h),
                      ListWidget(
                          title: 'logout'.tr,
                          image: 'assets/icons/logout.svg',
                          onTap: () {
                            Get.dialog(Dialog(
                              insetPadding: EdgeInsets.all(20.w),
                              shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.r), borderSide: const BorderSide(color: transparentColor)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 15.h),
                                  TextWidget(
                                      text: '${'logout'.tr}?',
                                      color: Theme.of(context).textTheme.titleMedium!.color,
                                      fontFamily: 'B',
                                      fontSize: 20.sp),
                                  SizedBox(height: 15.h),
                                  TextWidget(
                                    text: 'areyousurelogout'.tr,
                                    color: Theme.of(context).textTheme.titleMedium!.color,
                                    fontSize: 15.sp,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(height: 30.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ButtonWidget(
                                          title: 'cancel'.tr,
                                          buttonColor: greyColor.withOpacity(0.5),
                                          onTap: () {
                                            Get.back();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: ButtonWidget(
                                          onTap: () async {
                                            box.erase();
                                            Get.offAll(() => LoginScreen());
                                          },
                                          title: 'logout'.tr,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ).paddingAll(20.w),
                            ));
                          }),
                      SizedBox(height: 10.h),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
