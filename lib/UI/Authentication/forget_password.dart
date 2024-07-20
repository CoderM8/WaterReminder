import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Services/api.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final TextEditingController forgetEmail = TextEditingController();
  final GlobalKey<FormState> forgetKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 50.h, left: 20.w, right: 20.w),
          child: Form(
            key: forgetKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(Icons.arrow_back_rounded, size: 24.sp, color: Theme.of(context).appBarTheme.iconTheme!.color)),
                SizedBox(height: 20.h),
                TextWidget(
                  text: 'forgetpassword'.tr,
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                  fontSize: 25.sp,
                  fontFamily: 'B',
                ),
                TextWidget(
                  text: 'getnewpassword'.tr,
                  color: Theme.of(context).appBarTheme.iconTheme!.color,
                  fontSize: 16.sp,
                ),
                SizedBox(height: 35.h),
                Center(child: Image.asset('assets/images/forgetpassword.jpg', height: 164.sp, width: 180.w)),
                SizedBox(height: 40.h),
                TextFieldWidget(
                  controller: forgetEmail,
                  hint: 'enteremail'.tr,
                  textInputAction: TextInputAction.done,
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
                SizedBox(height: 30.h),
                ButtonWidget(
                    title: 'send'.tr,
                    onTap: () async {
                      if (forgetKey.currentState!.validate()) {
                        await AllApi().forgetPasswordApi(email: forgetEmail.text).then((value) {
                          if (value['WATER_REMIND'][0]['success'] == '1') {
                            showToast(message: value['WATER_REMIND'][0]['msg']);
                          }
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
