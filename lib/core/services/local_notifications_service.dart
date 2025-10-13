import 'dart:async';
// import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:doctor_client/main.dart';

import '../utils/extensions.dart';
import 'server_gate.dart';

class GlobalNotification {
  static String _deviceToken = "";

  static Future<String> getFcmToken() async {
    try {
      if (_deviceToken.isNotEmpty) return _deviceToken;
      if (Platform.isIOS) {
        await FirebaseMessaging.instance.getAPNSToken();
        await Future.delayed(const Duration(seconds: 1));
      }
      _deviceToken = await FirebaseMessaging.instance.getToken() ?? "";
      // print("--------- Global Notification Logger --------> \x1B[37m------ FCM TOKEN -----\x1B[0m");
      // print('<--------- Global Notification Logger --------> \x1B[32m $_deviceToken\x1B[0m');
      // ignore: avoid_print
      print("device token : $_deviceToken");
      return _deviceToken;
    } catch (e) {
      print("-=-=-=-=- $e");
      return 'postman';
    }
  }

  late FirebaseMessaging _firebaseMessaging;

  updateFcm() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      CustomResponse response = await ServerGate.i.patchToServer(
        url: "client/profile/fcm_update",
        body: {"type": Platform.isAndroid ? "android" : "ios", "device_token": _deviceToken},
      );
      if (response.statusCode == 200) {
        print('<--------- Fcm was updated successfully --------> \x1B[32m $_deviceToken\x1B[0m');
      }
    });
  }

  StreamController<Map<String, dynamic>> get notificationSubject {
    return _onMessageStreamController;
  }

  void killNotification() {
    _onMessageStreamController.close();
  }

  late FlutterLocalNotificationsPlugin _notificationsPlugin;

  Map<String, dynamic> _not = {};

  Future<void> setUpFirebase() async {
    getFcmToken();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.setAutoInitEnabled(true);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    // checkLastMessage();
    firebaseCloudMessagingListeners();
    _notificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isAndroid) await _firebaseMessaging.requestPermission(alert: true, announcement: false, badge: true, sound: true);
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = const DarwinInitializationSettings(
      defaultPresentBadge: true,
      defaultPresentAlert: true,
      defaultPresentSound: true,
    );
    var initSetting = InitializationSettings(android: android, iOS: ios);
    _notificationsPlugin.initialize(initSetting, onDidReceiveNotificationResponse: onSelectNotification);
  }

  Future<void> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOSPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage data) {
      // print("--------- Global Notification Logger --------> \x1B[37m------ on Notification message data -----\x1B[0m");
      // print('<--------- Global Notification Logger --------> \x1B[32m ${data.data}\x1B[0m');
      // print('<--------- Global Notification Logger --------> \x1B[32m ${data.notification?.android?.channelId}\x1B[0m');
      // print('<--------- Global Notification Logger --------> \x1B[32m ${data.notification?.android?.sound}\x1B[0m');
      _onMessageStreamController.add(data.data);

      _not = data.data;
      if (Platform.isAndroid) {
        showNotification(data);
      } else {
        // showNotification(data);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage data) {
      // ignore: avoid_print
      print("--------- Global Notification Logger --------> \x1B[37m------ on Opened -----\x1B[0m");
      // ignore: avoid_print
      print('<--------- Global Notification Logger --------> \x1B[32m ${data.data}\x1B[0m');
      // ignore: avoid_print
      print('<--------- Global Notification Logger --------> \x1B[32m ${data.notification?.android?.channelId}\x1B[0m');
      handlePath(data.data);
    });
  }

  Future<void> showNotification(RemoteMessage data) async {
    var iOSPlatformSpecifics = const DarwinNotificationDetails();

    var androidChannelSpecifics = AndroidNotificationDetails(
      'lohtak',
      "لوحتك",
      channelDescription: "Lohtak",
      importance: Importance.high,
      colorized: true,
      color: '#70C656'.color,
      priority: Priority.high,
    );
    var notificationDetails = NotificationDetails(android: androidChannelSpecifics, iOS: iOSPlatformSpecifics);
    if (data.notification != null) {
      await _notificationsPlugin.show(0, data.notification!.title, data.notification!.body, notificationDetails);
    }
  }

  // _downloadAndSaveFile(String url, String fileName) async {
  //   var directory = await getApplicationDocumentsDirectory();
  //   var filePath = '${directory.path}/$fileName';
  //   var response = await http.get(Uri.parse(url));
  //   var file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

  void iOSPermission() {
    _firebaseMessaging.requestPermission(alert: true, announcement: true, badge: true, sound: true);
  }

  void handlePath(Map<String, dynamic> dataMap) {
    handlePathByRoute(dataMap);
  }

  Future<void> handlePathByRoute(Map<String, dynamic> dataMap) async {
    // String type = dataMap["notify_type"].toString();
    // ignore: avoid_print
    print("--------- Global Notification Logger --------> \x1B[37m------ key -----\x1B[0m");
    // ignore: avoid_print
    print('<--------- Global Notification Logger --------> \x1B[32m handlePathByRoute $dataMap\x1B[0m');
    // if (User.i.isAuth == false) {
    // } else if (type == "new_message") {
    //   push(NamedRoutes.i.chatSupport);
    // } else {
    //   push(NamedRoutes.i.notifications);
    // }
  }

  onSelectNotification(NotificationResponse? onSelectNotification) async {
    // print("--------- Global Notification Logger --------> \x1B[37m------ payload -----\x1B[0m");
    // print('<--------- Global Notification Logger --------> \x1B[32m ${onSelectNotification?.notificationResponseType}\x1B[0m');
    handlePath(_not);
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage data) async {
  // If you're going to use other Firebase services in the dat, such as Firestore,
  // make sure you call initializeApp before using other Firebase services.
  // _onMessageStreamController.add(message.data);
  // if (Platform.isAndroid) {
  //   GlobalNotification().showNotificationWithAttachment(
  //       data.data,
  //       data.notification.title,
  //       data.notification.body,
  //       data.notification.android.imageUrl);
  // } else {
  //   GlobalNotification().showNotificationWithAttachment(
  //       data.data,
  //       data.notification.title,
  //       data.notification.body,
  //       data.notification.apple.imageUrl);
  // }
  // main();
  // print("Handling a background message: ${data.data}");
}

StreamController<Map<String, dynamic>> _onMessageStreamController = StreamController.broadcast();
