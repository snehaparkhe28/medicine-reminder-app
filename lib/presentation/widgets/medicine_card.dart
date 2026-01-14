import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/medicine.dart';
import '../../data/repositories/medicine_repository.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  const MedicineCard({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Time Circle
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    medicine.formattedTime,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColor,
                    ),
                  ),
                  if (medicine.isTimePassed && !medicine.isTaken)
                    const Text(
                      'Missed',
                      style: TextStyle(fontSize: 10, color: Colors.red),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Medicine Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dose: ${medicine.dose}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Action Buttons
            Row(
              children: [
                // Taken Toggle
                IconButton(
                  onPressed: () {
                    context.read<MedicineRepository>().toggleTakenStatus(
                      medicine.id,
                    );
                  },
                  icon: Icon(
                    medicine.isTaken
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    color: medicine.isTaken ? Colors.green : Colors.grey,
                  ),
                ),
                // Delete Button
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Medicine'),
                        content: Text('Delete ${medicine.name}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              context.read<MedicineRepository>().deleteMedicine(
                                medicine.id,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
