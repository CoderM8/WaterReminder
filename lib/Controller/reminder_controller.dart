import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:water_tracker/Constant/constant.dart';

class ReminderController extends GetxController {
  TextEditingController drinkMsg = TextEditingController(text: 'It\'s Time to Drink Water💧');
  RxInt interval = 1.obs;

  DateTime scheduleStartTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime scheduleEndTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 22, 00);

  RxBool isRefresh = false.obs;

  Future setWaterReminder() async {
    String titleText = 'Water Reminder';
    String msg = drinkMsg.text;
   // final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    List<PendingNotificationRequest> pendingNotification = await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    for (var element in pendingNotification) {
      print("cancel Notification --------> ${element.id}");
      flutterLocalNotificationsPlugin.cancel(element.id);
    }
    tz.TZDateTime startTime = tz.TZDateTime.from(scheduleStartTime, tz.local);
    tz.TZDateTime endTime = tz.TZDateTime.from(scheduleEndTime, tz.local);
    scheduledNotification(tz.TZDateTime scheduledDate, int notificationId) async {
      print('scheduledNotification --------> ${scheduledDate.toString()}');
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notificationId,
          titleText,
          msg,
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails('water_reminder', 'Water Reminder', icon: '@mipmap/ic_launcher'/*,sound: RawResourceAndroidNotificationSound('waterdrop')*/),
            iOS: DarwinNotificationDetails(presentBanner: true, presentList: true/*,sound: 'waterdrop3.wav'*/),
          ),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
          payload: scheduledDate.millisecondsSinceEpoch.toString());
    }

    int interVal = interval.value;
    int notificationId = 1;
    while (startTime.isBefore(endTime)) {
      // tz.TZDateTime newScheduledDate = startTime;
      // if (newScheduledDate.isBefore(now)) {
      //   newScheduledDate = newScheduledDate.add(const Duration(days: 1));
      // }
      notificationId += 1;
      startTime = startTime.add(Duration(minutes: interVal));
      await scheduledNotification(startTime, notificationId);
    }
  }

  Future pickStartTime(BuildContext context) async {
    final TimeOfDay? picked = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ));
    if (picked != null) {
      scheduleStartTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, picked.hour, picked.minute);
    }
    isRefresh.value = !isRefresh.value;
  }

  Future pickEndTime(BuildContext context) async {
    final TimeOfDay? picked = (await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 22, minute: 00),
    ));
    if (picked != null) {
      scheduleEndTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, picked.hour, picked.minute);
    }
    isRefresh.value = !isRefresh.value;
  }

  String getIntervalString(int min) {
    switch (min) {
      case 1:
        return '${'every'.tr} 1 ${'minute'.tr}';
      case 15:
        return '${'every'.tr} 15 ${'minute'.tr}';
      case 30:
        return '${'every'.tr} 30 ${'minute'.tr}';
      case 60:
        return '${'every'.tr} 1 ${'hour'.tr}';
      case 90:
        return '${'every'.tr} 1.5 ${'hour'.tr}';
      case 120:
        return '${'every'.tr} 2 ${'hour'.tr}';
      case 150:
        return '${'every'.tr} 2.5 ${'hour'.tr}';
      case 180:
        return '${'every'.tr} 3 ${'hour'.tr}';
      default:
        return "";
    }
  }
}
