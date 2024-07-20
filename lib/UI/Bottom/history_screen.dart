import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Services/api.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final RxBool isDelete = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextWidget(text: 'history'.tr, fontSize: 18.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Obx(() {
          isRefresh.value;
          isDelete.value;
          return FutureBuilder<Map<String, dynamic>>(
              future: AllApi().getWaterHistoryApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!['WATER_REMIND']['DETAILED'].isNotEmpty) {
                    final List<Widget> groupedMessages = [];
                    groupByDateList<dynamic, String>(snapshot.data!['WATER_REMIND']['DETAILED'] ?? [], (value) {
                      return days(date: DateTime.parse(value['created_at']));
                    }).forEach((date, data) {
                      groupedMessages.add(
                        Padding(
                          padding: EdgeInsets.only(bottom: 15.h, top: 25.h),
                          child: TextWidget(
                              text: date,
                              fontFamily: 'SM',
                              textAlign: TextAlign.start,
                              fontSize: 13.sp,
                              color: Theme.of(context).textTheme.titleMedium!.color),
                        ),
                      );
                      groupedMessages.add(ListView.separated(
                        itemCount: data.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context, i) {
                          return const Divider();
                        },
                        itemBuilder: (context, i) {
                          return Container(
                            height: 32.h,
                            width: width,
                            color: transparentColor,
                            child: Row(
                              children: [
                                Image.asset(
                                  data[i]['ml_image'],
                                  height: 20.h,
                                  width: 20.w,
                                ),
                                SizedBox(width: 8.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                        text: DateFormat('hh:mm a').format(DateTime.parse(data[i]['created_at'])),
                                        fontSize: 12.sp,
                                        fontFamily: 'M',
                                        color: Theme.of(context).textTheme.titleMedium!.color),
                                    TextWidget(text: 'water'.tr, fontSize: 7.sp, fontFamily: 'R', color: textColor),
                                  ],
                                ),
                                const Spacer(),
                                TextWidget(
                                    text: '${data[i]['water_ml']}ml',
                                    fontSize: 12.sp,
                                    fontFamily: 'M',
                                    color: Theme.of(context).textTheme.titleMedium!.color),
                                SizedBox(width: 10.w),
                                PopupMenuButton<String>(
                                  onSelected: (String v) async {
                                    await AllApi().deleteWaterApi(id: data[i]['id']);
                                    await getProfileData();
                                    isDelete.value = !isDelete.value;
                                  },
                                  padding: EdgeInsets.zero,
                                  offset: Offset(-10, AppBar().preferredSize.height / 6),
                                  constraints: BoxConstraints(maxWidth: 85.w),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.r)),
                                  child: Icon(Icons.more_vert_rounded, size: 18.sp, color: Theme.of(context).iconTheme.color),
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    PopupMenuItem<String>(
                                      value: '1',
                                      padding: EdgeInsets.zero,
                                      height: 30.h,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(width: 8.w),
                                          TextWidget(
                                              text: 'delete'.tr,
                                              fontSize: 12.sp,
                                              fontFamily: 'R',
                                              color: Theme.of(context).textTheme.titleMedium!.color),
                                          SizedBox(width: 8.w),
                                          SvgPicture.asset('assets/icons/delete.svg',
                                              width: 18.w, height: 18.w, color: Theme.of(context).iconTheme.color),
                                          SizedBox(width: 8.w),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ));
                    });
                    return Column(
                      children: [
                        SizedBox(
                          height: 48.w,
                          child: ListView.separated(
                            itemCount: snapshot.data!['WATER_REMIND']['SUMMARY'].length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const ScrollPhysics(),
                            itemBuilder: (BuildContext context, int i) {
                              var waterDate = snapshot.data!['WATER_REMIND']['SUMMARY'][i];
                              return Column(
                                children: [
                                  TextWidget(
                                      text: DateFormat('EE').format(DateTime.parse(waterDate['time_interval'])),
                                      color: Theme.of(context).textTheme.titleMedium!.color),
                                  SizedBox(height: 5.h),
                                  SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          value: double.parse(waterDate['ratio']),
                                          backgroundColor: greyColor.withOpacity(0.5),
                                          strokeWidth: 2.5.w,
                                        ),
                                        TextWidget(
                                          text: waterDate['date'],
                                          color: Theme.of(context).textTheme.titleMedium!.color,
                                          fontSize: 8.sp,
                                          fontFamily: 'M',
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                            separatorBuilder: (BuildContext context, int i) {
                              return SizedBox(width: 25.w);
                            },
                          ),
                        ),
                        //SizedBox(height: 10.h),
                        Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: groupedMessages,
                          ),
                        ),
                        SizedBox(height: 10.h)
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lottie/NoData.json', height: 120.h, width: 120.h),
                          SizedBox(height: 15.h),
                          TextWidget(text: 'nohistory'.tr, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'M', fontSize: 15.sp),
                        ],
                      ),
                    );
                  }
                } else {
                  return Shimmer.fromColors(
                      baseColor: shimmer,
                      highlightColor: whiteColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 43.h,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int i) {
                                  return Container(
                                    height: 43.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: whiteColor),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int i) {
                                  return SizedBox(width: 20.w);
                                },
                                itemCount: 7),
                          ),
                          SizedBox(height: 25.h),
                          Container(
                            height: 20.h,
                            width: 130.w,
                            decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                          ),
                          SizedBox(height: 15.h),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: 11,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, i) {
                                return SizedBox(
                                  width: width,
                                  height: 32.h,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30.w,
                                        width: 30.w,
                                        decoration: BoxDecoration(shape: BoxShape.circle, color: whiteColor),
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
                                );
                              },
                              separatorBuilder: (context, i) {
                                return const Divider();
                              },
                            ),
                          ),
                        ],
                      ));
                }
              });
        }),
      ),
    );
  }

  Map<T, List<S>> groupByDateList<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  String days({required DateTime date}) {
    String dateText;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime formatDate = DateTime(date.year, date.month, date.day);

    if (formatDate == today) {
      dateText = "${'today'.tr}, ${DateFormat('dd MMMM y').format(today)}";
    } else if (formatDate == yesterday) {
      dateText = "${'yesterday'.tr}, ${DateFormat('dd MMMM y').format(yesterday)}";
    } else {
      dateText = DateFormat('dd MMMM y').format(date);
    }
    return dateText;
  }
}
