import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({super.key});

  final TextEditingController helpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('helpfeedback'.tr, context),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            TextFieldWidget(
              controller: helpController,
              hint: 'enterfeedback'.tr,
              maxLine: 5,
              textInputAction: TextInputAction.done,
              textInputType: TextInputType.text,
            ),
            SizedBox(height: 40.h),
            ButtonWidget(
                title: 'submit'.tr,
                width: width / 2,
                onTap: () {
                  if (helpController.text.isNotEmpty) {
                    helpController.clear();
                    showToast(message: 'yourfeedback'.tr);
                  }
                })
          ],
        ),
      ),
    );
  }
}
