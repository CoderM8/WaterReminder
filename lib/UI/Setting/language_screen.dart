import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Localization/applanguage.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final RxInt select = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('language'.tr, context),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        child: Column(
          children: [
            ListView.separated(
              itemCount: Language.languageList.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int i) {
                return Obx(() {
                  select.value;
                  return InkWell(
                    onTap: () async {
                      await setLocale(Language.languageList[i].languageCode);
                      select.value = i;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: Language.languageList[i].name,
                          fontFamily: 'R',
                          fontSize: 16.sp,
                          color: Theme.of(context).textTheme.titleMedium!.color,
                        ),
                        const Spacer(),
                        Container(
                          height: 25.w,
                          width: 25.w,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1.w, color: blueColor)),
                          child: Container(
                            height: 15.w,
                            width: 15.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: box.read('languageCode') == Language.languageList[i].languageCode ? blueColor : transparentColor),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
              separatorBuilder: (BuildContext context, int i) {
                return SizedBox(height: 25.h);
              },
            ),
          ],
        ),
      ),
    );
  }
}
