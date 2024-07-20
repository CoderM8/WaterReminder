import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {


  List<WaterList> waterList = [
    WaterList(index: 0, ml: '50', image: 'assets/icons/50ml.png', color: const    Color(0xff0085FF)),
    WaterList(index: 1, ml: '100', image: 'assets/icons/100ml.png', color: const  Color(0xffFF0000)),
    WaterList(index: 2, ml: '250', image: 'assets/icons/250ml.png', color: const  Color(0xff0038FF)),
    WaterList(index: 3, ml: '300', image: 'assets/icons/300ml.png', color: const  Color(0xff00B027)),
    WaterList(index: 4, ml: '350', image: 'assets/icons/350ml.png', color: const  Color(0xffFF0099)),
    WaterList(index: 5, ml: '400', image: 'assets/icons/400ml.png', color: const  Color(0xff00A99F)),
    WaterList(index: 6, ml: '450', image: 'assets/icons/450ml.png', color: const  Color(0xffA4BE00)),
    WaterList(index: 7, ml: '500', image: 'assets/icons/500ml.png', color: const  Color(0xff1456FF)),
    WaterList(index: 8, ml: '550', image: 'assets/icons/550ml.png', color: const  Color(0xff644A85)),
    WaterList(index: 9, ml: '600', image: 'assets/icons/600ml.png', color: const  Color(0xffFF7347)),
    WaterList(index: 10, ml: '650', image: 'assets/icons/650ml.png', color: const Color(0xffCDB86D)),
    WaterList(index: 11, ml: '700', image: 'assets/icons/700ml.png', color: const Color(0xffBABABA)),
    WaterList(index: 12, ml: '750', image: 'assets/icons/750ml.png', color: const Color(0xff32E339)),
    WaterList(index: 13, ml: '800', image: 'assets/icons/800ml.png', color: const Color(0xffA98AFF)),
    WaterList(index: 14, ml: '850', image: 'assets/icons/850ml.png', color: const Color(0xffFF38C7)),
    WaterList(index: 15, ml: '900', image: 'assets/icons/900ml.png', color: const Color(0xff4992FF)),
  ];
}

class WaterList {
  final int index;
  final String ml;
  final String image;
  final Color color;

  WaterList({required this.index, required this.ml, required this.image, required this.color});
}
