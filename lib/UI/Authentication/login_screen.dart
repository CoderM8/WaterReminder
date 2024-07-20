import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/login_controller.dart';
import 'package:water_tracker/Services/api.dart';
import 'package:water_tracker/UI/Authentication/forget_password.dart';
import 'package:water_tracker/UI/Authentication/register_screen.dart';
import 'package:water_tracker/UI/Bottom/bottom_screen.dart';
import 'package:water_tracker/UI/complete_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key, this.isLogin = false});

  bool? isLogin;

  final LoginController lc = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(text: 'login'.tr, fontSize: 22.sp, fontFamily: 'SM', color: whiteColor),
        automaticallyImplyLeading: false,
        toolbarHeight: 80.h,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/appbarwave.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: transparentColor,
      ),
      body: Obx(() {
        return ModalProgressHUD(
          inAsyncCall: isLoginProgress.value,
          progressIndicator: const CircularProgressIndicator(color: blueColor),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Form(
                      key: lc.loginKey,
                      child: Column(
                        children: [
                          TextFieldWidget(
                            controller: lc.email,
                            hint: 'enteremail'.tr,
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
                              controller: lc.password,
                              hint: 'enterpassword'.tr,
                              obse: !lc.passwordVisible.value,
                              textInputAction: TextInputAction.done,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  lc.passwordVisible.value = !lc.passwordVisible.value;
                                },
                                icon: Icon(
                                  !lc.passwordVisible.value ? Icons.visibility : Icons.visibility_off,
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
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Get.to(() => ForgetPasswordScreen());
                                  },
                                  child: TextWidget(
                                      text: '${'forgetpassword'.tr}?',
                                      fontSize: 13.sp,
                                      fontFamily: 'SM',
                                      color: Theme.of(context).textTheme.titleMedium!.color)),
                            ],
                          ),
                          SizedBox(height: 30.h),
                          ButtonWidget(
                              title: 'login'.tr,
                              onTap: () async {
                                if (lc.loginKey.currentState!.validate()) {
                                  if (isLogin == true) {
                                    await AllApi().loginApi(email: lc.email.text, password: lc.password.text).then((value) async {
                                      if (value["WATER_REMIND"][0]["success"] == "1") {
                                        await box.write('userID', value["WATER_REMIND"][0]["user_id"]);
                                        await getUserId();
                                        Get.to(() => const CompleteScreen());
                                      } else {
                                        showToast(message: value["WATER_REMIND"][0]["MSG"]);
                                      }
                                    });
                                  } else {
                                    await AllApi().loginApi(email: lc.email.text, password: lc.password.text).then((value) async {
                                      if (value["WATER_REMIND"][0]["success"] == "1") {
                                        await box.write('userID', value["WATER_REMIND"][0]["user_id"]);
                                        await getUserId();
                                        await getProfileData();
                                        showToast(message: value["WATER_REMIND"][0]["MSG"]);
                                        Get.offAll(() => BottomScreen());
                                      } else {
                                        showToast(message: value["WATER_REMIND"][0]["MSG"]);
                                      }
                                    });
                                  }
                                }
                              }),
                        ],
                      )),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget(text: 'createaccount'.tr, fontSize: 12.sp, fontFamily: 'SM', textAlign: TextAlign.center, color: greyColor),
                      SizedBox(width: 5.w),
                      InkWell(
                          onTap: () {
                            Get.to(() => RegisterScreen());
                          },
                          child: TextWidget(
                            text: 'register'.tr,
                            fontSize: 14.sp,
                            fontFamily: 'SM',
                            color: Theme.of(context).textTheme.titleMedium!.color,
                            textAlign: TextAlign.center,
                            textDecoration: TextDecoration.underline,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
