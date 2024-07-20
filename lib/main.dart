import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/AppTheme/apptheme.dart';
import 'package:water_tracker/Constant/constant.dart';
import 'package:water_tracker/Localization/applanguage.dart';
import 'package:water_tracker/UI/splash_screen.dart';
import 'package:water_tracker/firebase_options.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // isWear = (await IsWear().check()) ?? false;

  // /// automatically get breadcrumb logs to understand user actions leading up to a crash, non-fatal, or ANR event
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };
  //
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
  //
  // /// This data can help you understand basic interactions, such as how many times your app was opened, and how many users were active in a chosen time period.
  // FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (payload) async {});

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);

  await getUserId();
  await configureLocalTimeZone();
  await appTracking();
  await getProfileData();
  isNotification.value = box.read('isNotification') ?? false;

  privacyController = WebViewController()..loadRequest(Uri.parse('https://vocsyinfotech.in/vocsy/flutter/Water_Reminder/privacyPolicy.php'));

  termsController = WebViewController()..loadRequest(Uri.parse('https://vocsyinfotech.in/vocsy/flutter/Water_Reminder/tearmsConditions.php'));

  runApp(ChangeNotifierProvider(
      create: (context) {
        ThemeNotifier(ThemeMode.values[themeMode]).setThemeMode(ThemeMode.values[themeMode]);
        return ThemeNotifier(ThemeMode.values[themeMode]);
      },
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void didChangePlatformBrightness() {
    if (themeMode == 0) {
      AppTheme.setSystemUIOverlayStyle(ThemeMode.values[themeMode]);
    }
    super.didChangePlatformBrightness();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<ThemeNotifier>(context);

    return ScreenUtilInit(
        designSize: isTab(context) ? const Size(585, 812) : const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Water Reminder',
            debugShowCheckedModeBanner: false,
            locale: Locale(box.read('languageCode') ?? 'en'),
            translations: AppTranslations(),
            themeMode: notifier.getThemeMode,
            darkTheme: AppTheme.darkTheme,
            theme: AppTheme.lightTheme,
           // home: const DemoPage(),
             home: const SplashScreen(),
          );
        });
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int count = 0;
  final MethodChannel channel = const MethodChannel('iphoneTowatch');


  Future<void> initFlutterChannel() async {
    channel.setMethodCallHandler((call) async {
      // Receive data from Native
      switch (call.method) {
        case "sendCounterToFlutter":
          count = call.arguments["data"]["counter"];
          print('hello 1 count ====== $count');
         increment();
          break;
        default:
          break;
      }
    });
  }

  Future increment() async {
    setState(() {
      count += 1;
    });
    await channel.invokeMethod("flutterToWatch", {"method": "sendCounterToNative", "data": count});
    print('hello 2 count ====== $count');
  }

  @override
  void initState() {
    super.initState();
    initFlutterChannel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF27C0C1),
        title: const Text('Demo', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Total Count',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
