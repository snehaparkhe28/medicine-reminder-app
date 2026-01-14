import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/utils/awesome_notifications.dart'; // Keep this
// Remove this line: import 'package:medicine_reminder/core/utils/notifications.dart';
import 'package:medicine_reminder/presentation/widgets/medicine_card.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/medicine_repository.dart';
import 'add_medicine_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medicine Reminder',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Test notification button
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () async {
              await context.read<MedicineRepository>().testNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Test notification sent!')),
              );
            },
            tooltip: 'Test Notification',
          ),

          // Check pending notifications
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () async {
              final pendingList =
                  await AwesomeNotificationsService.checkPendingNotifications();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pending Notifications'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: pendingList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.notifications),
                          title: Text(pendingList[index]),
                        );
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Check Pending',
          ),
          // Clear all button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All Medicines'),
                  content: const Text(
                    'Are you sure you want to delete all medicines?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<MedicineRepository>().clearAll();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Consumer<MedicineRepository>(
        builder: (context, repository, child) {
          final medicines = repository.medicines;

          if (medicines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No Medicines Added',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tap the + button to add your first medicine',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: medicines.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final medicine = medicines[index];
              return MedicineCard(medicine: medicine);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMedicinePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
