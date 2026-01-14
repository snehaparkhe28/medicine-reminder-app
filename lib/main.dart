import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/app_theme.dart';
import 'package:medicine_reminder/presentation/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'data/repositories/medicine_repository.dart';
import 'core/utils/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize awesome notifications
  await AwesomeNotificationsService.initialize();

  // Initialize repository
  final repository = MedicineRepository();
  await repository.init();

  runApp(ChangeNotifierProvider.value(value: repository, child: const MyApp()));
}

Future<void> _checkNotificationPermission() async {
  final isAllowed = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowed) {
    // You can show a custom dialog here to explain why notifications are needed
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
