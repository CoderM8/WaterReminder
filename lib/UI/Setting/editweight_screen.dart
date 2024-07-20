import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/editprofile_controller.dart';
import 'package:water_tracker/Services/api.dart';

class EditWeightScreen extends StatelessWidget {
  EditWeightScreen({super.key});

  final EditProfileController ep = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('weight'.tr,context),
      body: Column(
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(text: '${'yourweight'.tr} :', fontSize: 15.sp, fontFamily: 'B', color: Theme.of(context).textTheme.titleMedium!.color, textAlign: TextAlign.center),
                Obx(() {
                  return TextWidget(
                      text: '${weightNumber.value.toString()} ${weight.value}', fontSize: 15.sp, fontFamily: 'SM', color: Theme.of(context).textTheme.titleMedium!.color, textAlign: TextAlign.center);
                }),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          TextWidget(
              text: 'weightdescription'.tr,
              fontSize: 12.sp,
              fontFamily: 'R',
              color: textColor,
              textAlign: TextAlign.center),
          SizedBox(height: 30.h),
          ListView.separated(
            itemCount: ep.weightList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemBuilder: (BuildContext context, int index) {
              return Obx(() {
                return InkWell(
                  onTap: () {
                    ep.weightIndex.value = index;
                    ep.weight.value = ep.weightList[index].title;
                  },
                  child: Container(
                    height: 60.h,
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                        color: ep.weightIndex.value == index ? lightBlueColor.withOpacity(0.2) : greyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15.r),
                        border: Border.all(width: 1.w, color: ep.weightIndex.value == index ? lightBlueColor : textColor.withOpacity(0.5))),
                    child: Row(
                      children: [
                        TextWidget(
                            text: ep.weightList[index].title,
                            fontSize: 12.sp,
                            fontFamily: ep.weightIndex.value == index ? 'B' : 'M',
                            color: ep.weightIndex.value == index ? blueColor : textColor,
                            textAlign: TextAlign.center),
                        const Spacer(),
                        if (ep.weightIndex.value == index) SvgPicture.asset('assets/icons/done.svg'),
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
            ep.weightIndex.value;
            return

              CarouselSlider.builder(
                itemCount: ep.weightIndex.value == 0 ? ep.kgList.length : ep.lbsList.length,
                carouselController: ep.weightIndex.value == 0 ? ep.kgController : ep.lbsController,
                options: CarouselOptions(
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.2,
                  initialPage: ep.weightIndex.value == 0 ? ep.kgIndex.value : ep.lbsIndex.value,
                  enableInfiniteScroll: true,
                  reverse: false,
                  enlargeFactor: 0.3,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index, reason) {
                    if (ep.weightIndex.value == 0) {
                      ep.kgIndex.value = index;
                      ep.weightNumber.value = ep.kgList[index];
                    } else {
                      ep.lbsIndex.value = index;
                      ep.weightNumber.value = ep.lbsList[index];
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
                                color: ep.weightIndex.value == 0
                                    ? ep.kgIndex.value == itemIndex
                                    ? blueColor
                                    : transparentColor
                                    : ep.lbsIndex.value == itemIndex
                                    ? blueColor
                                    : transparentColor,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Center(
                                child: TextWidget(
                                  text: ep.weightIndex.value == 0
                                      ? ep.kgIndex.value == itemIndex
                                      ? '${ep.kgList[itemIndex]} Kg'
                                      : ep.kgList[itemIndex].toString()
                                      : ep.lbsIndex.value == itemIndex
                                      ? '${ep.lbsList[itemIndex]} lbs'
                                      : ep.lbsList[itemIndex].toString(),
                                  textAlign: TextAlign.center,
                                  color: ep.weightIndex.value == 0
                                      ? ep.kgIndex.value == itemIndex
                                      ? whiteColor
                                      : Theme.of(context).textTheme.titleMedium!.color
                                      : ep.lbsIndex.value == itemIndex
                                      ? whiteColor
                                      : Theme.of(context).textTheme.titleMedium!.color,
                                  fontFamily: ep.weightIndex.value == 0
                                      ? ep.kgIndex.value == itemIndex
                                      ? 'B'
                                      : 'M'
                                      : ep.lbsIndex.value == itemIndex
                                      ? 'B'
                                      : 'M',
                                ))));
                  });
                },
              );
            // : CarouselSlider.builder(
            //     itemCount: ep.lbsList.length,
            //     carouselController: ep.lbsController,
            //     options: CarouselOptions(
            //       aspectRatio: 16 / 9,
            //       viewportFraction: 0.2,
            //       initialPage: ep.lbsIndex.value,
            //       enableInfiniteScroll: true,
            //       reverse: false,
            //       enlargeFactor: 0.3,
            //       scrollDirection: Axis.vertical,
            //       onPageChanged: (index, reason) {
            //         ep.lbsIndex.value = ep.lbsList[index];
            //       },
            //     ),
            //     itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
            //       return Center(
            //           child: Container(
            //               height: 40.h,
            //               width: 106.w,
            //               decoration: BoxDecoration(
            //                   color: ep.lbsIndex.value == ep.lbsList[itemIndex] ? blueColor : transparentColor,
            //                   borderRadius: BorderRadius.circular(10.r)),
            //               child: Center(
            //                   child: TextWidget(
            //                 text: ep.lbsIndex.value == ep.lbsList[itemIndex] ? '${ep.lbsList[itemIndex]} lbs' : ep.lbsList[itemIndex].toString(),
            //                 textAlign: TextAlign.center,
            //                 color: ep.lbsIndex.value == ep.lbsList[itemIndex] ? whiteColor : blackColor,
            //                 fontFamily: ep.lbsIndex.value == ep.lbsList[itemIndex] ? 'B' : 'M',
            //               ))));
            //     },
            //   );
          }),
          SizedBox(height: 40.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: ButtonWidget(
                title: 'update'.tr,
                onTap: () async {
                  await AllApi().profileUpdateApi(
                      gender: gender.value,
                      genderIndex: genderIndex.value,
                      weight: ep.weight.value,
                      weightNumber: ep.weightNumber.value,
                      weather: weather.value,
                      firstName: ep.profileFirstName.text,
                      lastName: ep.profileLastName.text,
                      flagCode: ep.country.value,
                      number: ep.profileNumber.text,
                      waterType: waterType.value,
                      waterNumber: waterNumber.value,
                      dob: ep.profileDate.text,
                      image: ep.profileImage);
                  showToast(message: 'weightupdate'.tr);
                  await getProfileData();
                }),
          ),
        ],
      ),
    );
  }
}
