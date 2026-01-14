import 'dart:typed_data';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AwesomeNotificationsService {
  // Channel keys
  static const String medicineChannelKey = 'medicine_reminder';

  // Initialize notifications
  static Future<void> initialize() async {
    try {
      // Check and request permission
      bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }

      // Request exact alarm permission on Android 12+
      await _requestExactAlarmPermission();

      // Create channel
      await AwesomeNotifications().initialize(
        null, // null means default app icon
        [
          NotificationChannel(
            channelKey: medicineChannelKey,
            channelName: 'Medicine Reminders',
            channelDescription: 'Medicine reminder notifications',
            defaultColor: const Color(0xFF008080), // Teal
            ledColor: Colors.white,
            importance: NotificationImportance.High,
            playSound: true,
            enableVibration: true,
          ),
        ],
      );

      // Set up listeners
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: onActionReceivedMethod,
        onNotificationCreatedMethod: onNotificationCreatedMethod,
        onNotificationDisplayedMethod: onNotificationDisplayedMethod,
        onDismissActionReceivedMethod: onDismissActionReceivedMethod,
      );

      debugPrint('Awesome Notifications initialized successfully');
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  // Request exact alarm permission on Android 12+
  static Future<void> _requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await Permission.scheduleExactAlarm.status;
      if (androidInfo.isDenied || androidInfo.isPermanentlyDenied) {
        final result = await Permission.scheduleExactAlarm.request();
        if (result.isGranted) {
          debugPrint('Exact alarm permission granted');
        } else {
          debugPrint('Exact alarm permission denied');
        }
      }
    }
  }

  // Callback methods - MUST be static
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('Action received: ${receivedAction.buttonKeyPressed}');

    final payload = receivedAction.payload ?? {};
    final medicineId = payload['medicineId']?.toString();
    final medicineName = payload['medicineName']?.toString();
    final actionKey = receivedAction.buttonKeyPressed;

    debugPrint('Notification action: $actionKey for medicine: $medicineName');

    // Handle different actions
    switch (actionKey) {
      case 'taken':
        debugPrint('Medicine $medicineName marked as taken');
        break;
      case 'snooze':
        debugPrint('Snoozing notification for $medicineName');
        _snoozeNotification(payload);
        break;
      default:
        debugPrint('Notification tapped: $medicineName');
        break;
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification created: ${receivedNotification.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    debugPrint('Notification displayed: ${receivedNotification.title}');
  }

  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    debugPrint('Notification dismissed: ${receivedAction.id}');
  }

  // Show a test notification
  static Future<void> showTestNotification() async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 999,
          channelKey: medicineChannelKey,
          title: 'Medicine Reminder Test ✅',
          body: 'This is a test notification from your medicine app!',
          notificationLayout: NotificationLayout.Default,
          color: const Color(0xFF008080), // Teal
          payload: {'type': 'test'},
        ),
      );
      debugPrint('Test notification shown');
    } catch (e) {
      debugPrint('Error showing test notification: $e');
    }
  }

  // Schedule daily medicine notification
  static Future<void> scheduleDailyMedicineNotification({
    required int id,
    required String medicineName,
    required String dose,
    required TimeOfDay time,
    required String medicineId,
  }) async {
    try {
      // Calculate next occurrence (today if time hasn't passed, tomorrow if it has)
      final now = DateTime.now();
      final scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );

      // If the time has already passed today, schedule for tomorrow
      final nextOccurrence = scheduledTime.isBefore(now)
          ? scheduledTime.add(const Duration(days: 1))
          : scheduledTime;

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: medicineChannelKey,
          title: '💊 Time for $medicineName',
          body: 'Take $medicineName ($dose) now',
          notificationLayout: NotificationLayout.Default,
          color: const Color(0xFF008080),
          payload: {
            'type': 'medicine',
            'medicineId': medicineId,
            'medicineName': medicineName,
            'dose': dose,
          },
        ),
        schedule: NotificationCalendar(
          year: nextOccurrence.year,
          month: nextOccurrence.month,
          day: nextOccurrence.day,
          hour: time.hour,
          minute: time.minute,
          second: 0,
          millisecond: 0,
          repeats: true, // Repeat daily
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'taken',
            label: 'Mark as Taken',
            color: Colors.green,
            autoDismissible: true,
          ),
          NotificationActionButton(
            key: 'snooze',
            label: 'Snooze 10 min',
            color: Colors.orange,
            autoDismissible: true,
          ),
        ],
      );

      debugPrint(
        'Scheduled daily notification for $medicineName at ${time.hour}:${time.minute} (next occurrence: ${nextOccurrence.toString()})',
      );
    } catch (e) {
      debugPrint('Error scheduling daily notification: $e');
    }
  }

  // Snooze notification
  static void _snoozeNotification(Map<String, String?> payload) {
    try {
      final medicineName = payload['medicineName'] ?? 'Medicine';
      final dose = payload['dose'] ?? '';

      // Schedule a new notification for 10 minutes later
      final snoozeTime = DateTime.now().add(const Duration(minutes: 10));
      final notificationId = DateTime.now().millisecondsSinceEpoch % 100000;

      // Convert nullable map to non-nullable map
      final nonNullablePayload = <String, String>{};
      payload.forEach((key, value) {
        if (value != null) {
          nonNullablePayload[key] = value;
        }
      });

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: medicineChannelKey,
          title: '⏰ Snoozed: $medicineName',
          body: 'Reminder for $medicineName ($dose)',
          notificationLayout: NotificationLayout.Default,
          color: const Color(0xFF008080),
          payload: nonNullablePayload,
        ),
        schedule: NotificationCalendar.fromDate(date: snoozeTime),
      );
    } catch (e) {
      debugPrint('Error snoozing notification: $e');
    }
  }

  // Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    try {
      await AwesomeNotifications().cancel(id);
      debugPrint('Cancelled notification with id: $id');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }

  // Cancel all medicine notifications
  static Future<void> cancelAllMedicineNotifications() async {
    try {
      await AwesomeNotifications().cancelAll();
      debugPrint('Cancelled all notifications');
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }

  // Get notification ID from medicine ID
  static int getNotificationId(String medicineId) {
    // Generate a positive integer ID from the medicine ID
    return medicineId.hashCode.abs() % 100000;
  }

  // Check pending notifications
  static Future<List<String>> checkPendingNotifications() async {
    try {
      final pending = await AwesomeNotifications().listScheduledNotifications();
      debugPrint('=== PENDING NOTIFICATIONS (${pending.length}) ===');

      final List<String> pendingList = [];

      if (pending.isEmpty) {
        debugPrint('No pending notifications');
        pendingList.add('No pending notifications');
        return pendingList;
      }

      for (final notification in pending) {
        final schedule = notification.schedule;
        final content = notification.content;

        String notificationInfo;
        if (schedule is NotificationCalendar) {
          notificationInfo =
              '${content?.title ?? 'Unknown'} at ${schedule.hour}:${schedule.minute.toString().padLeft(2, '0')}';
          debugPrint('• $notificationInfo');
        } else {
          notificationInfo = content?.title ?? 'Unknown notification';
          debugPrint('• $notificationInfo');
        }
        pendingList.add(notificationInfo);
      }

      return pendingList;
    } catch (e) {
      debugPrint('Error checking pending notifications: $e');
      return ['Error checking pending notifications: $e'];
    }
  }

  // Clear all notifications
  static Future<void> clearAllNotifications() async {
    await AwesomeNotifications().cancelAll();
    await AwesomeNotifications().dismissAllNotifications();
  }
}
