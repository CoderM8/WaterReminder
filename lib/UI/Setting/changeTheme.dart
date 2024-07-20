import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/AppTheme/apptheme.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';

class ThemeChange extends StatefulWidget {
  const ThemeChange({super.key});

  @override
  ThemeChangeState createState() => ThemeChangeState();
}

class ThemeChangeState extends State<ThemeChange> {
  ThemeMode? selectedThemeMode;

  void changeTheme(ThemeMode mode, ThemeNotifier themeModeNotifier) async {
    themeModeNotifier.setThemeMode(mode);
    await box.write('themeMode', mode.index);
    themeMode = mode.index;
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: appBarWidget('theme'.tr, context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextWidget(
                      text: 'systemtheme'.tr, fontSize: 15.sp, maxLines: 4, fontFamily: "M", color: Theme.of(context).textTheme.titleMedium!.color),
                ),
                CupertinoSwitch(
                    value: themeMode == 0,
                    activeColor: blueColor,
                    thumbColor: whiteColor,
                    onChanged: (val) async {
                      setState(() {
                        if (val == true) {
                          changeTheme(ThemeMode.system, notifier);
                        } else {
                          changeTheme(ThemeMode.dark, notifier);
                        }
                      });
                    }),
              ],
            ),
            SizedBox(height: 15.h),
            const Divider(),
            SizedBox(height: 15.h),
            TextWidget(text: 'themedescription'.tr, fontSize: 14.sp, color: Theme.of(context).textTheme.titleMedium!.color),
            SizedBox(height: 10.h),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                  tileColor: Theme.of(context).listTileTheme.tileColor,
                  onTap: themeMode != 0
                      ? () {
                    changeTheme(ThemeMode.light, notifier);
                  }
                      : null,
                  title: TextWidget(text: 'light'.tr, fontSize: 16.sp, fontFamily: "M", color: Theme.of(context).textTheme.titleMedium!.color),
                  trailing: themeMode == 1 ? SvgPicture.asset('assets/icons/done.svg') : const SizedBox.shrink()),
            ),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
              child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: isTab(context) ? 14.h : 0),
                  tileColor: Theme.of(context).listTileTheme.tileColor,
                  onTap: themeMode != 0
                      ? () {
                    changeTheme(ThemeMode.dark, notifier);
                  }
                      : null,
                  title: TextWidget(text: 'dark'.tr, fontSize: 16.sp, fontFamily: "M", color: Theme.of(context).textTheme.titleMedium!.color),
                  trailing: themeMode == 2 ? SvgPicture.asset('assets/icons/done.svg') : const SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }
}