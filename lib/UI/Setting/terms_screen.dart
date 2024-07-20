import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('termsconditions'.tr, context),
      body: WebViewWidget(
        controller: termsController,
      ),
    );
  }
}
