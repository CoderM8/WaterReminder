// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/editprofile_controller.dart';
import 'package:water_tracker/Services/api.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController ep = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('profile'.tr,context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: Obx(() {
                      ep.isSelect.value;
                      return ep.profileImage != null
                          ? Image.file(
                              File(ep.profileImage!.path),
                              height: 130.w,
                              width: 130.w,
                              alignment: Alignment.topCenter,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              image.value,
                              height: 130.w,
                              width: 130.w,
                              fit: BoxFit.cover,
                            );
                    })),
                Positioned(
                  right: 8.w,
                  child: InkWell(
                    onTap: () {
                      ep.pickImage();
                    },
                    child: Container(
                        height: 28.w,
                        width: 28.w,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(color: blueColor, shape: BoxShape.circle),
                        child: SvgPicture.asset('assets/icons/camera.svg')),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Form(
                key: ep.editProfileKey,
                child: Column(
                  children: [
                    TextFieldWidget(
                      controller: ep.profileFirstName,
                      hint: 'firstname'.tr,
                      textInputAction: TextInputAction.next,
                      validation: (v) {
                        if (v == null || v.isEmpty) {
                          return 'firstnameempty'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    TextFieldWidget(
                      controller: ep.profileLastName,
                      textInputAction: TextInputAction.next,
                      hint: 'lastname'.tr,
                      validation: (v) {
                        if (v == null || v.isEmpty) {
                          return 'lastnameempty'.tr;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    TextFieldWidget(
                      controller: ep.profileEmail,
                      hint: 'email'.tr,
                      enabled: false,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return 'emailempty'.tr;
                        }
                        String pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value)) {
                          return 'entervalidemail'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    TextFieldWidget(
                      controller: ep.profileDate,
                      readonly: true,
                      hint: 'dateofbirth'.tr,
                      suffixIcon: InkWell(
                        onTap: () {
                          ep.pickDate(context);
                        },
                        child: SvgPicture.asset(
                          'assets/icons/calendar.svg',
                          height: 24.w,
                          width: 24.w,
                          fit: BoxFit.scaleDown,color: Theme.of(context).iconTheme.color
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    IntlPhoneField(
                      decoration: InputDecoration(
                        hintText: 'phonenumber'.tr,
                        counterStyle: TextStyle(fontSize: 0.sp),
                        hintStyle: TextStyle(
                          color: textColor,
                          fontFamily: 'R',
                          fontSize: 16.sp,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: greyColor, width: 1.w),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: blueColor, width: 1.w),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: redColor, width: 1.w),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(color: redColor, width: 1.w),
                        ),
                      ),
                      initialCountryCode: ep.country.value,
                      showDropdownIcon: false,
                      flagsButtonPadding: EdgeInsets.only(left: 10.w),
                      pickerDialogStyle: PickerDialogStyle(
                        searchFieldInputDecoration: const InputDecoration(
                            border:  OutlineInputBorder(borderSide: BorderSide(color: blueColor)),
                            disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blueColor)),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blueColor))),
                        countryCodeStyle: TextStyle(fontSize: 16.sp, color: blackColor),
                        countryNameStyle: TextStyle(fontSize: 16.sp, color: blackColor),
                      ),
                      textInputAction: TextInputAction.done,
                      keyboardType: Platform.isIOS ? const TextInputType.numberWithOptions(signed: true) : TextInputType.number,
                      dropdownTextStyle: TextStyle(fontSize: 16.sp),
                      controller: ep.profileNumber,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: TextStyle(fontSize: 16.sp),
                      validator: (v) {
                        if (v == null || v.number.isEmpty) {
                          return 'numberempty'.tr;
                        }
                        return null;
                      },
                      onCountryChanged: (v) {
                        ep.country.value = v.code;
                      },
                    ),
                    SizedBox(height: 20.h),
                    ButtonWidget(
                        title: 'update'.tr,
                        onTap: () async {
                          if (ep.editProfileKey.currentState!.validate()) {
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
                            showToast(message: 'profileupdate'.tr);
                            await getProfileData();
                            Get.back();
                          }
                        }),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
