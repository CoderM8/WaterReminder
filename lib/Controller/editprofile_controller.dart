import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/onboarding_controller.dart';

class EditProfileController extends GetxController {
  GlobalKey<FormState> editProfileKey = GlobalKey<FormState>();

  TextEditingController profileFirstName = TextEditingController();
  TextEditingController profileLastName = TextEditingController();
  TextEditingController profileEmail = TextEditingController();
  TextEditingController profileDate = TextEditingController();
  TextEditingController profileNumber = TextEditingController();
  TextEditingController goalnumber = TextEditingController();

  CarouselController kgController = CarouselController();
  CarouselController lbsController = CarouselController();

  RxString country = 'US'.obs;
  RxString goal = 'ML'.obs;
  RxString fixWater = '5000'.obs;
  RxInt goalIndex = 0.obs;
  RxBool isCustom = false.obs;
  RxInt weightIndex = 0.obs;
  RxInt kgIndex = 50.obs;
  RxInt lbsIndex = 50.obs;
  RxInt weightNumber = 70.obs;
  RxString weight = 'Kg'.obs;

  List<DataList> genderList = [
    DataList(title: 'Male', image: 'assets/icons/male.svg'),
    DataList(title: 'Female', image: 'assets/icons/female.svg'),
    DataList(title: 'Pregnant', image: 'assets/icons/pregnant.svg'),
    DataList(title: 'Breastfeeding', image: 'assets/icons/breastfeeding.svg'),
    DataList(title: 'Other', image: 'assets/icons/other.svg')
  ];

  final Map map = {"ML": "5000", "L": "5", "US Oz": "169", "UK Oz": "176"};

  List<DataList> goalList = [DataList(title: 'ML'), DataList(title: 'L'), DataList(title: 'US Oz'), DataList(title: 'UK Oz')];

  List<int> kgList = List.generate(91, (index) => (index + 20));
  List<int> lbsList = List.generate(180, (index) => (index + 20));

  List<DataList> weightList = [DataList(title: 'Kg'), DataList(title: 'lbs')];

  @override
  void onInit() {
    profileEmail.text = email.value;
    profileFirstName.text = firstName.value;
    profileLastName.text = lastName.value;
    profileDate.text = dob.value;
    profileNumber.text = number.value;
    country.value = flagCode.value;
    // goal.value = waterType.value;
    // fixWater.value = convertWater(waterNumber.value).toString();
    super.onInit();
  }

  DateTime selectedDate = DateTime.now();
  File? profileImage;
  RxBool isSelect = false.obs;

  Future pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      isSelect.value = true;
      profileImage = File(pickedFile.path);
      isSelect.value = false;
    }
  }

  Future pickDate(context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1980),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      profileDate.text = DateFormat('dd-MM-y').format(picked);
    }
  }
}
