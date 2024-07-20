// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/onboarding_controller.dart';
import 'package:water_tracker/Services/api.dart';
import 'package:water_tracker/UI/Authentication/login_screen.dart';

Container buildDot(bool index) {
  return Container(
    margin: EdgeInsets.only(right: 5.w),
    height: 6.w,
    width: 23.w,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.r),
      color: index ? blueColor : lightBlueColor,
    ),
  );
}

class OnboardingScreen extends StatelessWidget {
  final OnboardingController oc = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: 33.h),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: oc.controller,
                onPageChanged: (int index) {
                  oc.currentIndex.value = index;
                },
                children: [Gender(oc: oc), Weight(oc: oc), Weather(oc: oc), Goal(oc: oc)],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Obx(() {
                return Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(4, (index) => buildDot(oc.currentIndex.value == index))),
                    SizedBox(height: 20.h),
                    ButtonWidget(
                      title: oc.currentIndex.value == 4 - 1 ? 'complete'.tr : 'next'.tr,
                      onTap: () async {
                        if (oc.currentIndex.value == 4 - 1) {
                          await AllApi()
                              .registerApi(
                                  email: oc.email.text,
                                  password: oc.password.text,
                                  gender: oc.gender.value,
                                  genderIndex: oc.genderIndex.value,
                                  weight: oc.weight.value,
                                  weightNumber: oc.weightNumber.value,
                                  weather: oc.weather.value,
                                  firstname: oc.firstName.text,
                                  lastName: oc.lastName.text,
                                  flagCode: oc.country.value,
                                  number: oc.number.text,
                                  waterType: oc.goal.value,
                                  waterNumber: convertWater(int.parse(oc.fixWater.value), oc.goal.value),
                                  dob: oc.date.text,
                                  image: oc.image)
                              .then((value) {
                            if (value["WATER_REMIND"][0]["success"] == "1") {
                              Get.offAll(() => LoginScreen(isLogin: true));
                            }
                          });
                        } else {
                          oc.controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
                        }
                      },
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class Gender extends StatelessWidget {
  const Gender({super.key, required this.oc});

  final OnboardingController oc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 90.h),
        TextWidget(text: 'gendertitle'.tr, fontSize: 18.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color),
        SizedBox(height: 5.h),
        TextWidget(text: 'genderdescription'.tr, fontSize: 12.sp, fontFamily: 'R', color: textColor, textAlign: TextAlign.center),
        SizedBox(height: 30.h),
        Expanded(
          child: ListView.separated(
            itemCount: oc.genderList.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemBuilder: (BuildContext context, int index) {
              return Obx(() {
                return InkWell(
                  onTap: () {
                    oc.genderIndex.value = index;
                    oc.gender.value = oc.genderList[index].title;
                  },
                  child: Container(
                    height: 60.h,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                        color: oc.genderIndex.value == index ? lightBlueColor.withOpacity(0.2) : greyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(width: 1.w, color: oc.genderIndex.value == index ? lightBlueColor : textColor.withOpacity(0.5))),
                    child: Row(
                      children: [
                        SvgPicture.asset(oc.genderList[index].image!, color: oc.genderIndex.value == index ? blueColor : greyColor),
                        SizedBox(width: 16.w),
                        TextWidget(
                            text: oc.genderList[index].title,
                            fontSize: 12.sp,
                            fontFamily: oc.genderIndex.value == index ? 'B' : 'M',
                            color: oc.genderIndex.value == index ? blueColor : textColor,
                            textAlign: TextAlign.center),
                        const Spacer(),
                        if (oc.genderIndex.value == index) SvgPicture.asset('assets/icons/done.svg'),
                      ],
                    ),
                  ),
                );
              });
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 15.h);
            },
          ),
        ),
      ],
    );
  }
}

class Weight extends StatelessWidget {
  const Weight({super.key, required this.oc});

  final OnboardingController oc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 90.h),
        TextWidget(text: 'weighttitle'.tr, fontSize: 18.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color),
        SizedBox(height: 5.h),
        TextWidget(text: 'weightdescription'.tr, fontSize: 12.sp, fontFamily: 'R', color: textColor, textAlign: TextAlign.center),
        SizedBox(height: 30.h),
        ListView.separated(
          itemCount: oc.weightList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemBuilder: (BuildContext context, int index) {
            return Obx(() {
              return InkWell(
                onTap: () {
                  oc.weightIndex.value = index;
                  oc.weight.value = oc.weightList[index].title;
                },
                child: Container(
                  height: 60.h,
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: oc.weightIndex.value == index ? lightBlueColor.withOpacity(0.2) : greyColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15.r),
                      border: Border.all(width: 1.w, color: oc.weightIndex.value == index ? lightBlueColor : textColor.withOpacity(0.5))),
                  child: Row(
                    children: [
                      TextWidget(
                          text: oc.weightList[index].title,
                          fontSize: 12.sp,
                          fontFamily: oc.weightIndex.value == index ? 'B' : 'M',
                          color: oc.weightIndex.value == index ? blueColor : textColor,
                          textAlign: TextAlign.center),
                      const Spacer(),
                      if (oc.weightIndex.value == index) SvgPicture.asset('assets/icons/done.svg'),
                    ],
                  ),
                ),
              );
            });
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 15.h);
          },
        ),
        SizedBox(height: 40.h),
        Obx(() {
          oc.weightIndex.value;
          return CarouselSlider.builder(
            itemCount: oc.weightIndex.value == 0 ? oc.kgList.length : oc.lbsList.length,
            carouselController: oc.weightIndex.value == 0 ? oc.kgController : oc.lbsController,
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              viewportFraction: 0.2,
              initialPage: oc.weightIndex.value == 0 ? oc.kgIndex.value : oc.lbsIndex.value,
              enableInfiniteScroll: true,
              reverse: false,
              enlargeFactor: 0.3,
              scrollDirection: Axis.vertical,
              onPageChanged: (index, reason) {
                if (oc.weightIndex.value == 0) {
                  oc.kgIndex.value = index;
                  oc.weightNumber.value = oc.kgList[index];
                } else {
                  oc.lbsIndex.value = index;
                  oc.weightNumber.value = oc.lbsList[index];
                }
              },
            ),
            itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
              return Obx(() {
                return Center(
                    child: Container(
                        height: 40.h,
                        width: 106.w,
                        decoration: BoxDecoration(
                            color: oc.weightIndex.value == 0
                                ? oc.kgIndex.value == itemIndex
                                    ? blueColor
                                    : transparentColor
                                : oc.lbsIndex.value == itemIndex
                                    ? blueColor
                                    : transparentColor,
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Center(
                            child: TextWidget(
                          text: oc.weightIndex.value == 0
                              ? oc.kgIndex.value == itemIndex
                                  ? '${oc.kgList[itemIndex]} Kg'
                                  : oc.kgList[itemIndex].toString()
                              : oc.lbsIndex.value == itemIndex
                                  ? '${oc.lbsList[itemIndex]} lbs'
                                  : oc.lbsList[itemIndex].toString(),
                          textAlign: TextAlign.center,
                          color: oc.weightIndex.value == 0
                              ? oc.kgIndex.value == itemIndex
                                  ? whiteColor
                                  : Theme.of(context).textTheme.titleMedium!.color
                              : oc.lbsIndex.value == itemIndex
                                  ? whiteColor
                                  : Theme.of(context).textTheme.titleMedium!.color,
                          fontFamily: oc.weightIndex.value == 0
                              ? oc.kgIndex.value == itemIndex
                                  ? 'B'
                                  : 'M'
                              : oc.lbsIndex.value == itemIndex
                                  ? 'B'
                                  : 'M',
                        ))));
              });
            },
          );
        }),
      ],
    );
  }
}

class Weather extends StatelessWidget {
  const Weather({super.key, required this.oc});

  final OnboardingController oc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 90.h),
        TextWidget(text: 'weathertitle'.tr, fontSize: 18.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color),
        SizedBox(height: 5.h),
        TextWidget(text: 'weatherdescription'.tr, fontSize: 12.sp, fontFamily: 'R', color: textColor, textAlign: TextAlign.center),
        SizedBox(height: 30.h),
        Expanded(
          child: ListView.separated(
            itemCount: oc.weatherList.length,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemBuilder: (BuildContext context, int index) {
              return Obx(() {
                return InkWell(
                  onTap: () {
                    oc.weatherIndex.value = index;
                    oc.weather.value = oc.weatherList[index].title;
                  },
                  child: Container(
                    height: 60.h,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                        color: oc.weatherIndex.value == index ? lightBlueColor.withOpacity(0.2) : greyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(width: 1.w, color: oc.weatherIndex.value == index ? lightBlueColor : textColor.withOpacity(0.5))),
                    child: Row(
                      children: [
                        SvgPicture.asset(oc.weatherList[index].image!, color: oc.weatherIndex.value == index ? blueColor : greyColor),
                        SizedBox(width: 16.w),
                        TextWidget(
                            text: oc.weatherList[index].title,
                            fontSize: 12.sp,
                            fontFamily: oc.weatherIndex.value == index ? 'B' : 'M',
                            color: oc.weatherIndex.value == index ? blueColor : textColor,
                            textAlign: TextAlign.center),
                        const Spacer(),
                        if (oc.weatherIndex.value == index) SvgPicture.asset('assets/icons/done.svg'),
                      ],
                    ),
                  ),
                );
              });
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 15.h);
            },
          ),
        ),
      ],
    );
  }
}

class Goal extends StatelessWidget {
  const Goal({super.key, required this.oc});

  final OnboardingController oc;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 90.h),
          TextWidget(text: 'goaltitle'.tr, fontSize: 18.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color),
          SizedBox(height: 5.h),
          TextWidget(text: 'goaldescription'.tr, fontSize: 12.sp, fontFamily: 'R', color: textColor, textAlign: TextAlign.center),
          SizedBox(height: 30.h),
          SizedBox(
            height: 40.h,
            child: ListView.separated(
              itemCount: oc.goalList.length,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemBuilder: (BuildContext context, int index) {
                return Obx(() {
                  return InkWell(
                    onTap: () {
                      oc.goalIndex.value = index;
                      oc.goal.value = oc.goalList[index].title;
                      oc.fixWater.value = oc.map[oc.goal.value];
                    },
                    child: Container(
                      height: 40.h,
                      width: 72.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                          color: oc.goalIndex.value == index ? lightBlueColor.withOpacity(0.2) : greyColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(width: 1.w, color: oc.goalIndex.value == index ? lightBlueColor : textColor.withOpacity(0.5))),
                      child: TextWidget(
                          text: oc.goalList[index].title,
                          fontSize: 12.sp,
                          fontFamily: oc.goalIndex.value == index ? 'B' : 'M',
                          color: oc.goalIndex.value == index ? blueColor : textColor,
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
            oc.goal.value;
            return TextWidget(
                text: '${oc.fixWater.value} ${oc.goal.value}',
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
                            onTap: () {
                              oc.isCustom.value = !oc.isCustom.value;
                            },
                            title: TextWidget(
                                text: 'recommend'.tr, fontSize: 15.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
                            trailing: !oc.isCustom.value
                                ? SvgPicture.asset('assets/icons/done.svg')
                                : Icon(Icons.radio_button_off_rounded, color: Theme.of(context).iconTheme.color),
                            subtitle: TextWidget(
                                text: '${oc.map[oc.goal.value]} ${oc.goal.value}',
                                fontSize: 15.sp,
                                fontFamily: 'SM',
                                color: Theme.of(context).textTheme.titleMedium!.color),
                          );
                        }),
                        SizedBox(height: 17.h),
                        Obx(() {
                          return ListTile(
                            onTap: () {
                              oc.isCustom.value = !oc.isCustom.value;
                            },
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    text: 'custom'.tr, fontSize: 15.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
                                oc.isCustom.value
                                    ? SvgPicture.asset('assets/icons/done.svg')
                                    : Icon(Icons.radio_button_off_rounded, color: Theme.of(context).iconTheme.color),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: oc.goalnumber,
                                    readOnly: !oc.isCustom.value,
                                    cursorColor: Theme.of(context).textTheme.titleMedium!.color,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(oc.goalIndex.value == 0
                                          ? 5
                                          : oc.goalIndex.value == 1
                                              ? 2
                                              : 4)
                                    ],
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(color: Theme.of(context).textTheme.titleMedium!.color),
                                    onChanged: (v) {
                                      oc.goalnumber.value = oc.goalnumber.value.copyWith(text: '$v ${oc.goal.value}');
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
                                    text: oc.goal.value, fontSize: 15.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color),
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
                                    oc.goalnumber.clear();
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
                                        if (oc.goalnumber.text.isNotEmpty && oc.isCustom.value) {
                                          oc.fixWater.value = oc.goalnumber.text.replaceAll(oc.goal.value, '');
                                          oc.isCustom.value = false;
                                          oc.goalnumber.clear();
                                        } else {
                                          oc.fixWater.value = oc.map[oc.goal.value];
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
                  TextWidget(text: 'Adjust', fontSize: 15.sp, fontFamily: 'SM', color: textColor, textAlign: TextAlign.center)
                ],
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Lottie.asset('assets/lottie/Rain.json', height: 200.h, width: 200.w),
        ],
      ),
    );
  }
}
