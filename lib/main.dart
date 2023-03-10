import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:heal_fit/provider/provider.dart';
import 'package:heal_fit/screens/screens.dart';
import 'package:heal_fit/utils/utility.dart';
import 'package:heal_fit/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/config.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.max,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class ReceivedNotification {
  ReceivedNotification({
    required this.url,
  });

  final String url;
}

String? selectedNotificationPayload;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

//Firebase Initialisation
  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  //Device Orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //Provider Definition
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainContainerProvider()),
        ChangeNotifierProvider(create: (_) => LoginPageViewModel()),
        ChangeNotifierProvider(create: (_) => DeepLink()),
      ],
      child: const MyApp(),
    ),
  );
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = AppColors.white
    ..backgroundColor = AppColors.richBlack
    ..indicatorColor = AppColors.white
    ..textColor = AppColors.white
    ..maskColor = AppColors.richBlack.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;
  bool isTokenLoaded = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire(BuildContext context) async {
    Application.deepLinkUrl = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedToken = prefs.getString('token') ?? '';
    if (savedToken.isEmpty) {
      String? token;
      String? apnsToken;
      try {
        _initialized = true;
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        if (Platform.isIOS) {
          apnsToken = await messaging.getAPNSToken();
          NotificationSettings settings = await messaging.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
          Utility.printLog(
              'User granted permission: ${settings.authorizationStatus}');
        }
        token = await messaging.getToken();
        if (token != null) {
          Utility.printLog('FCM token $token');
          //Saving FCM token to local data
          Application.deviceToken = token;
          prefs.setString('token', token);
        }
      } catch (e) {
        Utility.printLog(e.toString());
        _error = true;
      }
    } else {
      Application.deviceToken = savedToken;
      Utility.printLog('SAVED FCM token $savedToken');
    }
    setState(() => {isTokenLoaded = true});
    if (context.read<DeepLink>().deepLinkUrl.isEmpty) {
      FirebaseMessaging.instance.getInitialMessage().then((message) {
        context.read<DeepLink>().setDeepLinkUrl('');
        if (message != null) {
          Utility.printLog('Initial Message clicked!');
          Utility.printLog(message.data["openURL"].toString());
          context
              .read<DeepLink>()
              .setDeepLinkUrl(message.data["openURL"].toString());
          Application.isDeepLink = true;
          Application.deepLinkUrl = message.data["openURL"].toString();
        }
        message = null;
      });
    } else {
      context.read<DeepLink>().setDeepLinkUrl('');
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      Utility.printLog("message recieved =${message.data["openURL"]}");
      if (android != null) {
        context.read<DeepLink>().setDeepLinkUrl('notifications');
      }
      if (notification != null) {
        if (message.data["openURL"].toString().contains('book')) {
          Fluttertoast.showToast(
            msg: "Go check our books",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.cardBg,
            textColor: AppColors.richBlack,
            fontSize: 16.0,
          );
        } else if (message.data["openURL"].toString().contains('program')) {
          Fluttertoast.showToast(
            msg: "Go check our programs",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.lightCardBg,
            textColor: AppColors.richBlack,
            fontSize: 16.0,
          );
        } else if (message.data["openURL"].toString().contains('blog')) {
          Fluttertoast.showToast(
            msg: "Go check our blogs",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.lightCardBg,
            textColor: AppColors.richBlack,
            fontSize: 16.0,
          );
        } else if (message.data["openURL"].toString().contains('myPrograms')) {
          Fluttertoast.showToast(
            msg: "Your session is starting in 15 min",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.lightCardBg,
            textColor: AppColors.richBlack,
            fontSize: 16.0,
          );
        } else if (message.data["openURL"]
            .toString()
            .contains('foodCalories')) {
          Fluttertoast.showToast(
            msg: "Fill up your food calorie data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.lightCardBg,
            textColor: AppColors.richBlack,
            fontSize: 16.0,
          );
        } else if (message.data["openURL"]
            .toString()
            .contains('exerciseCalories')) {
          Fluttertoast.showToast(
            msg: "Fill up your workout log",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            backgroundColor: AppColors.lightCardBg,
            textColor: AppColors.richBlack,
            fontSize: 16.0,
          );
        }
        // context
        //     .read<DeepLink>()
        //     .setDeepLinkUrl(message.data["openURL"].toString());
      }
      Application.isDeepLink = true;
      Application.deepLinkUrl = message.data["openURL"].toString();
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Utility.printLog('Message clicked!');
      Utility.printLog(message.data["openURL"].toString());
      context
          .read<DeepLink>()
          .setDeepLinkUrl(message.data["openURL"].toString());
      Application.isDeepLink = true;
      Application.deepLinkUrl = message.data["openURL"].toString();
    });
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      Utility.printLog('First Dynamic Link = ${data.link.toString()}');
      context.read<DeepLink>().setDeepLinkUrl(data.link.toString());
      Application.isDeepLink = true;
      Application.deepLinkUrl = data.link.toString();
    }
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      Utility.printLog('Second Dynamic Link = ${dynamicLinkData.link}');
      context.read<DeepLink>().setDeepLinkUrl(dynamicLinkData.link.toString());
      Application.isDeepLink = true;
      Application.deepLinkUrl = dynamicLinkData.link.toString();
    }).onError((error) {
      Utility.printLog('onLink error');
      Utility.printLog(error.message);
    });
  }

  @override
  void initState() {
    super.initState();
    initializeFlutterFire(context);
    initDynamicLinks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !isTokenLoaded
        ? const MaterialApp(
            home: Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            debugShowCheckedModeBanner: false,
          )
        : GetMaterialApp(
            builder: EasyLoading.init(),
            title: 'HealFit',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: AppColors.background,
              fontFamily: Fonts.gilroyRegular,
            ),
            getPages: [
              GetPage(
                name: Routes.splashScreen,
                page: () => const SplashScreen(),
              ),
              GetPage(
                name: Routes.firebaseLinkRoutes,
                page: () => const MainContainer(),
              ),
            ],
            initialRoute: Routes.splashScreen,
            debugShowCheckedModeBanner: false,
          );
  }
}

class Routes {
  static const String splashScreen = '/';
  static const String firebaseLinkRoutes = '/link';
}
