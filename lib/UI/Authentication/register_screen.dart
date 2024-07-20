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
import 'package:water_tracker/Controller/onboarding_controller.dart';
import 'package:water_tracker/UI/onboarding_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final OnboardingController oc = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: TextWidget(text: 'Register', fontSize: 22.sp, fontFamily: 'SM', color: Colors.black),
      //   automaticallyImplyLeading: false,
      //  // toolbarHeight: 80.h,
      //   centerTitle: true,
      //   // flexibleSpace: Container(
      //   //   decoration: const BoxDecoration(
      //   //     image: DecorationImage(
      //   //       image: AssetImage('assets/images/appbarwave.png'),
      //   //       fit: BoxFit.cover,
      //   //     ),
      //   //   ),
      //   // ),
      //   backgroundColor: Colors.transparent,
      // ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                  height: 240.h,
                  color: transparentColor,
                  alignment: AlignmentDirectional.topStart,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Image.asset('assets/images/settingwave.png', width: width, height: 195.h, fit: BoxFit.fill),
                      Padding(
                        padding: EdgeInsets.only(bottom: 35.h),
                        child: TextWidget(text: 'register'.tr, fontSize: 22.sp, fontFamily: 'SM', color: whiteColor),
                      ),
                    ],
                  )),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Obx(() {
                        oc.isSelect.value;
                        return oc.image != null
                            ? Image.file(
                                File(oc.image!.path),
                                height: 130.w,
                                width: 130.w,
                                alignment: Alignment.topCenter,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/profile.png',
                                height: 130.w,
                                width: 130.w,
                                fit: BoxFit.fill,
                              );
                      })),
                  Positioned(
                    right: 8.w,
                    child: InkWell(
                      onTap: () {
                        oc.pickImage();
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
            ],
          ),
          SizedBox(height: 35.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Form(
                      key: oc.profileKey,
                      child: Column(
                        children: [
                          TextFieldWidget(
                            controller: oc.firstName,
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
                            controller: oc.lastName,
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
                            controller: oc.email,
                            hint: 'email'.tr,
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
                          Obx(() {
                            return TextFieldWidget(
                              controller: oc.password,
                              hint: 'password'.tr,
                              obse: oc.passwordVisible.value,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  oc.passwordVisible.value = !oc.passwordVisible.value;
                                },
                                icon: Icon(
                                  !oc.passwordVisible.value ? Icons.visibility : Icons.visibility_off,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              validation: (value) {
                                if (value!.isEmpty) {
                                  return 'passwordempty'.tr;
                                }
                                if (value.length <= 5) {
                                  return 'entervalidpassword'.tr;
                                }
                                return null;
                              },
                            );
                          }),
                          SizedBox(height: 20.h),
                          TextFieldWidget(
                            controller: oc.date,
                            readonly: true,
                            hint: 'dateofbirth'.tr,
                            suffixIcon: InkWell(
                              onTap: () {
                                oc.pickDate(context);
                              },
                              child: SvgPicture.asset('assets/icons/calendar.svg',
                                  height: 24.w, width: 24.w, fit: BoxFit.scaleDown, color: Theme.of(context).iconTheme.color),
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
                            initialCountryCode: 'US',
                            showDropdownIcon: false,
                            flagsButtonPadding: EdgeInsets.only(left: 10.w),
                            pickerDialogStyle: PickerDialogStyle(
                              searchFieldInputDecoration: const InputDecoration(
                                  border: OutlineInputBorder(borderSide: BorderSide(color: blueColor)),
                                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blueColor)),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: blueColor))),
                              countryCodeStyle: TextStyle(fontSize: 16.sp, color: Theme.of(context).textTheme.titleMedium!.color),
                              countryNameStyle: TextStyle(fontSize: 16.sp, color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: Platform.isIOS ? const TextInputType.numberWithOptions(signed: true) : TextInputType.number,
                            dropdownTextStyle: TextStyle(fontSize: 16.sp),
                            controller: oc.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            style: TextStyle(fontSize: 16.sp),
                            validator: (v) {
                              if (v == null || v.number.isEmpty) {
                                return 'numberempty'.tr;
                              }
                              return null;
                            },
                            onCountryChanged: (v) {
                              oc.country.value = v.code;
                            },
                          ),
                          SizedBox(height: 20.h),
                          ButtonWidget(
                              title: 'register'.tr,
                              onTap: () {
                                if (oc.profileKey.currentState!.validate()) {
                                  Get.to(() => OnboardingScreen());
                                }
                              }),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextWidget(
                                  text: 'alreadyaccount'.tr,
                                  fontSize: 12.sp,
                                  fontFamily: 'SM',
                                  textAlign: TextAlign.center,
                                  color: greyColor),
                              SizedBox(width: 5.w),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: TextWidget(
                                    text: 'login'.tr,
                                    fontSize: 14.sp,
                                    fontFamily: 'SM',color: Theme.of(context).textTheme.titleMedium!.color,
                                    textAlign: TextAlign.center,
                                    textDecoration: TextDecoration.underline,
                                  )),
                            ],
                          ),
                          SizedBox(height: 30.h)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
