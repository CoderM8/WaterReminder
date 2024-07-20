import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class OnboardingController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt genderIndex = 0.obs;
  RxInt weightIndex = 0.obs;
  RxInt weatherIndex = 0.obs;
  RxInt goalIndex = 0.obs;
  RxInt kgIndex = 50.obs;
  RxInt lbsIndex = 50.obs;
  RxBool isCustom = false.obs;
  RxString country = 'US'.obs;
  RxString gender = 'Male'.obs;
  RxString weight = 'Kg'.obs;
  RxString goal = 'ML'.obs;
  RxString fixWater = '5000'.obs;
  RxInt weightNumber = 70.obs;
  RxString weather = 'Hot'.tr.obs;

  final Map map = {"ML": "5000", "L": "5", "US Oz": "169", "UK Oz": "176"};

  GlobalKey<FormState> profileKey = GlobalKey<FormState>();

  var controller = PageController();
  CarouselController kgController = CarouselController();
  CarouselController lbsController = CarouselController();

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController goalnumber = TextEditingController();

  RxBool passwordVisible = true.obs;

  List<DataList> genderList = [
    DataList(title: 'Male', image: 'assets/icons/male.svg'),
    DataList(title: 'Female', image: 'assets/icons/female.svg'),
    DataList(title: 'Pregnant', image: 'assets/icons/pregnant.svg'),
    DataList(title: 'Breastfeeding', image: 'assets/icons/breastfeeding.svg'),
    DataList(title: 'Other', image: 'assets/icons/other.svg')
  ];

  List<DataList> weightList = [DataList(title: 'Kg'), DataList(title: 'lbs')];

  List<DataList> goalList = [DataList(title: 'ML'), DataList(title: 'L'),DataList(title: 'US Oz'), DataList(title: 'UK Oz')];

  List<DataList> weatherList = [
    DataList(title: 'Hot', image: 'assets/icons/hot.svg'),
    DataList(title: 'Temperature', image: 'assets/icons/temperature.svg'),
    DataList(title: 'Cold', image: 'assets/icons/cold.svg')
  ];

  List<int> kgList = List.generate(91, (index) => (index + 20));
  List<int> lbsList = List.generate(180, (index) => (index + 20));

  File? image;
  RxBool isSelect = false.obs;

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      isSelect.value = true;
      image = File(pickedFile.path);
      isSelect.value = false;
    }
  }

  DateTime selectedDate = DateTime.now();

  Future pickDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      date.text = DateFormat('dd-MM-y').format(picked);
    }
  }

  @override
  void onInit() {
    super.onInit();
    controller = PageController(initialPage: 0);
  }
}

class DataList {
  final String title;
  final String? image;

  DataList({required this.title, this.image});
}

class OnBoarding {
  final String title;
  final String subtitle;
  final Widget widget;

  OnBoarding({required this.title, required this.subtitle, required this.widget});
}
