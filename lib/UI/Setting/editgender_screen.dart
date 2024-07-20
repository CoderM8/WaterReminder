import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/editprofile_controller.dart';
import 'package:water_tracker/Services/api.dart';

class EditGenderScreen extends StatelessWidget {
  EditGenderScreen({super.key});

  final EditProfileController ep = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('gender'.tr,context),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            TextWidget(text: 'gendertitle'.tr, fontSize: 18.sp, fontFamily: 'SM'),
            SizedBox(height: 5.h),
            TextWidget(
                text: 'genderdescription'.tr,
                fontSize: 12.sp,
                fontFamily: 'R',
                color: textColor,
                textAlign: TextAlign.center),
            SizedBox(height: 30.h),
            ListView.separated(
              itemCount: ep.genderList.length,shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Obx(() {
                  return InkWell(
                    onTap: () {
                      genderIndex.value = index;
                      gender.value = ep.genderList[index].title;
                    },
                    child: Container(
                      height: 60.h,
                      width: width,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                          color: genderIndex.value == index ? lightBlueColor.withOpacity(0.2) : greyColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(width: 1.w, color: genderIndex.value == index ? lightBlueColor : textColor.withOpacity(0.5))),
                      child: Row(
                        children: [
                          SvgPicture.asset(ep.genderList[index].image!, color: genderIndex.value == index ? blueColor : greyColor),
                          SizedBox(width: 16.w),
                          TextWidget(
                              text: ep.genderList[index].title,
                              fontSize: 12.sp,
                              fontFamily: genderIndex.value == index ? 'B' : 'M',
                              color: genderIndex.value == index ? blueColor : textColor,
                              textAlign: TextAlign.center),
                          const Spacer(),
                          if (genderIndex.value == index) SvgPicture.asset('assets/icons/done.svg'),
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
            ButtonWidget(
                title: 'update'.tr,
                onTap: () async {
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
                      waterType: waterType.value,
                      waterNumber: waterNumber.value,
                      dob: ep.profileDate.text,
                      image: ep.profileImage);
                  showToast(message: 'genderupdate'.tr);
                  await getProfileData();
                }),
          ],
        ),
      ),
    );
  }
}
