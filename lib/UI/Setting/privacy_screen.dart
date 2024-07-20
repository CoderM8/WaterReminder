import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('privacypolicy'.tr, context),
      body: WebViewWidget(controller: privacyController),
    );
  }
}
