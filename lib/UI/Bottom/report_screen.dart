import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:water_tracker/Constant/common_widget.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Controller/report_controller.dart';
import 'package:water_tracker/Services/api.dart';

class ReportScreen extends StatelessWidget {
  ReportScreen({super.key});

  final ReportController rc = Get.put(ReportController());

  static List<DateTime> getCurrentWeekDates() {
    DateTime currentDate = DateTime.now();
    DateTime sunday = currentDate.subtract(Duration(days: currentDate.weekday));
    List<DateTime> weekDays = [];
    for (int i = 0; i < 7; i++) {
      weekDays.add(sunday.add(Duration(days: i)));
    }
    return weekDays;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getCurrentWeekDates();
    return Scaffold(
      appBar: AppBar(
          title: TextWidget(text: 'report'.tr, fontSize: 18.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
          centerTitle: true,
          automaticallyImplyLeading: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                      text: rc.tabIndex.value == 0
                          ? toDay
                          : rc.tabIndex.value == 1
                              ? 'lastweek'.tr
                              : toDay,
                      fontSize: 20.sp,
                      color: Theme.of(context).textTheme.titleMedium!.color,
                      fontFamily: 'SM'),
                  TextWidget(
                      text: rc.tabIndex.value == 0
                          ? todayDate
                          : rc.tabIndex.value == 1
                              ? '${DateFormat('dd MMMM y').format(weekDates[0])} ${'to'.tr} ${'today'.tr}'
                              : todayDate,
                      fontSize: 12.sp,
                      color: Theme.of(context).textTheme.titleMedium!.color,
                      fontFamily: 'R'),
                ],
              );
            }),
          ),
          SizedBox(height: 9.h),
          Container(
            height: 35.h,
            width: width,
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(color: isDark ? tabColor : backgroundGreyColor, borderRadius: BorderRadius.circular(5.r)),
            child: Obx(() {
              return TabBar(
                controller: rc.tabController,
                padding: EdgeInsets.zero,
                indicator: const BoxDecoration(),
                dividerHeight: 0,
                isScrollable: false,
                physics: const BouncingScrollPhysics(),
                labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                onTap: (index) {
                  rc.tabIndex.value = index;
                },
                tabs: [
                  Tab(
                    height: 35.h,
                    child: Container(
                      height: 25.w,
                      width: 70.w,
                      margin: EdgeInsets.only(top: 2.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: rc.tabIndex.value == 0
                              ? blueColor
                              : isDark
                                  ? tabContainerColor
                                  : whiteColor),
                      child: TextWidget(
                        text: 'day'.tr,
                        fontSize: 12.sp,
                        fontFamily: "M",
                        color: isDark
                            ? whiteColor
                            : rc.tabIndex.value == 0
                                ? whiteColor
                                : blackColor,
                      ),
                    ),
                  ),
                  Tab(
                    height: 35.h,
                    child: Container(
                      height: 25.w,
                      width: 70.w,
                      margin: EdgeInsets.only(top: 2.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: rc.tabIndex.value == 1
                              ? blueColor
                              : isDark
                                  ? tabContainerColor
                                  : whiteColor),
                      child: TextWidget(
                        text: 'week'.tr,
                        fontSize: 12.sp,
                        fontFamily: "M",
                        color: isDark
                            ? whiteColor
                            : rc.tabIndex.value == 1
                                ? whiteColor
                                : blackColor,
                      ),
                    ),
                  ),
                  Tab(
                    height: 35.h,
                    child: Container(
                      height: 25.w,
                      width: 70.w,
                      margin: EdgeInsets.only(top: 2.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: rc.tabIndex.value == 2
                              ? blueColor
                              : isDark
                                  ? tabContainerColor
                                  : whiteColor),
                      child: TextWidget(
                        text: 'month'.tr,
                        fontSize: 12.sp,
                        fontFamily: "M",
                        color: isDark
                            ? whiteColor
                            : rc.tabIndex.value == 2
                                ? whiteColor
                                : blackColor,
                      ),
                    ),
                  ),
                  Tab(
                    height: 35.h,
                    child: Container(
                      height: 25.w,
                      width: 70.w,
                      margin: EdgeInsets.only(top: 2.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          color: rc.tabIndex.value == 3
                              ? blueColor
                              : isDark
                                  ? tabContainerColor
                                  : whiteColor),
                      child: TextWidget(
                        text: 'year'.tr,
                        fontSize: 12.sp,
                        fontFamily: "M",
                        color: isDark
                            ? whiteColor
                            : rc.tabIndex.value == 3
                                ? whiteColor
                                : blackColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          Expanded(child: Obx(() {
            rc.tabIndex.value;
            isRefresh.value;
            return FutureBuilder<Map<String, dynamic>>(
                future: AllApi().getWaterReportApi(index: rc.tabIndex.value),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      List<TodayChartData> todayChartData = [];
                      List<WeekChartData> weekChartData = [];
                      List<MonthChartData> monthChartData = [];
                      List<YearChartData> yearChartData = [];

                      if (rc.tabIndex.value == 0) {
                        for (var e in snapshot.data!["WATER_REMIND"]['SUMMARY']) {
                          todayChartData.add(TodayChartData.fromMap(e));
                        }
                      }
                      if (rc.tabIndex.value == 1) {
                        for (var e in snapshot.data!["WATER_REMIND"]['SUMMARY']) {
                          weekChartData.add(WeekChartData.fromMap(e));
                        }
                      }
                      if (rc.tabIndex.value == 2) {
                        for (var e in snapshot.data!["WATER_REMIND"]['SUMMARY'].take(6)) {
                          monthChartData.add(MonthChartData.fromMap(e));
                        }
                      }
                      if (rc.tabIndex.value == 3) {
                        for (var e in snapshot.data!["WATER_REMIND"]['SUMMARY']) {
                          yearChartData.add(YearChartData.fromMap(e));
                        }
                      }
                      return TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: rc.tabController,
                        children: [
                          TodayScreen(rc: rc, data: snapshot.data!["WATER_REMIND"], todayChartData: todayChartData),
                          WeekScreen(rc: rc, data: snapshot.data!["WATER_REMIND"], weekChartData: weekChartData),
                          MonthScreen(rc: rc, data: snapshot.data!["WATER_REMIND"], monthChartData: monthChartData),
                          YearScreen(rc: rc, data: snapshot.data!["WATER_REMIND"], yearChartData: yearChartData)
                        ],
                      );
                    } else {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset('assets/lottie/NoData.json', height: 120.h, width: 120.h),
                            SizedBox(height: 15.h),
                            TextWidget(text: 'noreport'.tr, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'M', fontSize: 15.sp),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Shimmer.fromColors(
                          baseColor: shimmer,
                          highlightColor: whiteColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
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
                                height: 30.h,
                                width: 110.w,
                                decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                height: 20.h,
                                width: 150.w,
                                decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(8.r)),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                height: 320.h,
                                width: width,
                                decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                              ),
                              SizedBox(height: 20.h),
                              Container(
                                height: 30.h,
                                width: 150.w,
                                decoration: BoxDecoration(color: whiteColor, borderRadius: BorderRadius.circular(10.r)),
                              ),
                            ],
                          )),
                    );
                  }
                });
          })),
        ],
      ),
    );
  }
}

class TodayScreen extends StatelessWidget {
  TodayScreen({super.key, required this.rc, required this.data, required this.todayChartData});

  final List<TodayChartData> todayChartData;
  final Map data;

  final ReportController rc;

  static List<DateTime> getCurrentWeekDates() {
    DateTime currentDate = DateTime.now();
    DateTime sunday = currentDate.subtract(Duration(days: currentDate.weekday));
    List<DateTime> weekDays = [];
    for (int i = 0; i < 7; i++) {
      weekDays.add(sunday.add(Duration(days: i)));
    }
    return weekDays;
  }

  final tooltip = TooltipBehavior(enable: true, color: blueColor);

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates = getCurrentWeekDates();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: data['DETAILED'].isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 48.w,
                    child: ListView.separated(
                      itemCount: weekDates.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemBuilder: (BuildContext context, int i) {
                        var waterDate = weekDates[i];
                        return Column(
                          children: [
                            TextWidget(text: DateFormat('EE').format(waterDate), color: Theme.of(context).textTheme.titleMedium!.color),
                            SizedBox(height: 5.h),
                            weekDates[i].day.toString() == todayDateNumber
                                ? SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: Obx(() {
                                      return CircularProgressIndicator(
                                        value: waterProgress.value,
                                        backgroundColor: greyColor.withOpacity(0.5),
                                        strokeWidth: 2.5.w,
                                      );
                                    }))
                                : Container(
                                    height: 22.w,
                                    width: 22.w,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundGreyColor),
                                    child: SvgPicture.asset('assets/icons/water.svg'),
                                  )
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int i) {
                        return SizedBox(width: 25.w);
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextWidget(text: 'today'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                  TextWidget(text: '${drinkWater.value}ML - ${waterPercentage.value}%', fontSize: 15.sp, color: blueColor, fontFamily: 'SM'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: isDark ? lightBlackColor : null,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(
                              majorGridLines: MajorGridLines(width: 0),
                            ),
                            plotAreaBorderWidth: 0,
                            key: UniqueKey(),
                            primaryYAxis: const NumericAxis(
                              majorGridLines: MajorGridLines(width: 0),
                              minimum: 0,
                              maximum: 100,
                              interval: 20,
                            ),
                            tooltipBehavior: tooltip,
                            onSelectionChanged: (v) {},
                            series: <CartesianSeries<TodayChartData, String>>[
                              ColumnSeries<TodayChartData, String>(
                                dataSource: todayChartData,
                                xValueMapper: (TodayChartData data, _) => data.x,
                                yValueMapper: (TodayChartData data, _) => (data.y / waterNumber.value) * 100,
                                name: '',
                                selectionBehavior: SelectionBehavior(selectedColor: blueColor, enable: true, toggleSelection: false),
                                borderRadius: BorderRadius.circular(25.r),
                                gradient: LinearGradient(
                                    colors: [greyColor, greyColor.withOpacity(0.5), whiteColor],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight),
                              )
                            ]),
                      ),
                      SizedBox(height: 20.h),
                      TextWidget(text: 'todayrecords'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                      SizedBox(height: 15.h),
                      ListView.separated(
                        itemCount: data["DETAILED"].length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        itemBuilder: (BuildContext context, int i) {
                          var water = data["DETAILED"][i];
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
                  SizedBox(height: 10.h)
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: height / 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/NoData.json', height: 120.h, width: 120.h),
                  SizedBox(height: 15.h),
                  TextWidget(text: 'noreport'.tr, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'M', fontSize: 15.sp),
                ],
              ),
            ),
    );
  }
}

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key, required this.rc, required this.data, required this.weekChartData});

  final Map data;
  final List<WeekChartData> weekChartData;
  final ReportController rc;

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  final tooltip = TooltipBehavior(enable: true, color: blueColor);
  final List<Widget> groupedMessages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupByDateList<dynamic, String>(widget.data['DETAILED'] ?? [], (value) {
      return days(date: DateTime.parse(value['created_at']));
    }).forEach((date, data) {
      groupedMessages.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15.h, top: 25.h),
          child: TextWidget(
              text: date, fontFamily: 'SM', textAlign: TextAlign.start, fontSize: 13.sp, color: Theme.of(context).textTheme.titleMedium!.color),
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
                TextWidget(text: '${data[i]['water_ml']}ml', fontSize: 12.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
              ],
            ),
          );
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: widget.data['DETAILED'].isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 48.w,
                    child: ListView.separated(
                      itemCount: widget.weekChartData.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemBuilder: (context, i) {
                        var waterDate = widget.weekChartData[i];
                        return Column(
                          children: [
                            TextWidget(
                                text: DateFormat('EE').format(DateTime.parse(waterDate.time)), color: Theme.of(context).textTheme.titleMedium!.color),
                            SizedBox(height: 5.h),
                            waterDate.ratio == '0.0'
                                ? Container(
                                    height: 22.w,
                                    width: 22.w,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundGreyColor),
                                    child: SvgPicture.asset('assets/icons/water.svg'),
                                  )
                                : SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: CircularProgressIndicator(
                                      value: double.parse(waterDate.ratio),
                                      backgroundColor: greyColor.withOpacity(0.5),
                                      strokeWidth: 2.5.w,
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
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: 'average'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        TextWidget(text: '${(widget.data['AVERAGE'] ?? 0)}ML', fontSize: 15.sp, color: blueColor, fontFamily: 'SM'),
                        Card(
                          color: isDark ? lightBlackColor : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          child: SfCartesianChart(
                              primaryXAxis: const CategoryAxis(
                                majorGridLines: MajorGridLines(width: 0),
                              ),
                              plotAreaBorderWidth: 0,
                              key: UniqueKey(),
                              primaryYAxis: const NumericAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                minimum: 0,
                                maximum: 100,
                                interval: 20,
                              ),
                              tooltipBehavior: tooltip,
                              onSelectionChanged: (v) {},
                              series: <CartesianSeries<WeekChartData, String>>[
                                ColumnSeries<WeekChartData, String>(
                                  dataSource: widget.weekChartData,
                                  xValueMapper: (WeekChartData data, _) => data.date,
                                  yValueMapper: (WeekChartData data, _) => data.ml / data.goal * 100,
                                  name: '',
                                  selectionBehavior: SelectionBehavior(selectedColor: blueColor, enable: true, toggleSelection: false),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
                                  gradient: LinearGradient(
                                      colors: [greyColor, greyColor.withOpacity(0.5), whiteColor],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight),
                                )
                              ]),
                        ),
                        SizedBox(height: 20.h),
                        TextWidget(text: 'goalarchived'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        TextWidget(
                            text: 'thegoalwas'.tr.replaceAll('XX', (widget.data['GOAL_ACHIEVED_COUNT'] ?? 0).toString()),
                            maxLines: 2,
                            fontSize: 13.sp,
                            color: textColor,
                            fontFamily: 'R'),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/goalmedal.svg'),
                            SizedBox(width: 5.w),
                            TextWidget(
                                text: '${(widget.data['GOAL_ACHIEVED_COUNT'] ?? 0).toString()}/7',
                                fontSize: 16.sp,
                                color: blueColor,
                                fontFamily: 'B'),
                            const Spacer(),
                            TextWidget(
                                text: '${((widget.data['GOAL_ACHIEVED_COUNT'] ?? 0) / 7 * 100).toStringAsFixed(2)}%',
                                fontSize: 16.sp,
                                color: blueColor,
                                fontFamily: 'B'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Slider(
                      value: (widget.data['GOAL_ACHIEVED_COUNT'] ?? 0) / 7,
                      inactiveColor: greyColor.withOpacity(0.5),
                      onChanged: (double v) {},
                      activeColor: blueColor,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: 'records'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        SizedBox(height: 5.h),
                        ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: groupedMessages),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: height / 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/NoData.json', height: 120.h, width: 120.h),
                  SizedBox(height: 15.h),
                  TextWidget(text: 'noreport'.tr, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'M', fontSize: 15.sp),
                ],
              ),
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

class MonthScreen extends StatefulWidget {
  const MonthScreen({super.key, required this.rc, required this.data, required this.monthChartData});

  final Map data;
  final List<MonthChartData> monthChartData;
  final ReportController rc;

  @override
  State<MonthScreen> createState() => _MonthScreenState();
}

class _MonthScreenState extends State<MonthScreen> {
  final tooltip = TooltipBehavior(enable: true, color: blueColor);
  final List<Widget> groupedMessages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupByDateList<dynamic, String>(widget.data['DETAILED'] ?? [], (value) {
      return days(date: DateTime.parse(value['created_at']));
    }).forEach((date, data) {
      groupedMessages.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15.h, top: 25.h),
          child: TextWidget(
              text: date, fontFamily: 'SM', textAlign: TextAlign.start, fontSize: 13.sp, color: Theme.of(context).textTheme.titleMedium!.color),
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
                TextWidget(text: '${data[i]['water_ml']}ml', fontSize: 12.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
              ],
            ),
          );
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: widget.data['DETAILED'].isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: 'average'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        TextWidget(text: '${(widget.data['AVERAGE']) ?? 0}ML', fontSize: 15.sp, color: blueColor, fontFamily: 'SM'),
                        Card(
                          color: isDark ? lightBlackColor : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          child: SfCartesianChart(
                              primaryXAxis: const CategoryAxis(
                                majorGridLines: MajorGridLines(width: 0),
                              ),
                              plotAreaBorderWidth: 0,
                              key: UniqueKey(),
                              primaryYAxis: const NumericAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                minimum: 0,
                                maximum: 100,
                                interval: 20,
                              ),
                              tooltipBehavior: tooltip,
                              onSelectionChanged: (v) {},
                              series: <CartesianSeries<MonthChartData, String>>[
                                ColumnSeries<MonthChartData, String>(
                                  dataSource: widget.monthChartData,
                                  xValueMapper: (MonthChartData data, _) => data.date,
                                  yValueMapper: (MonthChartData data, _) => data.ml / data.goal * 100,
                                  name: '',
                                  selectionBehavior: SelectionBehavior(selectedColor: blueColor, enable: true, toggleSelection: false),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
                                  gradient: LinearGradient(
                                      colors: [greyColor, greyColor.withOpacity(0.5), whiteColor],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight),
                                )
                              ]),
                        ),
                        SizedBox(height: 20.h),
                        TextWidget(text: 'goalarchived'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        TextWidget(
                            text: 'thegoalwas'.tr.replaceAll('XX', (widget.data['GOAL_ACHIEVED_COUNT'] ?? 0).toString()),
                            maxLines: 2,
                            fontSize: 13.sp,
                            color: textColor,
                            fontFamily: 'R'),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/goalmedal.svg'),
                            SizedBox(width: 5.w),
                            TextWidget(
                                text: '${(widget.data['GOAL_ACHIEVED_COUNT'] ?? 0).toString()}/30',
                                fontSize: 16.sp,
                                color: blueColor,
                                fontFamily: 'B'),
                            const Spacer(),
                            TextWidget(
                                text: '${((widget.data['GOAL_ACHIEVED_COUNT'] ?? 0) / 30 * 100).toStringAsFixed(2)}%',
                                fontSize: 16.sp,
                                color: blueColor,
                                fontFamily: 'B'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Slider(
                      value: (widget.data['GOAL_ACHIEVED_COUNT'] ?? 0) / 30,
                      inactiveColor: greyColor.withOpacity(0.5),
                      onChanged: (double v) {},
                      activeColor: blueColor,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: 'records'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        SizedBox(height: 5.h),
                        ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: groupedMessages),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: height / 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/NoData.json', height: 120.h, width: 120.h),
                  SizedBox(height: 15.h),
                  TextWidget(text: 'noreport'.tr, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'M', fontSize: 15.sp),
                ],
              ),
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

class YearScreen extends StatefulWidget {
  const YearScreen({super.key, required this.rc, required this.data, required this.yearChartData});

  final Map data;
  final List<YearChartData> yearChartData;
  final ReportController rc;

  @override
  State<YearScreen> createState() => _YearScreenState();
}

class _YearScreenState extends State<YearScreen> {
  final tooltip = TooltipBehavior(enable: true, color: blueColor);
  final List<Widget> groupedMessages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    groupByDateList<dynamic, String>(widget.data['DETAILED'] ?? [], (value) {
      return days(date: DateTime.parse(value['created_at']));
    }).forEach((date, data) {
      groupedMessages.add(
        Padding(
          padding: EdgeInsets.only(bottom: 15.h, top: 25.h),
          child: TextWidget(
              text: date, fontFamily: 'SM', textAlign: TextAlign.start, fontSize: 13.sp, color: Theme.of(context).textTheme.titleMedium!.color),
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
                TextWidget(text: '${data[i]['water_ml']}ml', fontSize: 12.sp, fontFamily: 'M', color: Theme.of(context).textTheme.titleMedium!.color),
              ],
            ),
          );
        },
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: widget.data['DETAILED'].isNotEmpty
          ? Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: 'average'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        TextWidget(text: '${(widget.data['AVERAGE']) ?? 0}ML', fontSize: 15.sp, color: blueColor, fontFamily: 'SM'),
                        Card(
                          color: isDark ? lightBlackColor : null,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                          child: SfCartesianChart(
                              primaryXAxis: const CategoryAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                interval: 1,
                              ),
                              plotAreaBorderWidth: 0,
                              key: UniqueKey(),
                              primaryYAxis: const NumericAxis(
                                majorGridLines: MajorGridLines(width: 0),
                                minimum: 0,
                                maximum: 100,
                                interval: 20,
                              ),
                              tooltipBehavior: tooltip,
                              onSelectionChanged: (v) {},
                              series: <CartesianSeries<YearChartData, String>>[
                                ColumnSeries<YearChartData, String>(
                                  dataSource: widget.yearChartData,
                                  xValueMapper: (YearChartData data, _) => data.time,
                                  yValueMapper: (YearChartData data, _) => data.ml / data.goal * 100,
                                  name: '',
                                  selectionBehavior: SelectionBehavior(selectedColor: blueColor, enable: true, toggleSelection: false),
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25.r), topRight: Radius.circular(25.r)),
                                  gradient: LinearGradient(
                                      colors: [greyColor, greyColor.withOpacity(0.5), whiteColor],
                                      begin: Alignment.bottomLeft,
                                      end: Alignment.topRight),
                                )
                              ]),
                        ),
                        SizedBox(height: 20.h),
                        TextWidget(text: 'goalarchived'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        TextWidget(
                            text: 'thegoalwas'.tr.replaceAll('XX', (widget.data['GOAL_ACHIEVED_COUNT'] ?? 0).toString()),
                            maxLines: 2,
                            fontSize: 13.sp,
                            color: textColor,
                            fontFamily: 'R'),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/goalmedal.svg'),
                            SizedBox(width: 5.w),
                            TextWidget(
                                text: '${(widget.data['GOAL_ACHIEVED_COUNT'] ?? 0).toString()}/365',
                                fontSize: 16.sp,
                                color: blueColor,
                                fontFamily: 'B'),
                            const Spacer(),
                            TextWidget(
                                text: '${((widget.data['GOAL_ACHIEVED_COUNT'] ?? 0) / 365 * 100).toStringAsFixed(2)}%',
                                fontSize: 16.sp,
                                color: blueColor,
                                fontFamily: 'B'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                    child: Slider(
                      value: (widget.data['GOAL_ACHIEVED_COUNT'] ?? 0) / 365,
                      inactiveColor: greyColor.withOpacity(0.5),
                      onChanged: (double v) {},
                      activeColor: blueColor,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(text: 'records'.tr, fontSize: 20.sp, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'SM'),
                        SizedBox(height: 5.h),
                        ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: groupedMessages),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.only(top: height / 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset('assets/lottie/NoData.json', height: 120.h, width: 120.h),
                  SizedBox(height: 15.h),
                  TextWidget(text: 'noreport'.tr, color: Theme.of(context).textTheme.titleMedium!.color, fontFamily: 'M', fontSize: 15.sp),
                ],
              ),
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
