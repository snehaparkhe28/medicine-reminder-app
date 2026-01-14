import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/medicine.dart';
import '../../core/utils/awesome_notifications.dart';

class MedicineRepository extends ChangeNotifier {
  static const String _key = 'medicines';
  List<Medicine> _medicines = [];

  List<Medicine> get medicines {
    final sortedList = List<Medicine>.from(_medicines);
    sortedList.sort((a, b) {
      final timeA = a.time.hour * 60 + a.time.minute;
      final timeB = b.time.hour * 60 + b.time.minute;
      return timeA.compareTo(timeB);
    });
    return sortedList;
  }

  Future<void> init() async {
    await _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _medicines = jsonList.map((json) => Medicine.fromJson(json)).toList();

        // Reschedule notifications for all medicines
        await _rescheduleAllNotifications();

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading medicines: $e');
      _medicines = [];
    }
  }

  Future<void> _saveMedicines() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _medicines.map((medicine) => medicine.toJson()).toList();
      await prefs.setString(_key, json.encode(jsonList));
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving medicines: $e');
    }
  }

  Future<void> addMedicine(Medicine medicine) async {
    _medicines.add(medicine);
    await _saveMedicines();

    // Schedule notification
    await _scheduleMedicineNotification(medicine);
  }

  Future<void> updateMedicine(String id, Medicine updatedMedicine) async {
    final index = _medicines.indexWhere((medicine) => medicine.id == id);
    if (index != -1) {
      // Cancel old notification
      await _cancelMedicineNotification(_medicines[index]);

      _medicines[index] = updatedMedicine;
      await _saveMedicines();

      // Schedule new notification
      await _scheduleMedicineNotification(updatedMedicine);
    }
  }

  Future<void> deleteMedicine(String id) async {
    final medicine = _medicines.firstWhere((m) => m.id == id);

    // Cancel notification before deleting
    await _cancelMedicineNotification(medicine);

    _medicines.removeWhere((medicine) => medicine.id == id);
    await _saveMedicines();
  }

  Future<void> toggleTakenStatus(String id) async {
    final index = _medicines.indexWhere((medicine) => medicine.id == id);
    if (index != -1) {
      final medicine = _medicines[index];
      final updatedMedicine = medicine.copyWith(isTaken: !medicine.isTaken);
      _medicines[index] = updatedMedicine;
      await _saveMedicines();

      // Update notifications
      if (updatedMedicine.isTaken) {
        await _cancelMedicineNotification(updatedMedicine);
      } else {
        await _scheduleMedicineNotification(updatedMedicine);
      }
    }
  }

  Future<void> clearAll() async {
    // Cancel all notifications
    await AwesomeNotificationsService.cancelAllMedicineNotifications();

    _medicines.clear();
    await _saveMedicines();
  }

  // Notification methods

  // In medicine_repository.dart
  Future<void> _scheduleMedicineNotification(Medicine medicine) async {
    if (!medicine.isTaken) {
      final notificationId = AwesomeNotificationsService.getNotificationId(
        medicine.id,
      );

      await AwesomeNotificationsService.scheduleDailyMedicineNotification(
        id: notificationId,
        medicineName: medicine.name,
        dose: medicine.dose,
        time: medicine.time,
        medicineId: medicine.id,
      );
    }
  }

  Future<void> _cancelMedicineNotification(Medicine medicine) async {
    final notificationId = AwesomeNotificationsService.getNotificationId(
      medicine.id,
    );
    await AwesomeNotificationsService.cancelNotification(notificationId);
  }

  Future<void> _rescheduleAllNotifications() async {
    // Cancel all existing notifications
    await AwesomeNotificationsService.cancelAllMedicineNotifications();

    // Schedule notifications for all medicines that aren't taken
    for (final medicine in _medicines) {
      if (!medicine.isTaken) {
        await _scheduleMedicineNotification(medicine);
      }
    }
  }

  // Test notification
  Future<void> testNotification() async {
    await AwesomeNotificationsService.showTestNotification();
  }

  // Check pending notifications
  Future<void> checkPendingNotifications() async {
    await AwesomeNotificationsService.checkPendingNotifications();
  }
}
