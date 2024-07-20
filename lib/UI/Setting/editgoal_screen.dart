import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/editprofile_controller.dart';
import 'package:water_tracker/Services/api.dart';

class EditGoalScreen extends StatelessWidget {
  EditGoalScreen({super.key});

  final EditProfileController ep = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('dailygoal'.tr, context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                      text: '${'todaygoal'.tr} :',
                      fontSize: 15.sp,
                      fontFamily: 'B',
                      color: Theme.of(context).textTheme.titleMedium!.color,
                      textAlign: TextAlign.center),
                  Obx(() {
                    return TextWidget(
                        text: '${waterNumber.value.toString()} ML',
                        fontSize: 15.sp,
                        fontFamily: 'SM',
                        color: Theme.of(context).textTheme.titleMedium!.color,
                        textAlign: TextAlign.center);
                  }),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            TextWidget(text: 'goaldescription'.tr, fontSize: 12.sp, fontFamily: 'R', color: textColor, textAlign: TextAlign.center),
            SizedBox(height: 30.h),
            SizedBox(
              height: 40.h,
              child: ListView.separated(
                itemCount: ep.goalList.length,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemBuilder: (BuildContext context, int index) {
                  return Obx(() {
                    return InkWell(
                      onTap: () {
                        ep.goalIndex.value = index;
                        ep.goal.value = ep.goalList[index].title;
                        ep.fixWater.value = ep.map[ep.goal.value];
                      },
                      child: Container(
                        height: 40.h,
                        width: 72.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        decoration: BoxDecoration(
                            color: ep.goalIndex.value == index ? lightBlueColor.withOpacity(0.2) : greyColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(width: 1.w, color: ep.goalIndex.value == index ? lightBlueColor : textColor.withOpacity(0.5))),
                        child: TextWidget(
                            text: ep.goalList[index].title,
                            fontSize: 12.sp,
                            fontFamily: ep.goalIndex.value == index ? 'B' : 'M',
                            color: ep.goalIndex.value == index ? blueColor : textColor,
                            textAlign: TextAlign.center),
                      ),
                    );
                  });
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: 15.h);
                },
              ),
            ),
            SizedBox(height: 55.h),
            Obx(() {
              ep.goal.value;
              return TextWidget(
                  text: '${ep.fixWater.value} ${ep.goal.value}',
                  fontSize: 28.sp,
                  fontFamily: 'B',
                  color: Theme.of(context).textTheme.titleMedium!.color,
                  textAlign: TextAlign.center);
            }),
            SizedBox(height: 18.h),
            InkWell(
              onTap: () {
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.r)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextWidget(
                              text: 'dailygoal'.tr,
                              fontSize: 28.sp,
                              fontFamily: 'B',
                              color: Theme.of(context).textTheme.titleMedium!.color,
                              textAlign: TextAlign.center),
                          SizedBox(height: 26.h),
                          Obx(() {
                            return ListTile(
                              tileColor: transparentColor,
                              onTap: () {
                                ep.isCustom.value = !ep.isCustom.value;
                              },
                              title: TextWidget(
                                  text: 'recommend'.tr, fontSize: 15.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
                              trailing: !ep.isCustom.value
                                  ? SvgPicture.asset('assets/icons/done.svg')
                                  : Icon(Icons.radio_button_off_rounded, color: Theme.of(context).iconTheme.color),
                              subtitle: TextWidget(
                                  text: '${ep.map[ep.goal.value]} ${ep.goal.value}',
                                  fontSize: 15.sp,
                                  fontFamily: 'SM',
                                  color: Theme.of(context).textTheme.titleMedium!.color),
                            );
                          }),
                          SizedBox(height: 17.h),
                          Obx(() {
                            return ListTile(
                              onTap: () {
                                ep.isCustom.value = !ep.isCustom.value;
                              },
                              tileColor: transparentColor,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                      text: 'custom'.tr, fontSize: 15.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
                                  ep.isCustom.value
                                      ? SvgPicture.asset('assets/icons/done.svg')
                                      : Icon(Icons.radio_button_off_rounded, color: Theme.of(context).iconTheme.color),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: ep.goalnumber,
                                      readOnly: !ep.isCustom.value,
                                      cursorColor: Theme.of(context).textTheme.titleMedium!.color,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(ep.goalIndex.value == 0
                                            ? 5
                                            : ep.goalIndex.value == 1
                                                ? 2
                                                : 4)
                                      ],
                                      textInputAction: TextInputAction.done,
                                      style: TextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
                                      onChanged: (v) {
                                        ep.goalnumber.value = ep.goalnumber.value.copyWith(text: '$v ${ep.goal.value}');
                                      },
                                      keyboardType:
                                          Platform.isIOS ? const TextInputType.numberWithOptions(signed: true, decimal: false) : TextInputType.number,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                                        enabledBorder:
                                            UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                                        focusedBorder:
                                            UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                                        disabledBorder:
                                            UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                                        errorBorder:
                                            UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).textTheme.titleMedium!.color!)),
                                      ),
                                    ),
                                  ),
                                  TextWidget(
                                      text: ep.goal.value, fontSize: 15.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color),
                                ],
                              ),
                            );
                          }),
                          SizedBox(height: 25.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      ep.goalnumber.clear();
                                      Get.back();
                                    },
                                    child: Container(
                                      height: 43.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: transparentColor,
                                          borderRadius: BorderRadius.circular(15.r),
                                          border: Border.all(color: greyColor.withOpacity(0.4), width: 1.w)),
                                      child: TextWidget(
                                          text: 'cancel'.tr,
                                          fontSize: 13.sp,
                                          fontFamily: 'M',
                                          color: Theme.of(context).textTheme.titleMedium!.color,
                                          textAlign: TextAlign.center),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                    child: ButtonWidget(
                                        title: 'save'.tr,
                                        onTap: () {
                                          if (ep.goalnumber.text.isNotEmpty && ep.isCustom.value) {
                                            ep.fixWater.value = ep.goalnumber.text.replaceAll(ep.goal.value, '');
                                            ep.isCustom.value = false;
                                            ep.goalnumber.clear();
                                          } else {
                                            ep.fixWater.value = ep.map[ep.goal.value];
                                          }

                                          Get.back();
                                        },
                                        height: 43.h,
                                        fontFamily: 'M',
                                        fontSize: 13.sp)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  barrierDismissible: false,
                );
              },
              child: Container(
                height: 40.h,
                width: 121.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: greyColor.withOpacity(0.2), borderRadius: BorderRadius.circular(12.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/edit.svg'),
                    SizedBox(width: 10.w),
                    TextWidget(text: 'adjust'.tr, fontSize: 15.sp, fontFamily: 'SM', color: textColor, textAlign: TextAlign.center)
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),
            Lottie.asset('assets/lottie/Rain.json', height: 200.h, width: 200.w),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: ButtonWidget(
                title: 'setgoal'.tr,
                onTap: () async {
                  // if (int.parse(ep.fixWater.value) >= drinkWater.value) {
                  await AllApi().profileUpdateApi(
                      gender: gender.value,
                      genderIndex: genderIndex.value,
                      weight: weight.value,
                      weightNumber: weightNumber.value,
                      weather: weather.value,
                      firstName: ep.profileFirstName.text,
                      lastName: ep.profileLastName.text,
                      flagCode: ep.country.value,
                      number: ep.profileNumber.text,
                      waterType: ep.goal.value,
                      waterNumber: convertWater(int.parse(ep.fixWater.value), ep.goal.value),
                      dob: ep.profileDate.text,
                      image: ep.profileImage);
                  await AllApi().goalUpdateApi(goal: convertWater(int.parse(ep.fixWater.value), ep.goal.value), date: DateTime.now().toString());
                  showToast(message: 'dailygoalupdate'.tr);
                  await getProfileData();
                },
                //  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
