import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';
import '../../models/quality_model.dart';
import 'add_edit_quality_screen.dart';

class QualityListScreen extends StatelessWidget {
  const QualityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data
    final List<Quality> qualities = [
      Quality(
        id: '1',
        name: 'Cotton 60s',
        ratePerMeter: 12.50,
        description: 'Standard cotton fabric',
        createdAt: DateTime.now(),
      ),
      Quality(
        id: '2',
        name: 'Polyester 40s',
        ratePerMeter: 9.75,
        description: 'Synthetic fabric for rough use',
        createdAt: DateTime.now(),
      ),
      Quality(
        id: '3',
        name: 'Silk Blend',
        ratePerMeter: 45.00,
        description: 'Premium silk blend',
        createdAt: DateTime.now(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qualities'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: qualities.length,
        itemBuilder: (context, index) {
          final quality = qualities[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            elevation: 2,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.amber[100],
                child: const Icon(Icons.grade, color: Colors.amber),
              ),
              title: Text(quality.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(quality.description),
              trailing: Text(
                '₹${quality.ratePerMeter.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditQualityScreen(qualityId: quality.id),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditQualityScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
