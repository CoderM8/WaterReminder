import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/reminder_controller.dart';

class ReminderScreen extends StatelessWidget {
  ReminderScreen({super.key});

  final ReminderController rc = Get.put(ReminderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('reminder'.tr, context),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Container(
                height: 52.h,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: isDark ? lightBlackColor : backgroundGreyColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(text: 'sendnotification'.tr, fontFamily: 'M', fontSize: 14.sp, color: Theme.of(context).textTheme.titleMedium!.color),
                    Obx(() {
                      return CupertinoSwitch(
                          value: isNotification.value,
                          activeColor: blueColor,
                          onChanged: (v) async {
                            isNotification.value = v;
                            box.write('isNotification', isNotification.value);
                            if (isNotification.value == true) {
                              rc.scheduleStartTime =
                                  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
                              rc.scheduleEndTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 22, 00);
                            } else {
                              List<PendingNotificationRequest> pendingNotification =
                                  await flutterLocalNotificationsPlugin.pendingNotificationRequests();
                              for (var element in pendingNotification) {
                                print("Cancel Notification -------> ${element.id}");
                                flutterLocalNotificationsPlugin.cancel(element.id);
                              }
                            }
                          });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 52.h,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: isDark ? lightBlackColor : backgroundGreyColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(text: 'startat'.tr, fontFamily: 'M', fontSize: 14.sp, color: Theme.of(context).textTheme.titleMedium!.color),
                    Obx(() {
                      rc.isRefresh.value;
                      return InkWell(
                        onTap: isNotification.value == true
                            ? () async {
                                await rc.pickStartTime(context);
                              }
                            : null,
                        child: TextWidget(
                            text: DateFormat('hh:mm a').format(rc.scheduleStartTime),
                            fontFamily: 'M',
                            fontSize: 14.sp,
                            color: Theme.of(context).textTheme.titleMedium!.color),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 52.h,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: isDark ? lightBlackColor : backgroundGreyColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(text: 'endat'.tr, fontFamily: 'M', fontSize: 14.sp, color: Theme.of(context).textTheme.titleMedium!.color),
                    Obx(() {
                      rc.isRefresh.value;
                      return InkWell(
                        onTap: isNotification.value == true
                            ? () async {
                                await rc.pickEndTime(context);
                              }
                            : null,
                        child: TextWidget(
                            text: DateFormat('hh:mm a').format(rc.scheduleEndTime),
                            fontFamily: 'M',
                            fontSize: 14.sp,
                            color: Theme.of(context).textTheme.titleMedium!.color),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                height: 52.h,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r), color: isDark ? lightBlackColor : backgroundGreyColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(text: 'interval'.tr, fontFamily: 'M', fontSize: 14.sp, color: Theme.of(context).textTheme.titleMedium!.color),
                    Obx(() {
                      return DropdownButton(
                          value: rc.interval.value,
                          style: TextStyle(fontSize: 14.sp, fontFamily: 'B', color: Theme.of(context).textTheme.titleMedium!.color),
                          underline: Container(
                            color: transparentColor,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          alignment: Alignment.center,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).iconTheme.color),
                          dropdownColor: isDark ? lightBlackColor : backgroundGreyColor,
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: TextWidget(text: rc.getIntervalString(1), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            DropdownMenuItem(
                              value: 15,
                              child: TextWidget(text: rc.getIntervalString(15), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            DropdownMenuItem(
                              value: 30,
                              child: TextWidget(text: rc.getIntervalString(30), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            DropdownMenuItem(
                              value: 60,
                              child: TextWidget(text: rc.getIntervalString(60), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            DropdownMenuItem(
                              value: 90,
                              child: TextWidget(text: rc.getIntervalString(90), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            DropdownMenuItem(
                              value: 120,
                              child: TextWidget(text: rc.getIntervalString(120), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            DropdownMenuItem(
                              value: 150,
                              child: TextWidget(text: rc.getIntervalString(150), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                            DropdownMenuItem(
                              value: 180,
                              child: TextWidget(text: rc.getIntervalString(180), color: Theme.of(context).textTheme.titleMedium!.color),
                            ),
                          ],
                          onChanged: (val) {
                            rc.interval.value = val!;
                          });
                    })
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              TextFieldWidget(
                controller: rc.drinkMsg,
                hint: 'message'.tr,
                maxLine: 2,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 40.h),
              Obx(() {
                return ButtonWidget(
                  title: 'save'.tr,
                  enable: isNotification.value,
                  width: width / 2,
                  onTap: () async {
                    await rc.setWaterReminder();
                    showToast(message: 'Water Reminder Set Successfully');
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
