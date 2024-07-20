import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Constant/liquidprogress.dart';
import 'package:water_tracker/Controller/home_controller.dart';
import 'package:water_tracker/Services/api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController hc = Get.put(HomeController());

 //Future<void> initFlutterChannel() async {
 //  print("initFlutterChannel -----");
 //  channel.setMethodCallHandler((call) async {
 //    print("call method ----- ${call.method}");
 //    switch (call.method) {
 //      case "updateTextFromWatch":
 //        print("case call -----");
 //        await AllApi()
 //            .addWaterApi(ml: call.arguments["waterML"], date: DateTime.now().toString(), image: 'assets/icons/${call.arguments["image"]}.png');
 //        await getProfileData();
 //        isRefresh.value = !isRefresh.value;
 //        break;
 //      default:
 //        break;
 //    }
 //  });

    // channel.setMethodCallHandler((call) async {
    //   switch (call.method) {
    //     case "sendCounterToFlutter":
    //       await AllApi().addWaterApi(
    //           ml: call.arguments["data"]["drinkWater"],
    //           date: DateTime.now().toString(),
    //           image: 'assets/icons/${call.arguments["data"]["image"]}.png');
    //       await getProfileData();
    //       isRefresh.value = !isRefresh.value;
    //       break;
    //     default:
    //       break;
    //   }
    // });
 // }

  @override
  void initState() {
    super.initState();
    print("initstate ------");

      channel.setMethodCallHandler((call) async {
        final methodName = call.method;
        final args = call.arguments;

        if (methodName != "updateTextFromWatch") {
          return;
        }
        await AllApi().addWaterApi(ml: args["waterML"], date: DateTime.now().toString(), image: 'assets/icons/${args["image"]}.png');
        await getProfileData().then((v) {
          if (v.isNotEmpty) {
            int waterNumber = v['waterNumber'];
            int drinkWater = v['total_ml_today'];
            int remainingWater = waterNumber - drinkWater;
            String waterPercentage = (drinkWater / waterNumber * 100).toStringAsFixed(2);
            double waterProgress = drinkWater / waterNumber;

            print("channel starting ---");

            channel.invokeMethod("phoneToWatch", {
              "method": "updateTextFromFlutter",
              "data": {
                "drinkWater": 123,
                "remainingWater": 256,
                "waterPercentage": 458,
                "waterProgress": 25.23
              },
            });
            isRefresh.value = !isRefresh.value;

            print("channel ending ----");
          } else {
            print("else ----");
          }
        });

      });
  }

  void sendWatch(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.h,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/appbarwave.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        backgroundColor: transparentColor,
        elevation: 0,
        centerTitle: false,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 10.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: Obx(() {
                return image.isNotEmpty
                    ? Image.network(image.value, height: 42.w, width: 42.w, alignment: Alignment.topCenter, fit: BoxFit.cover)
                    : Image.asset(
                        'assets/images/profile.png',
                        width: 42.w,
                        height: 42.w,
                        fit: BoxFit.cover,
                      );
              }),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(text: '${'hello'.tr}, ${greet()}', fontSize: 10.sp, fontFamily: 'M', color: whiteColor),
                Obx(() {
                  return TextWidget(text: firstName.value, fontSize: 20.sp, fontFamily: 'SM', color: whiteColor);
                }),
              ],
            )
          ],
        ),
        actions: [
          InkWell(onTap: (){
            channel.invokeMethod("forwardToAppleWatch", {
              "method": "updateTextFromFlutter",
              "data": {
                "drinkWater": "23",
                "remainingWater": "56",
                "waterPercentage": "2.5",
                "waterProgress": "4.5"
              },
            });
          },child: Icon(Icons.watch))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Spacer(flex: 5),
              Obx(() {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    /// LiquidProgressIndicator
                    Container(
                      color: isDark ? whiteColor : null,
                      height: 379.w,
                      width: 227.w,
                      child: LiquidProgressIndicator(value: waterProgress.value, direction: Axis.vertical),
                    ),
                    if (genderIndex.value == 0)
                      Image.asset(
                        'assets/images/manprogress.jpg',
                        height: 380.w,
                        width: 227.w,
                        fit: BoxFit.fill,
                        color: isDark ? blackColor : null,
                      )
                    else if (genderIndex.value >= 1 && genderIndex.value <= 3)
                      Image.asset(
                        'assets/images/womanprogress.png',
                        height: 380.w,
                        width: 227.w,
                        fit: BoxFit.fill,
                        color: isDark ? blackColor : null,
                      )
                    else
                      Image.asset(
                        'assets/images/bottle.png',
                        height: 380.w,
                        width: 227.w,
                        fit: BoxFit.fill,
                        color: isDark ? blackColor : null,
                      ),
                  ],
                );
              }),

              /// Add Water Button
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                      isScrollControlled: true,
                      constraints: BoxConstraints(minWidth: width, maxHeight: height / 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          topLeft: Radius.circular(20.r),
                        ),
                      ),
                      builder: (context) {
                        return DraggableScrollableSheet(
                          initialChildSize: 1,
                          expand: false,
                          maxChildSize: 1,
                          minChildSize: 0.2,
                          builder: (BuildContext context, s) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(25.w, 20.h, 25.w, 0.h),
                              child: Column(
                                children: [
                                  Container(
                                    height: 5.h,
                                    width: 35.w,
                                    decoration: BoxDecoration(color: greyColor.withOpacity(0.5), borderRadius: BorderRadius.circular(16.r)),
                                  ),
                                  SizedBox(height: 20.h),
                                  Expanded(
                                    child: GridView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      controller: s,
                                      itemCount: hc.waterList.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 20.0.r, mainAxisSpacing: 20.0.r, childAspectRatio: 1, crossAxisCount: 3),
                                      itemBuilder: (context, i) {
                                        return InkWell(
                                          onTap: () async {
                                            if (int.parse(hc.waterList[i].ml) <= remainingWater.value) {
                                              await AllApi()
                                                  .addWaterApi(ml: hc.waterList[i].ml, date: DateTime.now().toString(), image: hc.waterList[i].image);
                                              await getProfileData();
                                              isRefresh.value = !isRefresh.value;
                                            } else if (drinkWater.value == waterNumber.value) {
                                              showToast(message: '${'youhavecompleted'.tr}💧');
                                            } else {
                                              showToast(message: '${'youcantadd'.tr} ${hc.waterList[i].ml} ${'water'.tr}💧');
                                            }
                                            Get.back();
                                          },
                                          child: Container(
                                            height: 92.h,
                                            width: 92.w,
                                            decoration: BoxDecoration(
                                                color: hc.waterList[i].color.withOpacity(0.2), borderRadius: BorderRadius.circular(35.r)),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Image.asset(hc.waterList[i].image, height: 28.h, width: 28.w),
                                                SizedBox(height: 5.h),
                                                TextWidget(
                                                    text: '${hc.waterList[i].ml}ML',
                                                    fontSize: 12.sp,
                                                    fontFamily: 'M',
                                                    color: Theme.of(context).textTheme.titleMedium!.color),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      });
                },
                child: Container(
                  height: 50.w,
                  width: 50.w,
                  decoration: BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: const [BoxShadow(color: lightBlueColor, blurRadius: 1, spreadRadius: 2)]),
                  child: Icon(Icons.add, color: whiteColor, size: 28.sp),
                ),
              ),
              const Spacer(flex: 1)
            ],
          ),
          SizedBox(height: 25.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.w),
            child: Obx(() {
              return Row(
                children: [
                  TextWidget(
                      text: '${drinkWater.value}ml - ', fontSize: 16.sp, fontFamily: 'B', color: Theme.of(context).textTheme.titleMedium!.color),
                  TextWidget(text: '${waterPercentage.value} %', fontSize: 18.sp, fontFamily: 'B', color: blueColor),
                  const Spacer(),
                  TextWidget(
                      text: '${'remaining'.tr} : ${remainingWater}ml',
                      fontSize: 10.sp,
                      fontFamily: 'M',
                      color: Theme.of(context).textTheme.titleMedium!.color),
                ],
              );
            }),
          ),
          SizedBox(
            height: 20.h,
            child: Obx(() {
              return Slider(
                value: waterProgress.value > 1 ? 1 : waterProgress.value,
                inactiveColor: greyColor.withOpacity(0.5),
                onChanged: (double v) {},
                activeColor: blueColor,
              );
            }),
          ),
          SizedBox(height: 20.h),

          /// Today Water Data
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.h),
              width: width,
              decoration: BoxDecoration(
                  color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r))),
              child: Obx(() {
                isRefresh.value;
                return FutureBuilder<Map<String, dynamic>>(
                    future: AllApi().getWaterTodayApi(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data != null && snapshot.data!['WATER_REMIND'].isNotEmpty) {
                          return GestureDetector(
                            onVerticalDragUpdate: (v) {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                                  isScrollControlled: true,
                                  constraints: BoxConstraints(minWidth: width, maxHeight: height / 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.r),
                                      topLeft: Radius.circular(20.r),
                                    ),
                                  ),
                                  builder: (context) {
                                    return DraggableScrollableSheet(
                                      initialChildSize: 1,
                                      expand: false,
                                      maxChildSize: 1,
                                      minChildSize: 0.2,
                                      builder: (BuildContext context, s) {
                                        return Padding(
                                          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 5.h,
                                                width: 35.w,
                                                decoration:
                                                    BoxDecoration(color: greyColor.withOpacity(0.5), borderRadius: BorderRadius.circular(16.r)),
                                              ),
                                              SizedBox(height: 20.h),
                                              Expanded(
                                                child: ListView.separated(
                                                  itemCount: snapshot.data!["WATER_REMIND"].length,
                                                  shrinkWrap: true,
                                                  controller: s,
                                                  scrollDirection: Axis.vertical,
                                                  itemBuilder: (BuildContext context, int i) {
                                                    var water = snapshot.data!["WATER_REMIND"][i];
                                                    return Container(
                                                      height: 32.h,
                                                      width: width,
                                                      color: transparentColor,
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            water['ml_image'],
                                                            height: 20.h,
                                                            width: 20.w,
                                                          ),
                                                          SizedBox(width: 8.w),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              TextWidget(
                                                                  text: DateFormat('hh:mm a').format(DateTime.parse(water['created_at'])),
                                                                  fontSize: 12.sp,
                                                                  fontFamily: 'M',
                                                                  color: Theme.of(context).textTheme.titleMedium!.color),
                                                              TextWidget(text: 'water'.tr, fontSize: 7.sp, fontFamily: 'R', color: textColor),
                                                            ],
                                                          ),
                                                          const Spacer(),
                                                          TextWidget(
                                                              text: '${water['water_ml']}ml',
                                                              fontSize: 12.sp,
                                                              fontFamily: 'M',
                                                              color: Theme.of(context).textTheme.titleMedium!.color),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  separatorBuilder: (BuildContext context, int i) {
                                                    return const Divider();
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  });
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 3.h,
                                  width: 35.w,
                                  decoration: BoxDecoration(color: greyColor.withOpacity(0.5), borderRadius: BorderRadius.circular(16.r)),
                                ),
                                SizedBox(height: 5.h),
                                TextWidget(
                                    text: 'todayrecords'.tr, fontSize: 10.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
                                SizedBox(height: 18.h),
                                ListView.separated(
                                  itemCount: snapshot.data!["WATER_REMIND"].take(1).length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                                  itemBuilder: (BuildContext context, int i) {
                                    var water = snapshot.data!['WATER_REMIND'][i];
                                    return Container(
                                      height: 32.h,
                                      width: width,
                                      color: transparentColor,
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            water['ml_image'],
                                            height: 20.h,
                                            width: 20.w,
                                          ),
                                          SizedBox(width: 8.w),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextWidget(
                                                  text: DateFormat('hh:mm a').format(DateTime.parse(water['created_at'])),
                                                  fontSize: 12.sp,
                                                  fontFamily: 'M',
                                                  color: Theme.of(context).textTheme.titleMedium!.color),
                                              TextWidget(text: 'water'.tr, fontSize: 7.sp, fontFamily: 'R', color: textColor),
                                            ],
                                          ),
                                          const Spacer(),
                                          TextWidget(
                                              text: '${water['water_ml']}ml',
                                              fontSize: 12.sp,
                                              fontFamily: 'M',
                                              color: Theme.of(context).textTheme.titleMedium!.color),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int i) {
                                    return const Divider();
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return GestureDetector(
                            onVerticalDragUpdate: (v) {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                                  isScrollControlled: true,
                                  constraints: BoxConstraints(minWidth: width, maxHeight: height / 1.2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20.r),
                                      topLeft: Radius.circular(20.r),
                                    ),
                                  ),
                                  builder: (context) {
                                    return DraggableScrollableSheet(
                                      initialChildSize: 1,
                                      expand: false,
                                      maxChildSize: 1,
                                      minChildSize: 0.2,
                                      builder: (BuildContext context, s) {
                                        return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10.h),
                                            Container(
                                              height: 5.h,
                                              width: 35.w,
                                              decoration: BoxDecoration(color: greyColor.withOpacity(0.5), borderRadius: BorderRadius.circular(16.r)),
                                            ),
                                            const Spacer(),
                                            Lottie.asset('assets/lottie/NoData.json', height: 154.h, width: 154.h),
                                            SizedBox(height: 20.h),
                                            TextWidget(
                                                text: '" ${'notask'.tr} "',
                                                fontFamily: 'M',
                                                fontSize: 18.sp,
                                                color: Theme.of(context).textTheme.titleMedium!.color),
                                            SizedBox(height: 3.h),
                                            TextWidget(
                                                text: 'youhavenotask'.tr,
                                                fontFamily: 'M',
                                                textAlign: TextAlign.center,
                                                color: greyColor,
                                                fontSize: 14.sp),
                                            const Spacer()
                                          ],
                                        );
                                      },
                                    );
                                  });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 3.h,
                                  width: 35.w,
                                  decoration: BoxDecoration(color: greyColor.withOpacity(0.5), borderRadius: BorderRadius.circular(16.r)),
                                ),
                                SizedBox(height: 5.h),
                                TextWidget(
                                    text: 'todayrecords'.tr, fontSize: 10.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
                                SizedBox(height: 18.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/icons/water.svg'),
                                    SizedBox(width: 8.w),
                                    TextWidget(
                                        text: 'firstglasswater'.tr,
                                        fontSize: 14.sp,
                                        fontFamily: 'M',
                                        color: Theme.of(context).textTheme.titleMedium!.color),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              Container(
                                height: 3.h,
                                width: 35.w,
                                decoration: BoxDecoration(color: greyColor.withOpacity(0.5), borderRadius: BorderRadius.circular(16.r)),
                              ),
                              SizedBox(height: 5.h),
                              TextWidget(
                                  text: 'todayrecords'.tr, fontSize: 10.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
                              SizedBox(height: 15.h),
                              SizedBox(
                                width: width,
                                height: 32.h,
                                child: Shimmer.fromColors(
                                  baseColor: shimmer,
                                  highlightColor: whiteColor,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30.w,
                                        width: 30.w,
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: whiteColor),
                                      ),
                                      SizedBox(width: 8.w),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 13.w,
                                            width: 80.w,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: whiteColor),
                                          ),
                                          SizedBox(height: 2.h),
                                          Container(
                                            height: 13.w,
                                            width: 50.w,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: whiteColor),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Container(
                                        height: 20.w,
                                        width: 60.w,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    });
              }),
            ),
          ),
        ],
      ),
    );
  }
}
