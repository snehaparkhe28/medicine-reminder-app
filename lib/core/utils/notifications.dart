// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     // Android initialization
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // iOS initialization
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//         );

//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS,
//         );

//     await _notificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         debugPrint('Notification clicked: ${response.payload}');
//       },
//     );
//   }

//   static Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//           'medicine_channel',
//           'Medicine Reminders',
//           channelDescription: 'Notifications for medicine reminders',
//           importance: Importance.max,
//           priority: Priority.high,
//           ticker: 'ticker',
//         );

//     const DarwinNotificationDetails iosPlatformChannelSpecifics =
//         DarwinNotificationDetails();

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iosPlatformChannelSpecifics,
//     );

//     await _notificationsPlugin.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: payload,
//     );
//   }

//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDate,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//           'medicine_channel',
//           'Medicine Reminders',
//           channelDescription: 'Notifications for medicine reminders',
//           importance: Importance.max,
//           priority: Priority.high,
//         );

//     const DarwinNotificationDetails iosPlatformChannelSpecifics =
//         DarwinNotificationDetails();

//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iosPlatformChannelSpecifics,
//     );

//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate,
//       platformChannelSpecifics,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       payload: payload,
//     );
//   }

//   static Future<void> cancelNotification(int id) async {
//     await _notificationsPlugin.cancel(id);
//   }

//   static Future<void> cancelAllNotifications() async {
//     await _notificationsPlugin.cancelAll();
//   }
// }
